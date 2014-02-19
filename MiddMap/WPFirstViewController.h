//
//  WPFirstViewController.h
//  MiddMap
//
//  Created by Will Potter on 1/29/14.
//  Copyright (c) 2014 Will Potter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface WPFirstViewController : UIViewController<NSURLConnectionDelegate,MKMapViewDelegate>
{
    NSMutableData *_responseData;

}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
