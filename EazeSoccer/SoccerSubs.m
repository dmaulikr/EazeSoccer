//
//  SoccerSubs.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerSubs.h"

@implementation SoccerSubs

@synthesize inplayer;
@synthesize outplayer;
@synthesize gametime;
@synthesize home;

- (id)initWithDictionary:(NSDictionary *)subsDictionary {
    if (self = [super init]) {
        inplayer = [subsDictionary objectForKey:@"inplayer"];
        outplayer = [subsDictionary objectForKey:@"outplayer"];
        gametime = [subsDictionary objectForKey:@"gametime"];
        home = [[subsDictionary objectForKey:@"home"] boolValue];
        
        return self;
    } else
        return nil;
}

@end
