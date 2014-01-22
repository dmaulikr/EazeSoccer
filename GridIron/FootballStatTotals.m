//
//  FootballStatTotals.m
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "FootballStatTotals.h"

@implementation FootballStatTotals

@synthesize totalfirstdowns;
@synthesize totalyards;
@synthesize rushingtotalyards;
@synthesize passingtotalyards;
@synthesize penalties;
@synthesize penaltyyards;
@synthesize turnovers;

- (id)initWithDictionary:(NSDictionary *)footballStatTotals {
    if ((self = [super init]) && (footballStatTotals.count > 0)) {
        totalyards = [footballStatTotals objectForKey:@"totalyards"];
        totalfirstdowns = [footballStatTotals objectForKey:@"totalfirstdowns"];
        rushingtotalyards = [footballStatTotals objectForKey:@"rushingtotalyards"];
        passingtotalyards = [footballStatTotals objectForKey:@"passingtotalyards"];
        penaltyyards = [footballStatTotals objectForKey:@"penaltyyards"];
        penalties = [footballStatTotals objectForKey:@"penalties"];
        turnovers = [footballStatTotals objectForKey:@"turnovers"];
        
        return self;
    } else {
        return nil;
    }
}

@end
