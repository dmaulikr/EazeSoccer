//
//  EazesportzSendNotificationData.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Athlete.h"
#import "Team.h"
#import "User.h"
#import "Sport.h"

@interface EazesportzSendNotificationData : NSObject

- (void)sendNotificationData:(Sport *)sport Team:(Team *)team Athlete:(Athlete *)player User:(User *)user;

@end
