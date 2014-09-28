//
//  SGMainViewController.h
//  SusurGua
//
//  Created by Indra Purnama on 8/11/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SGMarkerMap.h"


@interface SGMainViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property CLLocationManager *locationManager;
@property NSArray *marker;

@property SGMarkerMap *annot;

@property NSMutableString *guaID;

@end
