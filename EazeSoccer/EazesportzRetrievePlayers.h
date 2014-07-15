//
//  EazesportzRetrievePlayers.h
//  EazeSportz
//
//  Created by Gil on 1/9/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Athlete.h"

@interface EazesportzRetrievePlayers : NSObject

- (void)retrievePlayers:(NSString *)sportid Team:(NSString *)teamid Token:(NSString *)authtoken;
- (Athlete *)getAthleteSynchronous:(NSString *)sportid Team:(NSString *)teamid Athlete:(NSString *)athlete;

@end
