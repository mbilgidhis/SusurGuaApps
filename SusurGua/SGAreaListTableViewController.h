//
//  SGAreaListTableViewController.h
//  SusurGua
//
//  Created by Indra Purnama on 8/14/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface SGAreaListTableViewController : UITableViewController <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    //CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property NSArray *listGuaProvinsi;

//set to gua detail
@property NSString *guaID;

//get from area table view
@property NSString *areaListTitle;
@property NSString *areaListID;

@end
