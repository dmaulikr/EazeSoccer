//
//  EazesportzGetGame.h
//  EazeSportz
//
//  Created by Gil on 1/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameSchedule.h"

@interface EazesportzGetGame : NSObject

@property(nonatomic, strong) GameSchedule *game;

- (void)getGame:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid Token:(NSString *)authtoken;

@end
