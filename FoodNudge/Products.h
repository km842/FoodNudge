//
//  Products.h
//  FoodNudge
//
//  Created by Kunal  on 04/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Products : NSObject {
}

@property (nonatomic, retain) NSString *pid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *calories;
@property (nonatomic, retain) NSString *sugar;
@property (nonatomic, retain) NSString *fat;
@property (nonatomic, retain) NSString *saturates;
@property (nonatomic, retain) NSString *salt;

-(id) initWithId: (NSString*)Ppid name:(NSString*)Pname calories: (NSString*)Pcalories sugar:(NSString*)Psugar fat:(NSString*)Pfat saturates:(NSString*)Psaturates salt:(NSString *)Psalt;


@end
