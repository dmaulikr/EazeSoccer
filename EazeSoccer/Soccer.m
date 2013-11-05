//
//  Soccer.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "Soccer.h"

@implementation Soccer

@synthesize soccerid;
@synthesize gameschedule_id;
@synthesize goals;
@synthesize shotstaken;
@synthesize assists;
@synthesize steals;
@synthesize goalsagainst;
@synthesize goalssaved;
@synthesize shutouts;
@synthesize minutesplayed;

- (id)init {
    if (self = [super init]) {
        soccerid = @"";
        gameschedule_id = @"";
        goals = 0;
        shotstaken = 0;
        assists = 0;
        steals = 0;
        goalsagainst = 0;
        goalssaved = 0;
        shutouts = 0;
        minutesplayed = 0;
        return self;
    } else
        return nil;
}

- (id)initWithDirectory:(NSDictionary *)soccerDirectory {
    if ((self = [super init]) && (soccerDirectory.count > 0)) {
        soccerid = [soccerDirectory objectForKey:@"soccerid"];
        gameschedule_id = [soccerDirectory objectForKey:@"gameschedule_id"];
        goals = [soccerDirectory objectForKey:@"goals"];
        shotstaken = [soccerDirectory objectForKey:@"shotstaken"];
        assists = [soccerDirectory objectForKey:@"assists"];
        steals = [soccerDirectory objectForKey:@"steals"];
        goalsagainst = [soccerDirectory objectForKey:@"goalsagainst"];
        goalssaved = [soccerDirectory objectForKey:@"goalssaved"];
        shutouts = [soccerDirectory objectForKey:@"shutouts"];
        minutesplayed = [soccerDirectory objectForKey:@"minutesplayed"];
        return self;
    } else {
        return nil;
    }
}

- (BOOL)goalieStats {
    if (([goalssaved intValue] > 0) || ([goalsagainst intValue] > 0) || ([shutouts intValue] > 0))
        return YES;
    else
        return NO;
}

@end
