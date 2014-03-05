//
//  MapViewController.h
//  FoodNudge
//
//  Created by Kunal  on 25/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344
#define kGOOGLE_API_KEY @"AIzaSyCK7y0TT49xIi3IafMxbsmvrykDLlYNpMA"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKLocalSearchResponse *results;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
