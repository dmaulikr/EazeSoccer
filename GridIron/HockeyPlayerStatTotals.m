//
//  HockeyPlayerStatTotals.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "HockeyPlayerStatTotals.h"

#import "EazesportzAppDelegate.h"

@implementation HockeyPlayerStatTotals

@synthesize totalGoals;
@synthesize totalAssists;
@synthesize totalPoints;
@synthesize totalShots;
@synthesize totalPowerPlayGoals;
@synthesize totalPowerPlayAssists;
@synthesize totalShortHandedGoals;
@synthesize totalShortHandedAssists;
@synthesize totalFaceOffsWon;
@synthesize totalFaceOffsLost;
@synthesize totalPenaltyMinutes;
@synthesize totalTimeOnIce;
@synthesize totalBlockedShots;
@synthesize totalGamesWon;
@synthesize totalHits;
@synthesize totalPlusMinus;

- (id)initWithPlayer:(Athlete *)player {
    if (self = [super init]) {
        
        totalGoals = [NSNumber numberWithInt:0];
        totalAssists = [NSNumber numberWithInt:0];
        totalPoints = [NSNumber numberWithInt:0];
        totalPowerPlayGoals = [NSNumber numberWithInt:0];
        totalPowerPlayAssists = [NSNumber numberWithInt:0];
        totalShortHandedGoals = [NSNumber numberWithInt:0];
        totalShortHandedAssists = [NSNumber numberWithInt:0];
        totalFaceOffsWon = [NSNumber numberWithInt:0];
        totalFaceOffsLost = [NSNumber numberWithInt:0];
        totalPenaltyMinutes = [NSNumber numberWithInt:0];
        totalTimeOnIce = [NSNumber numberWithInt:0];
        totalBlockedShots = [NSNumber numberWithInt:0];
        totalGamesWon = [NSNumber numberWithInt:0];
        totalHits = [NSNumber numberWithInt:0];
        totalPlusMinus = [NSNumber numberWithInt:0];
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            HockeyStat *stat = [player findHockeyStat:[currentSettings.gameList objectAtIndex:i]];
            int goals = 0, assists = 0, ppgoal = 0, ppassist = 0, shgoal = 0, shassist = 0, games_won = 0;
            
            for (int cnt = 0; cnt < stat.scoring_stats.count; cnt++) {
                goals += 1;
                
                if ([[[stat.scoring_stats objectAtIndex:cnt] goaltype] isEqualToString:@"Power Play"]) {
                    ppgoal += 1;
                } else if ([[[stat.scoring_stats objectAtIndex:cnt] goaltype] isEqualToString:@"Short Handed"]) {
                    shgoal += 1;
                }
                
                if ([[stat.scoring_stats objectAtIndex:cnt] game_winning_goal])
                    games_won += 1;
                
                for (int cnt = 0; cnt < currentSettings.roster.count; cnt++) {
                    for (int j = 0; j < stat.scoring_stats.count; j++) {
                        HockeyScoring *scorestat = [stat.scoring_stats objectAtIndex:j];
                        
                        if ([scorestat.assist isEqualToString:player.athleteid]) {
                            assists += 1;
                            
                            if ([scorestat.assist_type isEqualToString:@"Power Play Assist"]) {
                                ppassist += 1;
                            } else if ([scorestat.assist_type isEqualToString:@"Short Handed Assist"]) {
                                shassist += 1;
                            }
                        }
                    }
                }
            }
            
            totalGoals = [NSNumber numberWithInt:[totalGoals intValue] + goals];
            totalAssists = [NSNumber numberWithInt:[totalAssists intValue] + assists];
            totalPoints = [NSNumber numberWithInt:[totalPoints intValue] + goals + assists];
            totalPowerPlayGoals = [NSNumber numberWithInt:[totalPowerPlayGoals intValue] + ppgoal];
            totalPowerPlayAssists = [NSNumber numberWithInt:[totalPowerPlayAssists intValue] + ppassist];
            totalShortHandedGoals = [NSNumber numberWithInt:[totalShortHandedGoals intValue] + shgoal];
            totalShortHandedAssists = [NSNumber numberWithInt:[totalShortHandedAssists intValue] + shassist];
            totalGamesWon = [NSNumber numberWithInt:[totalGamesWon intValue] + games_won];
            
            int shots = 0, faceoffwon = 0, faceofflost = 0, timeonice = 0, hits = 0, blockedshots = 0, plusminus = 0;
            
            for (int cnt = 0; cnt < stat.player_stats.count; cnt++) {
                shots += [[[stat.player_stats objectAtIndex:cnt] shots] intValue];
                faceoffwon += [[[stat.player_stats objectAtIndex:cnt] faceoffwon] intValue];
                faceofflost += [[[stat.player_stats objectAtIndex:cnt] faceofflost] intValue];
                timeonice += [[[stat.player_stats objectAtIndex:cnt] timeonice] intValue];
                hits += [[[stat.player_stats objectAtIndex:cnt] hits] intValue];
                blockedshots += [[[stat.player_stats objectAtIndex:cnt] blockedshots] intValue];
                plusminus += [[[stat.player_stats objectAtIndex:cnt] plusminus] intValue];
            }
            
            totalShots = [NSNumber numberWithInt:[totalShots intValue] + shots];
            totalFaceOffsWon = [NSNumber numberWithInt:[totalFaceOffsWon intValue] + faceoffwon];
            totalFaceOffsLost = [NSNumber numberWithInt:[totalFaceOffsLost intValue] + faceofflost];
            totalTimeOnIce = [NSNumber numberWithInt:[totalTimeOnIce intValue] + timeonice];
            totalHits = [NSNumber numberWithInt:[totalHits intValue] + hits];
            totalBlockedShots = [NSNumber numberWithInt:[totalBlockedShots intValue] + blockedshots];
            totalPlusMinus = [NSNumber numberWithInt:[totalPlusMinus intValue] + plusminus];
            
            int penaltyminutes = 0;
            
            for (int cnt = 0; cnt < stat.penalties.count; cnt++) {
                penaltyminutes += [[[stat findPenaltyStat:[stat.penalties objectAtIndex:cnt]] penaltytime] intValue];
            }
            
            totalPenaltyMinutes = [NSNumber numberWithInt:[totalPenaltyMinutes intValue] + penaltyminutes];
        }
        
        return self;
    } else
        return nil;
}

@end
