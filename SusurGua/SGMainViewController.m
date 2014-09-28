//
//  SGMainViewController.m
//  SusurGua
//
//  Created by Indra Purnama on 8/11/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import "SGMainViewController.h"
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SGMarkerMap.h"
#import "SGGuaDetailViewController.h"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SGMainViewController ()

@end

@implementation SGMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Change button color
    //_sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    
    self.navigationItem.leftBarButtonItem = _sidebarButton;
    self.navigationItem.rightBarButtonItem = nil;
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Set Title
    self.title = @"Susur Gua";
    
    
    //Data from api
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://susurgua.com/gapi/public/caves_simplify/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *theReply = [NSJSONSerialization
                              JSONObjectWithData:POSTReply
                              
                              options:kNilOptions
                              error:nil];
    
    NSArray *data = [theReply objectForKey:@"data"];
    self.marker = [data copy];
    //NSLog(@"data %@",self.marker);
    
    
    
    //_locationManager.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    //For Map Kit;
    _mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D mark;
    for(int i =0; i < [self.marker count]; i++){
        double lat = [[self.marker[i] objectForKey:@"latitude"] doubleValue];
        double longi = [[self.marker[i] objectForKey:@"longitude"] doubleValue];
        mark.latitude = lat;
        mark.longitude = longi;
        
        self.annot = [[SGMarkerMap alloc] init];
        self.annot.coordinate = mark;
        self.annot.title = [self.marker[i] objectForKey:@"name"];
                
        [self.mapView addAnnotation:self.annot];
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 50000, 50000);
   [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    if(annotation == mapView.userLocation){
        /*
        annotationView.image = [UIImage imageNamed:@"default.png"];
        annotationView.canShowCallout = YES;
        return annotationView;
         */
        return nil;
    }else{
        annotationView.canShowCallout = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        button.frame = CGRectMake(0, 0, 15, 15);
        annotationView.rightCalloutAccessoryView = button;
        
        //annotationView.image = [UIImage imageNamed:@"default.png"];
        //annotationView.center=CGPointMake(-100, -1000);
        return annotationView;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //NSLog(@"%@",view.annotation.title);
    self.guaID = [[NSMutableString alloc]init];
    for(int i = 0; i < [self.marker count]; i++){
        if([self.marker[i] objectForKey:@"name"] == view.annotation.title){
            self.guaID = [self.marker[i] objectForKey:@"id"];
        }
    }
    
    // Perform Segue
    //[self performSegueWithIdentifier:@"map_detail" sender:self];
    if ((int)[[UIScreen mainScreen] bounds].size.height >= 568)
    {
        // This is iPhone 5 screen
        // Perform Segue
        [self performSegueWithIdentifier:@"map_detail" sender:self];
    } else {
        // This is iPhone 4/4s screen
        [self performSegueWithIdentifier:@"segue_test" sender:self];
    }
}



//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[SGGuaDetailViewController class]]){
        [(SGGuaDetailViewController *)segue.destinationViewController setGuaViewID:self.guaID];
        
        //Reset Boot Cover
        [self setGuaID:nil];
        
    }
}


@end
