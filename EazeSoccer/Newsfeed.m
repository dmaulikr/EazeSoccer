//
//  Newsfeed.m
//  smpwlions
//
//  Created by Gil on 3/10/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Newsfeed.h"
#import "EazesportzAppDelegate.h"

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
@synthesize tinyurl;
@synthesize thumburl;

@synthesize httperror;

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
        tinyurl = [newsDict objectForKey:@"tinyurl"];
        thumburl = [newsDict objectForKey:@"thumburl"];
        
        return self;
    } else {
        return nil;
    }
}

- (BOOL)saveNewsFeed {
    NSURL *aurl;
    NSMutableDictionary *newsDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: title, @"title",
                                      news, @"news", currentSettings.team.teamid, @"team_id", nil];
    
    if (athlete.length > 0)
        [newsDict setValue:athlete forKey:@"athlete_id"];
    
    if (game.length > 0)
        [newsDict setValue:game forKey:@"gameschedule_id"];
    
    if (coach.length > 0)
        [newsDict setValue:coach forKey: @"coach_id"];
        
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if (newsid.length == 0)
        aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", currentSettings.sport.id, @"/newsfeeds.json?auth_token=", currentSettings.user.authtoken]];
    else
        aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", currentSettings.sport.id, @"/newsfeeds/", newsid, @".json?auth_token=", currentSettings.user.authtoken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:newsDict, @"newsfeed", nil];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (newsid.length == 0) {
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:@"PUT"];
    }
    
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([httpResponse statusCode] == 200) {
        if (newsid.length == 0)
            newsid = [[serverData objectForKey:@"newsfeed"] objectForKey:@"_id"];
        return YES;
    } else {
        httperror = [serverData objectForKey:@"error"];
        return NO;
    }
    
}

- (id)initDeleteNewsFeed {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/newsfeeds/", newsid, @".json?auth_token=",
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
    NSLog(@"%@", serverData);
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
