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
/*!
 This class MapViewController manages the map during the application.
 */
@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKLocalSearchResponse *results;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    double walkingSpeed;
    double runningSpeed;
    double averageHeartRate;
    double weight;
}

/*!
 @param MKMapView mapView
 Instance of the map view to allow methods to be called and data to be received from the map.
 */
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/*!
 @param UISegmentedControl segmentedControl
 SegementedControl that controls the type of map the suer would like to view.
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlForOverlay;
@property (assign, nonatomic) double calories; //needs to be set from previous view controller

/*!
 @Function mapTypeChange
 @param id sender
 Distinguishes which action causes the method to execute with the relative sequence of code.
 @result
 Changes the type of the map
 */
-(IBAction)mapTypeChange:(id)sender;

/*!
 @Function calculateWalking
 @result
 Calculates the distance required to walk given the number of calories.
 */
-(double) calculateWalking;

/*!
 @Function calculateRunning
 @result
 Calculates the distance required to run given the number of calories.
 */
-(double) calculateRunning;

/*!
 @Function V02MAX
 @result
 Returns a value that calculates the V02 max of the user.
 */
-(double)VO2MAX;

/*!
 @Function queryGoogle
 @param CLLocation point
 The location of the user encapsulated in an iOS specific variable.
 @result
 Passes a list of locations nearby.
 */
-(void) queryGoogle:(CLLocation*) point;

/*!
 @Function plotPositions
 @param NSArray data
 Data gathered from the query google search.
 @result
 Plots the positions of the data received via the query.
 */
-(void)plotPositions:(NSArray *)data;
@end
