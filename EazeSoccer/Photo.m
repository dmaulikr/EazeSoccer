//
//  Photo.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/4/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@synthesize large_url;
@synthesize medium_url;
@synthesize thumbnail_url;
@synthesize description;
@synthesize displayname;
@synthesize teamid;
@synthesize photoid;
@synthesize players;
@synthesize owner;
@synthesize schedule;
@synthesize athletes;
@synthesize game;
@synthesize gamelog;

- (id)init {
    if (self = [super init]) {
        players = [[NSMutableArray alloc] init];
        athletes = [[NSMutableArray alloc] init];
        return self;
    } else
        return nil;
}

- (void)parsePhoto:(NSDictionary *)items {
    if ((NSNull *)[items objectForKey:@"large_url"] != [NSNull null])
        self.large_url = [items objectForKey:@"large_url"];
    else
        self.large_url = @"";
    
    if ((NSNull *)[items objectForKey:@"medium_url"] != [NSNull null])
        self.medium_url = [items objectForKey:@"medium_url"];
    else
        self.medium_url = @"";
    
    if ((NSNull *)[items objectForKey:@"thumbnail_url"] != [NSNull null])
        self.thumbnail_url = [items objectForKey:@"thumbnail_url"];
    else
        self.thumbnail_url = @"";
    
    self.description = [items objectForKey:@"description"];
    self.displayname = [items objectForKey:@"displayname"];
    self.teamid = [items objectForKey:@"teamid"];
    self.schedule = [items objectForKey:@"gameschedule"];
    self.photoid = [items objectForKey:@"id"];
    self.owner = [items objectForKey:@"user"];
    self.players = [items objectForKey:@"players"];
    self.gamelog = [items objectForKey:@"gamelog"];
}

@end
