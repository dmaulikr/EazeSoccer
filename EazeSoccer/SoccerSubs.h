//
//  SoccerSubs.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoccerSubs : NSObject

@property (nonatomic, strong) NSString *soccer_sub_id;
@property (nonatomic, strong) NSString *soccer_game_id;
@property (nonatomic, strong) NSString *inplayer;
@property (nonatomic, strong) NSString *outplayer;
@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, assign) BOOL home;

- (id)initWithDictionary:(NSDictionary *)subsDictionary;

@end
