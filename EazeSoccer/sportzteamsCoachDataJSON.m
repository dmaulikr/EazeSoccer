//
//  sportzteamsCoachDataJSON.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzteamsCoachDataJSON.h"
#import "Coach.h"

@implementation sportzteamsCoachDataJSON

- (void)processCoachData:(NSArray *)serverData {
    _coaches = [[NSMutableArray alloc] init];
    for (int i = 0; i < [serverData count]; i++) {
        NSDictionary *items = [serverData objectAtIndex:i];
        Coach *coach = [[Coach alloc] init];
        coach.coachid = [items objectForKey:@"id"];
        coach.bio = [items objectForKey:@"bio"];
        coach.fullname = [items objectForKey:@"full_name"];
        coach.firstname = [items objectForKey:@"firstname"];
        coach.middlename = [items objectForKey:@"middlename"];
        coach.lastname = [items objectForKey:@"lastname"];
        coach.speciality = [items objectForKey:@"speciality"];
        coach.years = [items objectForKey:@"years_on_staff"];
        coach.teamid = [items objectForKey:@"team_id"];
        coach.thumb = [items objectForKey:@"thumb"];
        coach.tiny = [items objectForKey:@"tiny"];
        coach.largepic = [items objectForKey:@"largepic"];
        coach.processing = [[items objectForKey:@"processing"] boolValue];
        [_coaches addObject:coach];
    }
}

@end
