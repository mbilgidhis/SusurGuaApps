//
//  SGMarkerMap.h
//  SusurGua
//
//  Created by Indra Purnama on 8/19/14.
//  Copyright (c) 2014 Indra Purnama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SGMarkerMap : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
}

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;

@end
