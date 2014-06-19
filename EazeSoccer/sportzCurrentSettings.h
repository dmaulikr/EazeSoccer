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
#import "Photo.h"

#import "EazesportzRetrieveFeaturedPhotos.h"
#import "EazesportzRetrieveFeaturedVideosController.h"
#import "EazesportzRetrieveSponsors.h"
#import "EazesportzRetrieveSportadinv.h"
#import "EazesportzRetrieveCoaches.h"
#import "EazesportzRetrieveVisitingTeams.h"
#import "EazesportzInApAdDetailViewController.h"

#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>

@interface sportzCurrentSettings : NSObject

@property(nonatomic, assign) NSUInteger selectedTab;

@property(nonatomic, strong) User *user;
@property(nonatomic, strong) Sport *sport;
@property(nonatomic, strong) Team *team;
@property(nonatomic, strong) GameSchedule *game;

@property(nonatomic, assign) BOOL refreshGames;

@property(nonatomic, strong) NSMutableArray *roster;
@property(nonatomic, strong) NSMutableArray *gameList;
@property(nonatomic, strong) NSMutableArray *teams;
@property(nonatomic, strong) NSMutableArray *alerts;

@property(nonatomic, strong) NSMutableArray *rosterimages;
@property(nonatomic, strong) NSMutableArray *opponentimages;

@property(nonatomic, strong) NSDate *lastAlertUpdate;
@property(nonatomic, strong) NSDate *lastGameUpdate;
@property(nonatomic, assign) BOOL getRoster;

@property(nonatomic, strong) NSMutableArray *footballRB;
@property(nonatomic, strong) NSMutableArray *footballQB;
@property(nonatomic, strong) NSMutableArray *footballWR;
@property(nonatomic, strong) NSMutableArray *footballOL;
@property(nonatomic, strong) NSMutableArray *footballDEF;
@property(nonatomic, strong) NSMutableArray *footballPK;
@property(nonatomic, strong) NSMutableArray *footballK;
@property(nonatomic, strong) NSMutableArray *footballPUNT;
@property(nonatomic, strong) NSMutableArray *footballRET;

@property(nonatomic, strong) UIWindow *rootwindow;
@property(nonatomic, assign) BOOL sitechanged;
@property(nonatomic, assign) BOOL changesite;
@property(nonatomic, assign) BOOL firstuse;
@property (nonatomic, assign) BOOL photodeleted;

@property (nonatomic, strong) User *newuser;

@property (nonatomic, strong) EazesportzRetrieveFeaturedPhotos *teamPhotos;
@property (nonatomic, strong) EazesportzRetrieveFeaturedVideosController *teamVideos;
@property (nonatomic, strong) EazesportzRetrieveSponsors *sponsors;
@property (nonatomic, strong) EazesportzRetrieveSportadinv *inventorylist;
@property (nonatomic, strong) EazesportzRetrieveCoaches *coaches;
@property (nonatomic, strong) EazesportzRetrieveVisitingTeams *visitingteams;

@property (nonatomic, strong) EazesportzInApAdDetailViewController *purchaseController;

- (UIImage *)getBannerImage;

- (Athlete *)findAthlete:(NSString *)athleteid;
- (Athlete *)findAthleteByLogname:(NSString *)logname;
- (Athlete *)findAthleteByNumber:(NSNumber *)number;
- (NSMutableArray *)findAthleteByPosition:(NSString *)position;
//- (Athlete *)addAthleteStats:(Athlete *)athlete Stats:(Stats *)stats;
- (void)replaceAthleteById:(Athlete *)athlete;

- (Coach *)findCoach:(NSString *)coachid;
- (Team *)findTeam:(NSString *)teamid;

- (NSMutableArray *)findAlerts:(NSString *)athleteid;
- (BOOL)addAlert:(Alert *)alert;
- (void)deleteAlert:(Alert *)alert;
- (BOOL)hasAlerts:(NSString *)athleteid;

- (BOOL)followingAthlete:(NSString *)athleteid;

- (void)insertPlayerRoster:(Athlete *)player;
- (Athlete *)retrievePlayer:(NSString *)playerid;

- (GameSchedule *)retrieveGame:(NSString *)gameid;
- (GameSchedule *)findGame:(NSString *)gamescheduleid;

- (BOOL)deleteCoach:(Coach *)acoach;

- (Sport *)retrieveSport:(NSString *)asport;

- (int)teamFouls:(NSString *)gameid;
- (int)teamTotalPoints:(NSString *)gameid;

- (BOOL)initS3Bucket;
- (S3Bucket *)getBucket;
- (AmazonS3Client *)getS3;

- (UIImage *)normalizedImage:(UIImage *)image scaledToSize:(int)size;

- (void)replaceOpponentTinyImage:(GameSchedule *)thegame;
- (UIImage *)getOpponentImage:(GameSchedule *)agame;

- (void)replaceRosterImages:(Athlete *)player;
- (UIImage *)getRosterTinyImage:(Athlete *)player;
- (UIImage *)getRosterThumbImage:(Athlete *)player;
- (UIImage *)getRosterMediumImage:(Athlete *)player;
- (UIImage *)getRosterLargeImage:(Athlete *)player;

- (BOOL)isSiteOwner;

- (void)setUpSport:(NSString *)sportid;

- (NSURL *)addAuthenticationToken:(NSString *)urlstring;

- (VisitingTeam *)findVisitingTeam:(NSString *)visiting_team_id;

@end

