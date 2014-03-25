//
//  MapPoint.h
//  FoodNudge
//
//  Created by Kunal  on 28/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
/*!
 This class, MapPoint, overides the annotation object to produce custom annontation.
 */

@interface MapPoint : NSObject <MKAnnotation>
{
    
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    
}

/*!
 @param NSString name
 Holds the name of the location that corresponds to a particular Map Point.
 */
@property (copy) NSString *name;

/*!
 @param NSString address
 Holds the address of the Map Point.
 */
@property (copy) NSString *address;

/*!
 @param CLLocationCoordinate2D coordinate
 Holds the coordinate of the point in a iOS defined coordinate system
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


/*!
 @Function id initWithNameaddresscoordinate
 @param NSString name
 The name of the location of the map point.
 @param NSString address
 The address of the location of the map point.
 @param CLLocationCoordinate2D
 The coordinate of the location of the corresponding map point.
 @result
 Initializes a Map Point with the respective data noted above.
 */
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end