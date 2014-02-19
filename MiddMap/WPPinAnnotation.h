//
//  WPPinAnnotation.h
//  MiddMap
//
//  Created by Will Potter on 1/30/14.
//  Copyright (c) 2014 Will Potter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WPPinAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

// add an init method so you can set the coordinate property on startup
- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;



@end
