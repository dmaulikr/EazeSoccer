//
//  EazesportzRetrieveVideos.h
//  EazeSportz
//
//  Created by Gil on 3/16/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sport.h"
#import "User.h"
#import "Athlete.h"
#import "GameSchedule.h"
#import "Team.h"
#import "Video.h"
#import "Gamelogs.h"

@interface EazesportzRetrieveVideos : NSObject

@property(nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, strong) NSString *lacross_scoring_id;
@property (nonatomic, strong) Gamelogs *gamelog;

- (void)retrieveVideos:(Sport *)sport Team:(Team *)team Athlete:(Athlete *)athlete Game:(GameSchedule *)game SearchUser:(User *)searchuser
                        User:(User *)user;

- (Video *)getVideoSynchronous:(Sport *)sport Team:(Team *)team VideoId:(NSString *)videoid User:(User *)user;

@end
