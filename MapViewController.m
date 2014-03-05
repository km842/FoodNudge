//
//  MapViewController.m
//  FoodNudge
//
//  Created by Kunal  on 25/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "MapViewController.h"
#import "MapPoint.h"

@interface MapViewController ()

@end


@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self.mapView setShowsUserLocation:YES];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.distanceFilter = 1;
    [locationManager startUpdatingLocation];
    MKCircle *radius = [MKCircle circleWithCenterCoordinate:locationManager.location.coordinate radius:1000];
    [self.mapView addOverlay:radius];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) queryGoogle: (CLLocation*) point {
    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/locations?lat=%f&long=%f", point.coordinate.latitude, point.coordinate.longitude];
//    NSLog(@"%@", url);
    NSURL *request = [NSURL URLWithString:url];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: request];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
//    NSLog(@"lat%f - lon%f", point.coordinate.latitude, point.coordinate.longitude);
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
//    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
//    NSLog(@"Google Data: %@", json);
    [self plotPositions:json];
}

#pragma mark - MKMapViewDelegate Methods

-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 1000, 1000);
    [mapView setRegion:region animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    [self queryGoogle:location];
    [locationManager stopUpdatingLocation];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}
-(MKOverlayRenderer*) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 1;
    renderer.strokeColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
    renderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    return renderer;
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    NSLog(@"did update user location");
//    [self.mapView removeAnnotations:mapView.annotations];
////    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = userLocation.coordinate;
//    point.title = @"Working";
//    [self.mapView addAnnotation:point];
}

-(void)plotPositions:(NSArray *)data {
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    NSLog(@"%i", [data count]);
    
    for (int i = 0; i < [data count]; i++) {
        NSArray* place = [data objectAtIndex:i];
        NSDictionary *geo = [place valueForKey:@"geometry"];
        NSLog(@"1");
        NSArray *loc = [geo valueForKey:@"location"];
        NSArray *vicinity = [place valueForKey:@"vicinity"];
        NSArray *name = [place valueForKey:@"name"];
        NSLog(@"4");
        for (int j = 0; j < [loc count]; j++) {
            CLLocationCoordinate2D placeCoord;
            placeCoord.latitude = [[[loc valueForKey:@"lat"] objectAtIndex:j] doubleValue];
            placeCoord.longitude = [[[loc valueForKey:@"lng"] objectAtIndex:j] doubleValue];
//            NSLog(@"lat is: %@",);
            NSString *name1 = [name objectAtIndex:j];
            NSString *vicinity1 = [vicinity objectAtIndex:j];
            MapPoint *placeObject = [[MapPoint alloc] initWithName: name1 address:vicinity1 coordinate:placeCoord];
            [self.mapView addAnnotation:placeObject];
//            NSLog(@"name = %@, address = %@", name1, vicinity1);

        }
//        if ([loc valueForKey:@"lat"] && [loc valueForKey:@"long"]) {
//            NSLog(@"lat");
//        placeCoord.latitude = [[loc valueForKey:@"lat"] doubleValue];
//        placeCoord.latitude = locationManager.location.coordinate.latitude;
//        placeCoord.longitude = locationManager.location.coordinate.longitude;


//
//        }
//        NSLog(@"%@", name);
    }
}

@end
