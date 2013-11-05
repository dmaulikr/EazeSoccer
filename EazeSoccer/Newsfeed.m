//
//  Newsfeed.m
//  smpwlions
//
//  Created by Gil on 3/10/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Newsfeed.h"

@implementation Newsfeed

@synthesize news;
@synthesize newsid;
@synthesize title;
@synthesize team;
@synthesize athlete;
@synthesize coach;
@synthesize game;
@synthesize external_url;
@synthesize updated_at;

- (id)init {
    if (self = [super init]) {
        athlete = @"";
        game = @"";
        coach = @"";
        newsid = @"";
        team = @"";
        return self;
    } else
        return nil;
}

- (id)initWithDirectory:(NSDictionary *)newsDict {
    if ((self = [super init]) && (newsDict.count > 0)) {
        news = [newsDict objectForKey:@"news"];
        newsid = [newsDict objectForKey:@"id"];
        title = [newsDict objectForKey:@"title"];
        athlete = [newsDict objectForKey:@"athlete_id"];
        coach = [newsDict objectForKey:@"coach_id"];
        team = [newsDict objectForKey:@"team_id"];
        game = [newsDict objectForKey:@"gameschedule_id"];
        external_url = [newsDict objectForKey:@"external_url"];
        updated_at = [newsDict objectForKey:@"updated_at"];
        
        return self;
    } else {
        return nil;
    }
}

@end
