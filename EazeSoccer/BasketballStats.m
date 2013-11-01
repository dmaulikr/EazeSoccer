//
//  BasketballStats.m
//  Basketball Console
//
//  Created by Gilbert Zaldivar on 9/19/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "BasketballStats.h"

@implementation BasketballStats

@synthesize twoattempt;
@synthesize twomade;
@synthesize threeattempt;
@synthesize threemade;
@synthesize ftmade;
@synthesize ftattempt;
@synthesize fouls;
@synthesize assists;
@synthesize steals;
@synthesize blocks;
@synthesize offrebound;
@synthesize defrebound;

@synthesize gameschedule_id;
@synthesize basketball_stat_id;

- (id)init {
    if (self = [super init]) {
        self.twoattempt = [NSNumber numberWithInt:0];
        self.twomade = [NSNumber numberWithInt:0];
        self.threeattempt = [NSNumber numberWithInt:0];
        self.threemade = [NSNumber numberWithInt:0];
        self.ftattempt = [NSNumber numberWithInt:0];
        self.ftmade = [NSNumber numberWithInt:0];
        self.fouls = [NSNumber numberWithInt:0];
        self.blocks = [NSNumber numberWithInt:0];
        self.steals = [NSNumber numberWithInt:0];
        self.assists = [NSNumber numberWithInt:0];
        self.defrebound = [NSNumber numberWithInt:0];
        self.offrebound = [NSNumber numberWithInt:0];
        self.gameschedule_id = @"";
        self.basketball_stat_id = @"";
        return self;
    } else
        return nil;
}

@end
