//
//  FootballReceivingStat.m
//  EazeSportz
//
//  Created by Gil on 11/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FootballReceivingStat.h"

@implementation FootballReceivingStat

@synthesize average;
@synthesize fumbles;
@synthesize fumbles_lost;
@synthesize longest;
@synthesize receptions;
@synthesize td;
@synthesize yards;
@synthesize twopointconv;

@synthesize football_receiving_id;
@synthesize athlete_id;
@synthesize gameschedule_id;

- (id)init {
    if (self = [super init]) {
        average = [NSNumber numberWithInt:0];
        fumbles = [NSNumber numberWithInt:0];
        fumbles_lost = [NSNumber numberWithInt:0];
        longest = [NSNumber numberWithInt:0];
        receptions = [NSNumber numberWithInt:0];
        td = [NSNumber numberWithInt:0];
        yards = [NSNumber numberWithInt:0];
        twopointconv = [NSNumber numberWithInt:0];
        
        athlete_id = @"";
        gameschedule_id = @"";
        football_receiving_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)receivingDictionary {
    if ((self = [super init]) && (receivingDictionary.count > 0)) {
        average = [receivingDictionary objectForKey:@"average"];
        fumbles_lost = [receivingDictionary objectForKey:@"fumbles_lost"];
        fumbles = [receivingDictionary objectForKey:@"fumbles"];
        longest = [receivingDictionary objectForKey:@"longest"];
        receptions = [receivingDictionary objectForKey:@"receptions"];
        td = [receivingDictionary objectForKey:@"td"];
        yards = [receivingDictionary objectForKey:@"yards"];
        twopointconv = [receivingDictionary objectForKey:@"twopointconv"];
        
        athlete_id = [receivingDictionary objectForKey:@"athlete_id"];
        gameschedule_id = [receivingDictionary objectForKey:@"gameschedule_id"];
        football_receiving_id = [receivingDictionary objectForKey:@"football_receiving_id"];
        
        return self;
    } else
        return nil;
}

@end
