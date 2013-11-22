//
//  FootballReturnerStats.m
//  EazeSportz
//
//  Created by Gil on 11/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FootballReturnerStats.h"

@implementation FootballReturnerStats

@synthesize punt_return;
@synthesize punt_returnlong;
@synthesize punt_returntd;
@synthesize punt_returnyards;

@synthesize kolong;
@synthesize koreturn;
@synthesize kotd;
@synthesize koyards;

@synthesize football_returner_id;
@synthesize gameschedule_id;
@synthesize athlete_id;

- (id)init {
    if (self = [super init]) {
        punt_return = [NSNumber numberWithInt:0];
        punt_returnlong = [NSNumber numberWithInt:0];
        punt_returntd = [NSNumber numberWithInt:0];
        punt_returnyards = [NSNumber numberWithInt:0];
        
        kolong = [NSNumber numberWithInt:0];
        koreturn = [NSNumber numberWithInt:0];
        kotd = [NSNumber numberWithInt:0];
        koyards = [NSNumber numberWithInt:0];
        
        athlete_id = @"";
        gameschedule_id = @"";
        football_returner_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)returnerDictionary {
    if ((self = [super init]) && (returnerDictionary.count > 0)) {
        punt_return = [returnerDictionary objectForKey:@"punt_return"];
        punt_returnlong = [returnerDictionary objectForKey:@"punt_returnlong"];
        punt_returntd = [returnerDictionary objectForKey:@"punt_returntd"];
        punt_returnyards = [returnerDictionary objectForKey:@"punt_returnyards"];
        
        kolong = [returnerDictionary objectForKey:@"kolong"];
        koreturn = [returnerDictionary objectForKey:@"koreturn"];
        kotd = [returnerDictionary objectForKey:@"kotd"];
        koyards = [returnerDictionary objectForKey:@"koyards"];
        
        athlete_id = [returnerDictionary objectForKey:@"athlete_id"];
        gameschedule_id = [returnerDictionary objectForKey:@"gameschedule_id"];
        football_returner_id = [returnerDictionary objectForKey:@"football_returner_id"];
        
        return self;
    } else
        return nil;
}

@end
