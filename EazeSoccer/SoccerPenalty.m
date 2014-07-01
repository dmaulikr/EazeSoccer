//
//  SoccerPenalty.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerPenalty.h"

@implementation SoccerPenalty

@synthesize soccer_stat_id;
@synthesize soccer_penalty_id;

@synthesize infraction;
@synthesize card;
@synthesize gametime;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)soccer_penalty_dictionary {
    if (self == [super init]) {
        soccer_penalty_id = [soccer_penalty_dictionary objectForKey:@"soccer_penalty_id"];
        soccer_stat_id = [soccer_penalty_dictionary objectForKey:@"soccer_stat_id"];
        infraction = [soccer_penalty_dictionary objectForKey:@"infraction"];
        card = [soccer_penalty_dictionary objectForKey:@"card"];
        gametime = [soccer_penalty_dictionary objectForKey:@"gametime"];
        period = [soccer_penalty_dictionary objectForKey:@"period"];
        
        return self;
    } else
        return nil;
}

@end
