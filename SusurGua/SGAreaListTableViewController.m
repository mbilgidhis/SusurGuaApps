//
//  SGAreaListTableViewController.m
//  SusurGua
//
//  Created by Indra Purnama on 8/14/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import "SGAreaListTableViewController.h"
#import "SWRevealViewController.h"
#import "SGGuaDetailViewController.h"
#import "SGTableViewDistanceCell.h"
#import <CoreLocation/CoreLocation.h>
#import "SGMainViewController.h"

@interface SGAreaListTableViewController ()

@end

@implementation SGAreaListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    
    self.title = self.areaListTitle;
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Get Per Area Gua from api
    
    //post message
    NSString *post = [NSString stringWithFormat:@"id=%@", self.areaListID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://susurgua.com/gapi/public/caves/province/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *theReply = [NSJSONSerialization
                              JSONObjectWithData:POSTReply
                              
                              options:kNilOptions
                              error:nil];
    
    NSArray *data = [theReply objectForKey:@"data"];
    
    self.listGuaProvinsi = [data copy];
    
    //Set Current Location;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.listGuaProvinsi count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell Identifier";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //Fetch Author
    NSDictionary *listArea = [self.listGuaProvinsi objectAtIndex:[indexPath row]];
    
    //Configure Cell
    [cell.textLabel setText:[listArea objectForKey:@"name"]];
    return cell;
     */
    static NSString *CellIdentifer = @"showDistance";
    SGTableViewDistanceCell *cell = (SGTableViewDistanceCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewDistance" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //Fetch Area
    NSDictionary *listArea = [self.listGuaProvinsi objectAtIndex:[indexPath row]];
    cell.listGua.text = [listArea objectForKey:@"name"];
    
    //Get Jarak
    CLLocation *here = locationManager.location;
    if(here){
        if([[[self.listGuaProvinsi objectAtIndex:[indexPath row]] objectForKey:@"coordinates"] count] > 0 ){
            NSString * latitude = [[[[self.listGuaProvinsi objectAtIndex:[indexPath row]] objectForKey:@"coordinates"] objectAtIndex:0] objectForKey:@"latitude"];
            NSString *longitude = [[[[self.listGuaProvinsi objectAtIndex:[indexPath row]] objectForKey:@"coordinates"] objectAtIndex:0] objectForKey:@"longitude"];
            double lat = [latitude doubleValue];
            double longi = [longitude doubleValue];
            CLLocation *gua = [[CLLocation alloc] initWithLatitude:(@"%f", lat) longitude:(@"%f", longi)];
            //CLLocation *here = locationManager.location;
            CLLocationDistance jarak = [gua distanceFromLocation:here];
            NSString *dist = [NSString stringWithFormat:@"%4.2f \n km", jarak/1000];
            cell.jarak.text = dist;
        }
        else{
            cell.jarak.text = @"";
        }
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor colorWithRed:74/255.0 green:207/255.0 blue:221/255.0 alpha:0.5]];
    [tableView setSeparatorInset:UIEdgeInsetsMake(0.1, 10, 01, 10)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Detail Gua
    NSDictionary *detail = [self.listGuaProvinsi objectAtIndex:[indexPath row]];
    
    self.guaID = [detail objectForKey:@"id"];
    
    if ((int)[[UIScreen mainScreen] bounds].size.height == 568)
    {
        // This is iPhone 5 screen
        // Perform Segue
        [self performSegueWithIdentifier:@"segue_guadetail" sender:self];
    } else {
        // This is iPhone 4/4s screen
        [self performSegueWithIdentifier:@"segue_test" sender:self];
    }
    
    // Perform Segue
    //[self performSegueWithIdentifier:@"segue_guadetail" sender:self];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

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
