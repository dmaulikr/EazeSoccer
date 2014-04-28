
//
//  Sportadinv.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "Sportadinv.h"

@implementation Sportadinv

@synthesize sportadinvid;
@synthesize sportid;
@synthesize adlevelname;
@synthesize price;
@synthesize forsale;
@synthesize expiration;
@synthesize athlete_id;

@synthesize httperror;

- (id)initWithDirectory:(NSDictionary *)sportadinvDictionary {
    if ((self = [super init]) && (sportadinvDictionary.count > 0)) {
        
        sportadinvid = [sportadinvDictionary objectForKey:@"id"];
        sportid = [sportadinvDictionary objectForKey:@"sport_id"];
        adlevelname = [sportadinvDictionary objectForKey:@"adlevelname"];
        price = [[sportadinvDictionary objectForKey:@"price"] floatValue];
        forsale = [[sportadinvDictionary objectForKey:@"active"] boolValue];
        expiration = [sportadinvDictionary objectForKey:@"expiration"];
        athlete_id = [sportadinvDictionary objectForKey:@"athlete_id"];
        
        return self;
    } else
        return nil;
}

- (id)initDelete {
    self = nil;
    return self;
}

- (BOOL)saveSportadinv:(Sport *)sport User:(User *)user {
    NSString *stringurl;
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if (sportadinvid.length > 0) {
        stringurl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"EazesportzUrl"], @"/sports/", sport.id,
                     @"/sportadinvs/", sportadinvid, @".json?auth_token=",  user.authtoken];
        
    } else {
        stringurl = [NSString stringWithFormat:@"%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"EazesportzUrl"], @"/sports/", sport.id,
                     @"/sportadinvs.json?auth_token=", user.authtoken];
    }
    
    NSURL *url = [NSURL URLWithString:stringurl];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+00:00"];
    
    NSMutableDictionary *statDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: adlevelname, @"adlevelname",
                                     [dateFormatter stringFromDate:expiration], @"expiration", [NSString stringWithFormat:@"%.02f", price], @"price",
                                     [NSString stringWithFormat:@"%d", forsale], @"active", sportid, @"sport_id",
                                     athlete_id, @"athlete_id", nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:statDict, @"sportadinv", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (sportadinvid.length > 0) {
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
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *items = [serverData objectForKey:@"sportadinv"];
    
    if ([httpResponse statusCode] == 200) {
        [self initWithDirectory:items];
        
        return YES;
    } else {
        httperror = [serverData objectForKey:@"error"];
        return NO;
    }
}

- (BOOL)deleteSportadinv:(User *)user {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                                       [mainBundle objectForInfoDictionaryKey:@"EazesportzUrl"],  @"/sports/", sportid,
                                       @"/sportadinvs/", sportadinvid, @".json?auth_token=", user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSError *error = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] init];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    //Capturing server response
    NSURLResponse* response;
    NSError *jsonSerializationError = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *items = [serverData objectForKey:@"sportadinv"];
    
    if ([httpResponse statusCode] == 200) {
        return YES;
    } else {
        httperror = [serverData objectForKey:@"error"];
        return NO;
    }
}

- (NSString *)adnameprice {
    return [NSString stringWithFormat:@"%@ - $%.02f", adlevelname, price];
}

@end
