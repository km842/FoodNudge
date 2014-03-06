//
//  Products.m
//  FoodNudge
//
//  Created by Kunal  on 04/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "Products.h"

@implementation Products

@synthesize pid;
@synthesize name;
@synthesize calories;
@synthesize sugar;
@synthesize fat;;
@synthesize saturates;
@synthesize salt;

-(id) initWithId: (NSString*)Ppid name:(NSString*)Pname calories: (NSString*)Pcalories sugar:(NSString*)Psugar fat:(NSString*)Pfat saturates:(NSString*)Psaturates salt:(NSString *)Psalt {
    self = [super init];
    self.pid = Ppid;
    self.name = Pname;
    self.calories = Pcalories;
    self.sugar = Psugar;
    self.fat = Pfat;
    self.saturates = Psaturates;
    self.salt = Psalt;
    
    return self;
}
@end
