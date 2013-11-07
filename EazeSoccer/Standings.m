//
//  Standings.m
//  Basketball Console
//
//  Created by Gil on 10/22/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Standings.h"

@implementation Standings

@synthesize teamname;
@synthesize mascot;
@synthesize leaguelosses;
@synthesize leaguewins;
@synthesize nonleaguelosses;
@synthesize nonleaguewins;
@synthesize sportid;
@synthesize gameschedule_id;
@synthesize oppimageurl;
@synthesize teamid;

- (id)initWithDirectory:(NSDictionary *)standingsDirectory {
    if ((self = [super init]) && (standingsDirectory.count > 0)) {
        teamname = [standingsDirectory objectForKey:@"teamname"];
        mascot = [standingsDirectory objectForKey:@"mascot"];
        leaguewins = [standingsDirectory objectForKey:@"leaguewins"];
        leaguelosses = [standingsDirectory objectForKey:@"leaguelosses"];
        nonleaguewins = [standingsDirectory objectForKey:@"nonleaguewins"];
        nonleaguelosses = [standingsDirectory objectForKey:@"nonleaguelosses"];
        gameschedule_id = [standingsDirectory objectForKey:@"gameschedule_id"];
        sportid = [standingsDirectory objectForKey:@"sportid"];
        teamid = [standingsDirectory objectForKey:@"teamid"];
        
        if ((NSNull *)[standingsDirectory objectForKey:@"oppimageurl"] != [NSNull null])
            oppimageurl = [standingsDirectory objectForKey:@"oppimageurl"];
        else
            oppimageurl = @"";
        
        return self;
    } else {
        return nil;
    }
}

@end
