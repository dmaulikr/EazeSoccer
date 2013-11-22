//
//  FootballPlaceKickerStats.m
//  EazeSportz
//
//  Created by Gil on 11/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FootballPlaceKickerStats.h"

@implementation FootballPlaceKickerStats

@synthesize fgattempts;
@synthesize fgblocked;
@synthesize fglong;
@synthesize fgmade;
@synthesize xpattempts;
@synthesize xpblocked;
@synthesize xpmade;
@synthesize xpmissed;

@synthesize football_place_kicker_id;
@synthesize athlete_id;
@synthesize gameschedule_id;

- (id)init {
    if (self = [super init]) {
        fgattempts = [NSNumber numberWithInt:0];
        fgblocked = [NSNumber numberWithInt:0];
        fglong = [NSNumber numberWithInt:0];
        fgmade = [NSNumber numberWithInt:0];

        xpattempts = [NSNumber numberWithInt:0];
        xpblocked = [NSNumber numberWithInt:0];
        xpmade = [NSNumber numberWithInt:0];
        xpmissed = [NSNumber numberWithInt:0];
        
        athlete_id = @"";
        gameschedule_id = @"";
        football_place_kicker_id = @"";

        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)placekickerDictionary {
    if ((self = [super init]) && (placekickerDictionary.count > 0)) {
        fgattempts = [placekickerDictionary objectForKey:@"fgattempts"];
        fgblocked = [placekickerDictionary objectForKey:@"fgblocked"];
        fglong = [placekickerDictionary objectForKey:@"fglong"];
        fgmade = [placekickerDictionary objectForKey:@"fgmade"];
        
        xpmissed = [placekickerDictionary objectForKey:@"xpmissed"];
        xpmade = [placekickerDictionary objectForKey:@"xpmade"];
        xpattempts = [placekickerDictionary objectForKey:@"xpattempts"];
        xpblocked = [placekickerDictionary objectForKey:@"xpblocked"];
        
        athlete_id = [placekickerDictionary objectForKey:@"athlete_id"];
        gameschedule_id = [placekickerDictionary objectForKey:@"gameschedule_id"];
        football_place_kicker_id = [placekickerDictionary objectForKey:@"football_place_kicker_id"];
        
        return self;
    } else
        return nil;
}

@end
