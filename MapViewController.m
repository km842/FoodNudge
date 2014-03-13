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
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.distanceFilter = 100;
    [locationManager startUpdatingLocation];

    MKCircle *radius = [MKCircle circleWithCenterCoordinate:locationManager.location.coordinate radius:1000];
    [self.mapView addOverlay:radius];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.mapView setShowsUserLocation:YES];
    [_segmentedControl addTarget:self action:@selector(mapTypeChange:) forControlEvents:UIControlEventValueChanged];
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)mapTypeChange:(id)sender {
    int selected = [sender selectedSegmentIndex];
    switch (selected) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            _segmentedControl.tintColor = [UIColor blueColor];
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            _segmentedControl.tintColor = [UIColor whiteColor];
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            _segmentedControl.tintColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
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
    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    [self plotPositions:json];
}

#pragma mark - MKMapViewDelegate Methods

-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 3000, 3000);
    [mapView setRegion:region animated:YES];
    [self queryGoogle:locationManager.location];
//    NOT SURE IF THIS HACK WORKS!!!!!
    mapView.delegate = nil;
}

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation *location = [locations lastObject];
//    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
//    [self queryGoogle:location];
//    [locationManager stopUpdatingLocation];
//    self.mapView.centerCoordinate = location.coordinate;
//}

//-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
//    MKMapRect mRect = self.mapView.visibleMapRect;
//    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
//    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
//    
//    //Set your current distance instance variable.
//    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
//    
//    //Set your current center point on the map instance variable.
//    currentCentre = self.mapView.centerCoordinate;
//}
-(MKOverlayRenderer*) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 1;
    renderer.strokeColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
    renderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    return renderer;
}

//-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    MKCoordinateRegion mapRegion;
////    mapRegion.center = mapView.userLocation.coordinate;
//    mapRegion.center = self.mapView.centerCoordinate;
//    mapRegion.span.latitudeDelta = 0.2;
//    mapRegion.span.longitudeDelta = 0.2;
//    currentCentre = self.mapView.centerCoordinate;
//    
//    [mapView setRegion:mapRegion animated: YES];
////    [self queryGoogle:self.mapView.userLocation.location];
//
//}

-(void)plotPositions:(NSArray *)data {
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
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
    }
}

@end
