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
@synthesize athleteid;

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

- (id)initWithDirectory:(NSDictionary *)basketballStatDirectory AthleteId:(NSString *)playerid {
    if ((self = [super init]) && (basketballStatDirectory.count > 0)) {
        twoattempt = [basketballStatDirectory objectForKey:@"twoattempt"];
        twomade = [basketballStatDirectory objectForKey:@"twomade"];
        threeattempt = [basketballStatDirectory objectForKey:@"threeattempt"];
        threemade = [basketballStatDirectory objectForKey:@"threemade"];
        ftattempt = [basketballStatDirectory objectForKey:@"ftattempt"];
        ftmade = [basketballStatDirectory objectForKey:@"ftmade"];
        fouls = [basketballStatDirectory objectForKey:@"fouls"];
        assists = [basketballStatDirectory objectForKey:@"assists"];
        steals = [basketballStatDirectory objectForKey:@"steals"];
        blocks = [basketballStatDirectory objectForKey:@"blocks"];
        offrebound = [basketballStatDirectory objectForKey:@"offrebound"];
        defrebound = [basketballStatDirectory objectForKey:@"defrebound"];
        basketball_stat_id = [basketballStatDirectory objectForKey:@"basketball_stat_id"];
        gameschedule_id = [basketballStatDirectory objectForKey:@"gameschedule_id"];
        athleteid = playerid;
        return self;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    BasketballStats *copy = [[BasketballStats alloc] init];
    copy.twoattempt = twoattempt;
    copy.twomade = twomade;
    copy.threeattempt = threeattempt;
    copy.threemade = threemade;
    copy.ftattempt = ftattempt;
    copy.ftmade = ftmade;
    copy.fouls = fouls;
    copy.blocks = blocks;
    copy.steals = steals;
    copy.assists = assists;
    copy.defrebound = defrebound;
    copy.offrebound = offrebound;
    copy.gameschedule_id = gameschedule_id;
    copy.basketball_stat_id = basketball_stat_id;
    copy.athleteid = athleteid;
    return copy;
}

@end
