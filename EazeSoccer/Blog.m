//
//  Blog.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/22/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Blog.h"

@implementation Blog

@synthesize blogtitle;
@synthesize entry;
@synthesize external_url;
@synthesize blogid;
@synthesize teamid;
@synthesize athlete;
@synthesize coach;
@synthesize gameschedule;
@synthesize user;
@synthesize username;
@synthesize avatar;
@synthesize tinyavatar;
@synthesize updatedat;
@synthesize gamelog;

@synthesize thumbimage;
@synthesize tinyimage;

- (id)initWithDictionary:(NSDictionary *)blogDictionary {
    if ((self = [super init]) && (blogDictionary.count > 0)) {
        blogtitle = [blogDictionary objectForKey:@"title"];
        blogid = [blogDictionary objectForKey:@"id"];
        entry = [blogDictionary objectForKey:@"entry"];
        athlete = [blogDictionary objectForKey:@"athlete"];
        coach = [blogDictionary objectForKey:@"coach"];
        gameschedule = [blogDictionary objectForKey:@"gameschedule"];
        user = [blogDictionary objectForKey:@"user"];
        username = [blogDictionary objectForKey:@"username"];
        external_url = [blogDictionary objectForKey:@"external_url"];
        teamid = [blogDictionary objectForKey:@"team"];
        
        if ((NSNull *)[blogDictionary objectForKey:@"avatar"] != [NSNull null])
            avatar = [blogDictionary objectForKey:@"avatar"];
        else
            avatar = @"";
        
        if ((NSNull *)[blogDictionary objectForKey:@"tinyavatar"] != [NSNull null])
            tinyavatar = [blogDictionary objectForKey:@"tinyavatar"];
        else
            tinyavatar = @"";
        
        updatedat = [blogDictionary objectForKey:@"updated_at"];
        gamelog = [blogDictionary objectForKey:@"gamelog"];
        
        return self;
    } else {
        return nil;
    }
}

@end
