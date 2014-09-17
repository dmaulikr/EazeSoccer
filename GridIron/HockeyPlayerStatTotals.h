//
//  HockeyPlayerStatTotals.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Athlete.h"

@interface HockeyPlayerStatTotals : NSObject

@property (nonatomic, strong, readonly) NSNumber *totalGoals;
@property (nonatomic, strong, readonly) NSNumber *totalAssists;
@property (nonatomic, strong, readonly) NSNumber *totalPoints;
@property (nonatomic, strong, readonly) NSNumber *totalShots;
@property (nonatomic, strong, readonly) NSNumber *totalPowerPlayGoals;
@property (nonatomic, strong, readonly) NSNumber *totalPowerPlayAssists;
@property (nonatomic, strong, readonly) NSNumber *totalShortHandedGoals;
@property (nonatomic, strong, readonly) NSNumber *totalShortHandedAssists;
@property (nonatomic, strong, readonly) NSNumber *totalPenaltyMinutes;
@property (nonatomic, strong, readonly) NSNumber *totalFaceOffsWon;
@property (nonatomic, strong, readonly) NSNumber *totalFaceOffsLost;
@property (nonatomic, strong, readonly) NSNumber *totalTimeOnIce;
@property (nonatomic, strong, readonly) NSNumber *totalHits;
@property (nonatomic, strong, readonly) NSNumber *totalPlusMinus;
@property (nonatomic, strong, readonly) NSNumber *totalBlockedShots;
@property (nonatomic, strong, readonly) NSNumber *totalGamesWon;

- (id)initWithPlayer:(Athlete *)player;

@end
