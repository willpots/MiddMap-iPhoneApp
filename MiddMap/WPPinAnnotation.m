//
//  WPPinAnnotation.m
//  MiddMap
//
//  Created by Will Potter on 1/30/14.
//  Copyright (c) 2014 Will Potter. All rights reserved.
//

#import "WPPinAnnotation.h"

@implementation WPPinAnnotation

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord
{
    _coordinate = coord;
    return self;
}

- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}
@end
