//
//  Gamelogs.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 3/26/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Gamelogs.h"
#import "EazesportzAppDelegate.h"

@implementation Gamelogs

@synthesize gamelogid;
@synthesize logentry;
@synthesize logentrytext;
@synthesize period;
@synthesize score;
@synthesize time;
@synthesize hasphotos;
@synthesize hasvideos;
@synthesize player;
@synthesize assistplayer;

@synthesize gameschedule_id;

@synthesize httperror;

- (id)init {
    if (self = [super init]) {
        gamelogid = @"";
        gameschedule_id = @"";
        
        logentry = @"";
        logentrytext = @"";
        period = @"";
        score = @"";
        time = @"";
        hasphotos = NO;
        hasvideos = NO;
        player = @"";
        assistplayer = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)gamelogDictionary {
    if ((self = [super init]) && (gamelogDictionary.count > 0)) {
        gameschedule_id = [gamelogDictionary objectForKey: @"gameschedule_id"];
        gamelogid = [gamelogDictionary objectForKey:@"id"];
        
        logentry = [gamelogDictionary objectForKey:@"logentry"];
        logentrytext = [gamelogDictionary objectForKey:@"logentrytext"];
        period = [gamelogDictionary objectForKey:@"period"];
        time = [gamelogDictionary objectForKey:@"time"];
        score = [gamelogDictionary objectForKey:@"score"];
        hasvideos = [[gamelogDictionary objectForKey:@"hasvideos"] boolValue];
        hasphotos = [[gamelogDictionary objectForKey:@"hasphotos"] boolValue];
        player = [gamelogDictionary objectForKey:@"player"];
        assistplayer = [gamelogDictionary objectForKey:@"assist"];
        
        return  self;
    } else
        return nil;
}

- (BOOL)saveStats {
    NSURL *aurl;
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if (gamelogid.length > 0) {
        aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/",
                                     gameschedule_id, @"/gamelogs/", gamelogid, @".json?auth_token=", currentSettings.user.authtoken]];
        
    } else {
        aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules", gameschedule_id,
                                     @"/gamelogs.json?auth_token=", currentSettings.user.authtoken]];
    }
    
    NSMutableDictionary *statDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: gameschedule_id, @"gameschedule_id", @"Totals", @"livestats",
                                     logentry, @"logentry", period, @"period", time, @"time", score, @"score", player, @"player", assistplayer, @"assist", nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:statDict, @"gamelog", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (gamelogid.length > 0) {
        [request setHTTPMethod:@"PUT"];
    } else {
        [request setHTTPMethod:@"POST"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *items = [serverData objectForKey:@"punter"];
    
    if ([httpResponse statusCode] == 200) {
        
        if (gamelogid.length == 0)
            gamelogid = [items objectForKey:@"_id"];
        
        return YES;
    } else {
        httperror = [items objectForKey:@"error"];
        return NO;
    }
}

@end
