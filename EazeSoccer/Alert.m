//
//  Alert.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Alert.h"
#import "EazesportzAppDelegate.h"

@implementation Alert

@synthesize message;
@synthesize created_at;
@synthesize alertid;
@synthesize user;
@synthesize athlete;
@synthesize photo;
@synthesize videoclip;
@synthesize blog;
@synthesize sport;
@synthesize stat;
@synthesize stattype;

@synthesize football_defense_id;
@synthesize football_passing_id;
@synthesize football_place_kicker_id;
@synthesize football_punter_id;
@synthesize football_receiving_id;
@synthesize football_returner_id;
@synthesize football_rushing_id;
@synthesize football_kicker_id;

@synthesize basketball_stat_id;
@synthesize soccer_id;

@synthesize httperror;

- (id)initWithDirectory:(NSDictionary *)alertDirectory {
    if (self = [super init]) {
        alertid = [alertDirectory objectForKey:@"id"];
        message = [alertDirectory objectForKey:@"message"];
        created_at = [alertDirectory objectForKey:@"created_at"];
        sport = [alertDirectory objectForKey:@"sport"];
        athlete = [alertDirectory objectForKey:@"athlete"];
        photo = [alertDirectory objectForKey:@"photo"];
        user = [alertDirectory objectForKey:@"user"];
        blog = [alertDirectory objectForKey:@"blog"];
        videoclip = [alertDirectory objectForKey:@"videoclip"];
        stattype = [alertDirectory objectForKey:@"stat_football"];
        
        football_rushing_id = [alertDirectory objectForKey:@"football_rushing"];
        football_receiving_id = [alertDirectory objectForKey:@"football_receiving"];
        football_punter_id = [alertDirectory objectForKey:@"football_punter"];
        football_passing_id = [alertDirectory objectForKey:@"football_passing"];
        football_defense_id = [alertDirectory objectForKey:@"football_defense"];
        football_place_kicker_id = [alertDirectory objectForKey:@"football_place_kicker"];
        football_returner_id = [alertDirectory objectForKey:@"football_returner"];
        football_kicker_id = [alertDirectory objectForKey:@"football_kicker"];
        
        basketball_stat_id = [alertDirectory objectForKey:@"basketball_stat"];
        soccer_id = [alertDirectory objectForKey:@"soccer"];
        
        return self;
    } else {
        return nil;
    }
}

- (id)initDeleteAlert {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/athletes/", athlete, @"/alerts/", alertid, @".json?auth_token=",
                                       currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
    
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *alertData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        return  nil;
    }  else {
        httperror = [alertData objectForKey:@"error"];
        return self;
    }
}

@end
