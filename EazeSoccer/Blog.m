//
//  Blog.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/22/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Blog.h"
#import "EazesportzAppDelegate.h"

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

@synthesize httperror;

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

- (id)initDeleteBlog {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/blogs/", blogid, @".json?auth_token=",
                                        currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] init];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([httpResponse statusCode] == 200) {
        self = nil;
    } else {
        httperror = [serverData objectForKey:@"error"];
    }
    return self;
}

@end
