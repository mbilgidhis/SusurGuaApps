//
//  SGGuaDetailViewController.m
//  SusurGua
//
//  Created by Indra Purnama on 8/14/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import "SGGuaDetailViewController.h"
#import "SWRevealViewController.h"



@interface SGGuaDetailViewController ()

@end

@implementation SGGuaDetailViewController

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
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //Get Detail Gua from api
    NSString *post = [NSString stringWithFormat:@"id=%@", self.guaViewID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://susurgua.com/gapi/public/cave/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *theReply = [NSJSONSerialization
                              JSONObjectWithData:POSTReply
                              
                              options:kNilOptions
                              error:nil];
    
    NSArray *specificGua = [[theReply objectForKey:@"data"] copy];

    //Title
    NSString *name = [[specificGua objectAtIndex:0] objectForKey:@"name"];
    self.title = name;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Pin Image
    self.pin = [UIImage imageNamed:@"pin.png"];
    [self.pinView setImage:self.pin];
    
    //Kelurahan
    NSDictionary *kelurahan = [[specificGua objectAtIndex:0] objectForKey:@"kelurahan"];
    if([kelurahan count] != 0){
       self.kelurahan.text = [[NSString alloc] initWithString:(@"%@",[kelurahan objectForKey:@"name"])];
    }else{
        self.kelurahan.text = @"";
    }
    
    //Kecamatan
    NSDictionary *kecamatan = [[specificGua objectAtIndex:0]objectForKey:@"kecamatan"];
    if([kecamatan count] != 0){
        self.kecamatan.text = [[NSString alloc] initWithString:(@"%@",[kecamatan objectForKey:@"name"])];
    }else{
        self.kecamatan.text = @"";
    }

    //Kabupaten
    NSDictionary *kabupaten = [[specificGua objectAtIndex:0] objectForKey:@"kabupaten"];
    if([kabupaten count] != 0){
        self.kabupaten.text = [[NSString alloc] initWithString:(@"%@",[kabupaten objectForKey:@"name"])];
    }else{
        self.kabupaten.text = @"";
    }
    

    //Coordinates
    NSArray *coordinateDict = [[specificGua objectAtIndex:0] objectForKey:@"coordinates"];
    NSString *lat = [[coordinateDict objectAtIndex:0]objectForKey:@"latitude"];
    NSString *longi = [[coordinateDict objectAtIndex:0]objectForKey:@"longitude"];
    if([coordinateDict count] != 0){
        //self.latitude.text = [[NSString alloc] initWithString:(@"S %@", [[coordinateDict objectAtIndex:0]objectForKey:@"latitude"])];
        //self.longitude.text = [[NSString alloc] initWithString:(@"E %@", [[coordinateDict objectAtIndex:0]objectForKey:@"longitude"])];
        
        self.latitude.text = [[NSString alloc] initWithString:[NSString stringWithFormat:@"S%@", lat]];
        self.longitude.text = [[NSString alloc] initWithString:[NSString stringWithFormat:@"E%@", longi]];
    }

    //Image
    /*
    NSArray *imgArray = [[specificGua objectAtIndex:0] objectForKey:@"images"];
    if([imgArray count] != 0){
        NSString *imgURL = [[imgArray objectAtIndex:0] objectForKey:@"file"];
        self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]]];
        [self.imageView setImage:self.image];
    }else{
        NSString *key = @"AIzaSyC4u0qz49U32rHZg90iLOyxbFSn_fwL6Fg";
        NSString *imgURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=14&size=600x300&markers=%@,%@&key=%@", lat, longi, lat, longi, key];
        
        self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]]];
        [self.imageView setImage:self.image];
    }
    */
    
    NSArray *imgArray = [[specificGua objectAtIndex:0] objectForKey:@"images"];
    if([imgArray count] != 0){
        self.imgURL = [[imgArray objectAtIndex:0] objectForKey:@"file"];
    }else{
        NSString *key = @"AIzaSyC4u0qz49U32rHZg90iLOyxbFSn_fwL6Fg";
        self.imgURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=14&size=600x300&markers=%@,%@&key=%@", lat, longi, lat, longi, key];
    }
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadImage)
                                        object:nil];
    [queue addOperation:operation];
    //[operation release];
    
    //Jenis Gua
    NSDictionary *jenisDict = [[specificGua objectAtIndex:0]objectForKey:@"type"];
    if([jenisDict count] != 0){
        self.jenis.text = [[NSString alloc] initWithString:(@"%@", [jenisDict objectForKey:@"name"])];
    }else{
        self.jenis.text = @"";
    }
    
    //Description
    
    self.description.text = [[NSString alloc] initWithString:(@"%@",[[specificGua objectAtIndex:0] objectForKey:@"description"])];
    [self.description sizeToFit];
    
    //CGRect frame = self.description.frame;
    //frame.size.height = self.description.contentSize.height;
    //self.description.frame = frame;
    
    
    //Contact
    NSArray *contact = [[specificGua objectAtIndex:0]objectForKey:@"contacts"];
    if([contact count] != 0){
        self.phone.text = [[NSString alloc] initWithString:[[contact objectAtIndex:0] objectForKey:@"phone"]];
        self.email.text = [[NSString alloc] initWithString:[[contact objectAtIndex:0] objectForKey:@"email"]];
    }else{
        self.email.text = @"";
        self.phone.text = @"";
    }
    /*
    //Gears
    NSArray *gearsAll = [[specificGua objectAtIndex:0]objectForKey:@"gears"];
    //NSLog(@"%@, %i",gearsAll, [gearsAll count]);
    
    
    if([gearsAll count] != 0){
       
        NSMutableString *gear = [NSMutableString stringWithCapacity:gearsAll.count*30];
        for(int x = 0; x < [gearsAll count]; x++){
            [gear appendFormat:@"\u2022 %@\n", [[gearsAll objectAtIndex:0] objectForKey:@"name"]];
        }
        //NSLog(@"%@", gear);
        self.gears.text = gear;
    }else{
        self.gears.text = @"";
    }
    */
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.content.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.content.contentSize = contentRect.size;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadImage {
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.imgURL]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)image {
    [self.imageView setImage:image]; //UIImageView
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
