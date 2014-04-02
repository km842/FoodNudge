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
    walkingSpeed = 5;
    runningSpeed = 10;
    averageHeartRate = 80;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    weight = [[defaults objectForKey:@"weight"] doubleValue];

    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.distanceFilter = 100;
    [locationManager startUpdatingLocation];
    [self.mapView setShowsUserLocation:YES];

    
    MKCircle *radius = [MKCircle circleWithCenterCoordinate:locationManager.location.coordinate radius:[self calculateWalking] * walkingSpeed * 1000];
    [self.mapView addOverlay:radius];
    MKCircle *running = [MKCircle circleWithCenterCoordinate:locationManager.location.coordinate radius:[self calculateRunning]*1000];
    [self.mapView addOverlay:running];
    NSLog(@"radius here is: %f", [self calculateWalking]);
    
    self.mapView.showsPointsOfInterest = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self.mapView setShowsUserLocation:YES];
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
            _segmentedControl.tintColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
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
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 6000, 6000);
    [mapView setRegion:region animated:YES];
    [self queryGoogle:locationManager.location];
//    NOT SURE IF THIS HACK WORKS!!!!!
//    mapView.delegate = nil;
}

-(MKOverlayRenderer*) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 1;
    renderer.strokeColor = [UIColor colorWithRed:0.42 green:0.67 blue:0.91 alpha:1.0];
    renderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    return renderer;
}

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

#pragma mark - calculate distance using formulas

-(double) calculateWalking {
   //    double weight = 100; //user defaults
    NSLog(@"CAlories val is : %f", _calories);
    double time = _calories / (((0.0215 * pow(walkingSpeed, 3)) - (0.1765 * pow(walkingSpeed, 2)) + (0.8710 * walkingSpeed) + 1.4577) * weight);
    NSLog(@"Time is: %f", time);
    return time;
}

-(double) calculateRunning {
//    double weight = 100; //user defaults
//    double caloriesToBurn = 400; //needs to be sent from previous view controller - product detail
    double distance = 0.0;
    distance = (int)_calories /(((0.05 * 5) + 0.95) * weight) * [self VO2MAX];
    return distance;
}

-(double)VO2MAX {
//    double age = 23;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [defaults objectForKey:@"dob"];
    NSDate *og = [formatter dateFromString:dateString];
    NSLog(@"date string is: %@", dateString);
    NSLog(@"og is :%@", og);
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSLog(@"formetted : %@", [formatter stringFromDate:og]);
    NSString *changed = [formatter stringFromDate:og];
    NSDate *bday = [formatter dateFromString:changed];
    NSLog(@"bday is:%@",bday);
    NSDate *now = [NSDate date];
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:bday
                                       toDate:now
                                       options:0];
    
    double age = [ageComponents year];
    NSLog(@"age is : %f", age);
    double mhr = 208 - (0.7*age); //user defaults
    double vo2 = 15.3 * (mhr/averageHeartRate);
    double cff;
    
    if (vo2 < 44) {
        cff = 1.07;
    }
    if (46 > vo2 >= 44) {
        cff = 1.06;
    }
    if (48 > vo2 >= 46) {
        cff = 1.05;
    }
    if (50 > vo2 >= 48) {
        cff = 1.04;
    }
    if (52 > vo2 >= 50) {
        cff = 1.03;
    }
    if (54 > vo2 >= 54) {
        cff = 1.02;
    }
    if (56 > vo2 >= 54) {
        cff = 1.01;
    }
    if (vo2 >= 56) {
        cff = 1;
    }
    return cff;
}





@end
