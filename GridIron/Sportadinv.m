
//
//  Sportadinv.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "Sportadinv.h"

@implementation Sportadinv

@synthesize sportadinvid;
@synthesize sportid;
@synthesize adlevelname;
@synthesize price;
@synthesize forsale;
@synthesize expiration;

- (id)initWithDirectory:(NSDictionary *)sportadinvDictionary {
    if ((self = [super init]) && (sportadinvDictionary.count > 0)) {
        
        sportadinvid = [sportadinvDictionary objectForKey:@"id"];
        sportid = [sportadinvDictionary objectForKey:@"sport_id"];
        adlevelname = [sportadinvDictionary objectForKey:@"adlevelname"];
        price = [[sportadinvDictionary objectForKey:@"price"] floatValue];
        forsale = [[sportadinvDictionary objectForKey:@"active"] boolValue];
        expiration = [sportadinvDictionary objectForKey:@"expiration"];
        
        return self;
    } else
        return nil;
}

- (id)initDelete {
    self = nil;
    return self;
}

@end
