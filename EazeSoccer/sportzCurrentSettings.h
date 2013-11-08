//
//  sportzCurrentSettings.h
//  sportzSoftwareFootball
//
//  Created by Gil on 2/7/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Sport.h"
#import "Team.h"
#import "Athlete.h"
#import "Coach.h"
#import "GameSchedule.h"
#import "Alert.h"
#import "Sponsor.h"

#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>

@interface sportzCurrentSettings : NSObject

@property(nonatomic, strong) User *user;
@property(nonatomic, strong) Sport *sport;
@property(nonatomic, strong) Team *team;
@property(nonatomic, strong) GameSchedule *game;

@property(nonatomic, strong) NSMutableArray *roster;
@property(nonatomic, strong) NSMutableArray *gameList;
@property(nonatomic, strong) NSMutableArray *coaches;
@property(nonatomic, strong) NSMutableArray *teams;
@property(nonatomic, strong) NSMutableArray *sponsors;
@property(nonatomic, strong) NSMutableArray *alerts;

@property(nonatomic, strong) NSDate *lastAlertUpdate;
@property(nonatomic, strong) NSDate *lastGameUpdate;
@property(nonatomic, assign) BOOL getRoster;

- (UIImage *)getBannerImage;

- (Athlete *)findAthlete:(NSString *)athleteid;
- (Athlete *)findAthleteByLogname:(NSString *)logname;
- (Athlete *)findAthleteByNumber:(NSNumber *)number;
- (NSMutableArray *)findAthleteByPosition:(NSString *)position;
//- (Athlete *)addAthleteStats:(Athlete *)athlete Stats:(Stats *)stats;

- (Coach *)findCoach:(NSString *)coachid;
- (Team *)findTeam:(NSString *)teamid;

- (NSMutableArray *)findAlerts:(NSString *)athleteid;
- (BOOL)addAlert:(Alert *)alert;
- (void)deleteAlert:(Alert *)alert;
- (BOOL)hasAlerts:(NSString *)athleteid;

- (BOOL)followingAthlete:(NSString *)athleteid;

- (void)insertPlayerRoster:(Athlete *)player;

- (void)retrieveGameList;
- (GameSchedule *)retrieveGame:(NSString *)gameid;
- (GameSchedule *)findGame:(NSString *)gamescheduleid;
- (BOOL)deleteGame:(GameSchedule *)agame;

- (void)retrieveCoaches;
- (BOOL)deleteCoach:(Coach *)acoach;

- (void)retrievePlayers;
- (BOOL)deletePlayer:(Athlete *)player;

- (void)retrieveTeams;
- (NSMutableArray *)retrieveSportTeams:(NSString *)sportid;

- (void)retrieveSport;

- (BOOL)initS3Bucket;
- (S3Bucket *)getBucket;
- (AmazonS3Client *)getS3;

- (UIImage *)normalizedImage:(UIImage *)image;

@end

