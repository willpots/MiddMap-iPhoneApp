//
//  WPFirstViewController.m
//  MiddMap
//
//  Created by Will Potter on 1/29/14.
//  Copyright (c) 2014 Will Potter. All rights reserved.
//

#import "WPFirstViewController.h"
#import "WPUtil.h"
#import "WPPinAnnotation.h"
#import "WPPinAnnotationView.h"

#define METERS_PER_MILE 1609.344

@interface WPFirstViewController ()

@end

@implementation WPFirstViewController

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:_responseData
                     options:0
                     error:&error];
        
        if(error) {
            NSLog(@"Bad JSON from the server");
        } if([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *results = object;
            double latDelt = 0.025;
            double lngDelt = 0.025;
            CLLocationCoordinate2D center;
            center.latitude = (CLLocationDegrees) 44.009465;
            center.longitude = (CLLocationDegrees) -73.175983;

            MKCoordinateSpan span = MKCoordinateSpanMake(latDelt, lngDelt);
            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
            for (id key in results)
            {
                NSArray *events = [results objectForKey:@"events"];
                for (NSDictionary *dict in events) {
                    NSDictionary *place = [dict objectForKey:@"place"];
                    NSNumber *lat = [place objectForKey:@"lat"];
                    NSNumber *lng = [place objectForKey:@"lng"];
                    CLLocationCoordinate2D coord;
                    coord.latitude = (CLLocationDegrees)[lat doubleValue];
                    coord.longitude = (CLLocationDegrees)[lng doubleValue];
                    WPPinAnnotation *point = [[WPPinAnnotation alloc] init];
                    point.coordinate = coord;
                    point.title = [dict objectForKey:@"name"];
                    point.subtitle = [dict objectForKey:@"raw_location"];
                    
                    [self.mapView addAnnotation:point];

                }
            }
            [_mapView setRegion:region animated:NO];
        } else {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 44.009465;
    zoomLocation.longitude= -73.175983;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.middmap.com/events.json"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    UIView *subView =[[NSBundle mainBundle] loadNibNamed:@"MyNib" owner:self options:0];
//    [view addSubview:subView];

}
- (WPPinAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *viewId = @"MKPinAnnotationView";

    WPPinAnnotationView *annotationView = [[WPPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewId];
    // set your custom image
    UIImage *raw_image = [UIImage imageNamed:@"pin-icon.png"];
    annotationView.image = [WPUtil imageWithImage:raw_image scaledToSize:CGSizeMake(40, 40)];;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
