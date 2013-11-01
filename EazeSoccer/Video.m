//
//  Video.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Video.h"

@implementation Video

@synthesize displayName;
@synthesize duration;
@synthesize video_url;
@synthesize videoid;
@synthesize description;
@synthesize players;
@synthesize poster_url;
@synthesize schedule;
@synthesize teamid;
@synthesize resolution;
@synthesize userid;
@synthesize gamelog;

@synthesize athletes;
@synthesize game;

- (id)init {
    if (self = [super init]) {
        players = [[NSMutableArray alloc] init];
        athletes = [[NSMutableArray alloc] init];
        return self;
    } else
        return nil;
}

- (void)parseVideoItems:(NSDictionary *)items {
    if ((NSNull *)[items objectForKey:@"poster_url"] != [NSNull null])
        self.poster_url = [items objectForKey:@"poster_url"];
    else
        self.poster_url = @"";
    
    if ((NSNull *)[items objectForKey:@"video_url"] != [NSNull null])
        self.video_url = [items objectForKey:@"video_url"];
    else
        self.video_url = @"";
    
    self.description = [items objectForKey:@"description"];
    self.displayName = [items objectForKey:@"displayname"];
    self.teamid = [items objectForKey:@"teamid"];
    self.schedule = [items objectForKey:@"gameschedule"];
    self.videoid = [items objectForKey:@"id"];
    self.players = [items objectForKey:@"players"];
    self.userid = [items objectForKey:@"user_id"];
    self.resolution = [items objectForKey:@"resolution"];
    self.duration = [items objectForKey:@"duration"];
    self.gamelog = [items objectForKey:@"gamelog"];
}

@end
