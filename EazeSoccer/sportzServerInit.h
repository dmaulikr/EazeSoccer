//
//  sportzServerInit.h
//  SportzSoftwareApp
//
//  Created by Gil on 2/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Athlete.h"
#import "Photo.h"
#import "Video.h"
#import "Standings.h"
@interface sportzServerInit : NSObject

- (NSString *)getSportzServerUrlString;

+ (NSString *)getSport:(NSString *)authtoken;
+ (NSString *)addSport:(NSString *)authtoken;
+ (NSString *)updatelogo:(NSString *)authtoken;

- (NSString *)getSportzServerHome;

- (NSString *)getSportzServerSite:(NSString*)sitename State:(NSString*)state City:(NSString*)city Zip:(NSString*)zip;

- (NSString *)getLoginRequest;

+ (NSString *)registerUser;
+ (NSString *)getUser:(NSString *)userid Token:(NSString *)authtoken;
+ (NSString *)getAUser:(NSString *)userid Token:(NSString *)authtoken;
+ (NSString *)updateUser:(NSString *)userid Token:(NSString *)authtoken;
+ (NSString *)updateUser:(NSString *)authtoken;
+ (NSString *)updateUserInfo:(NSString *)userid Token:(NSString *)authtoken;
+ (NSString *)getAllUsers:(NSString *)authtoken;
+ (NSString *)findUsers:(NSString *)email Username:(NSString *)username Token:(NSString *)authtoken;
+ (NSString *)deleteAvatar:(NSString *)userid Token:(NSString *)authtoken;
+ (NSString *)uploadUserAvatar:(NSString *)userid Token:(NSString *)authtoken;

+ (NSString *)logout:(NSString*)token;

+ (NSString *)newsfeed:(NSString *)updated_at Token:authtoken;
+ (NSString *)newNewsFeed:(NSString *)authtoken;
+ (NSString *)updateNewsFeed:(NSString *)newsfeed Token:(NSString *)authtoken;
+ (NSString *)deleteNewsFeed:(NSString *)newsfeed Token:(NSString *)authtoken;

+ (NSString *)getTeams:(NSString*)sport Token:(NSString *)authtoken;
+ (NSString *)addTeam:(NSString *)authtoken;
+ (NSString *)updateTeam:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)updateTeamLogo:(NSString *)team Token:(NSString *)authtoken;

+ (NSString *)getGameSchedule:(NSString*)team Token:(NSString*)authtoken;
+ (NSString *)getGame:(NSString *)team Game:(NSString *)game Token:(NSString *)authtoken;
+ (NSString *)updateGame:(NSString *)team Game:(NSString *)game Token:(NSString *)authtoken;
+ (NSString *)updateGameLog:(NSString *)team Game:(NSString *)game GameLog:(NSString *)gamelog Token:(NSString *)authtoken;
+ (NSString *)getGameLogs:(NSString *)team Game:(NSString *)game Token:(NSString *)authtoken;

+ (NSString *)getRoster:(NSString*)team Token:(NSString*)authtoken;
+ (NSString *)getAthlete:(NSString*)athleteid Token:(NSString*)authtoken;
+ (NSString *)newAthlete:(NSString *)authtoken;
+ (NSString *)updateAthletePhoto:(NSString *)athleteid Token:(NSString*)authtoken;
+ (NSString *)followAthlete:(NSString *)athleteid Token:(NSString *)authtoken;
+ (NSString *)unfollowAthlete:(NSString *)athleteid Token:(NSString *)authtoken;

+ (NSString *)getAthleteStats:(NSString *)athlete Token:(NSString *)authtoken;
+ (NSString *)getAthleteGameStats:(NSString *)athlete Game:(NSString *)game Token:(NSString *)authtoken;
+ (NSString *)getRushingStat:(NSString *)statId Athlete:(NSString *)athlete Token:(NSString *)authtoken;

+ (NSString *)getPlayerPassingStats:(NSString *)player Token:(NSString *)authtoken;
+ (NSString *)updatePlayerPassingStats:(Athlete *)player Token:(NSString *)authtoken;
+ (NSString *)getPlayerRushingStats:(NSString *)player Token:(NSString *)authtoken;
+ (NSString *)updatePlayerRushingStats:(Athlete *)player Token:(NSString *)authtoken;
+ (NSString *)getPlayerReceivingStats:(NSString *)player Token:(NSString *)authtoken;
+ (NSString *)updatePlayerReceivingStats:(Athlete *)player Token:(NSString *)authtoken;
+ (NSString *)getPlayerDefenseStats:(NSString *)player Token:(NSString *)authtoken;
+ (NSString *)updatePlayerDefenseStats:(Athlete *)player Token:(NSString *)authtoken;
+ (NSString *)getPlayerSpecialTeamsStats:(NSString *)player Token:(NSString *)authtoken;
+ (NSString *)updatePlayerPlaceKickerStats:(Athlete *)player Token:(NSString *)authtoken;
+ (NSString *)updatePlayerReturnerStats:(Athlete *)player Token:(NSString *)authtoken;

+ (NSString *)addPlayerPassingStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken;
+ (NSString *)addPlayerRushingStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken;
+ (NSString *)addPlayerDefenseStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken;
+ (NSString *)addPlayerPlaceKickerStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken;
+ (NSString *)addPlayerPunterStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken;
+ (NSString *)addPlayerKickerStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken;
+ (NSString *)addPlayerReturnerStat:(Athlete *)player Stats:(NSDictionary *)stats Stattype:(NSString *)stattype Token:(NSString *)authtoken;
+ (NSString *)createPlayerStat:(Athlete *)player Token:(NSString *)authtoken;

+ (NSString *)getCoachList:(NSString *)teamid Token:(NSString *)authtoken;
+ (NSString *)getCoach:(NSString *)coach Token:(NSString *)authtoken;
+ (NSString *)newCoach:(NSString *)authtoken;
+ (NSString *)updateCoachPhoto:(NSString *)coachid Token:(NSString*)authtoken;

+ (NSString *)getTeamPhotos:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getAthletePhotos:(NSString *)athlete Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getGamePhotos:(NSString *)game Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getAthleteGamePhotos:(NSString *)athlete Game:(NSString *)game Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getUserPhotos:(NSString *)user Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getGameLogPhotos:(NSString *)gamelogid Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)untagAthletesPhoto:(Photo *)photo Token:(NSString *)authtoken;
+ (NSString *)tagAthletesPhoto:(Photo *)photo Token:(NSString *)authtoken;

+ (NSString *)getPhoto:(NSString *)photo Token:(NSString *)authotoken;
+ (NSString *)newPhoto:(NSString *)authtoken;
+ (NSString *)deletePhoto:(NSString *)photoid Token:(NSString *)authtoken;

+ (NSString *)getTeamVideos:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getAthleteVideos:(NSString *)athlete Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getGameVideos:(NSString *)game Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getAthleteGameVideos:(NSString *)athlete Game:(NSString *)game Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getUserVideos:(NSString *)video Team:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)getGameLogVideos:(NSString *)gamelogid Team:(NSString *)team Token:(NSString *)authtoken;

+ (NSString *)getVideo:(NSString *)videoid Token:(NSString *)authtoken;
+ (NSString *)untagAthletesVideo:(Video *)video Token:(NSString *)authtoken;
+ (NSString *)tagAthletesVideo:(Video *)video Token:(NSString *)authtoken;
+ (NSString *)deleteVideo:(NSString *)videoid Token:(NSString *)authtoken;
+ (NSString *)newVideo:(NSString *)authtoken;

+ (NSString *)getContacts:(NSString *)authtoken;
+ (NSString *)getContact:(NSString *)contact Token:(NSString *)authtoken;

+ (NSString *)getBlogs:(NSString*)teamid updatedAt:(NSString *)updatedat Token:(NSString *)authtoken;
+ (NSString *)getAthleteBlogs:(NSString *)athlete updatedAt:(NSString *)updatedat Token:(NSString *)authtoken;
+ (NSString *)getCoachBlogs:(NSString *)coach updatedAt:(NSString *)updatedat Token:(NSString *)authtoken;
+ (NSString *)getGameBlogs:(NSString *)game updatedAt:(NSString *)updatedat Token:(NSString *)authtoken;
+ (NSString *)getUserBlogs:(NSString *)user updatedAt:(NSString *)updatedat Token:(NSString *)authtoken;
+ (NSString *)getBigPlayBlogs:(NSString *)gamelog updatedAt:(NSString *)updatedat Token:(NSString *)authtoken;
+ (NSString *)newBlog:(NSString *)authtoken;
+ (NSString *)deleteBlog:(NSString *)blogid Token:(NSString *)authoken;

+ (NSString *)getAlerts:(NSString *)userid Token:(NSString *)authtoken;
+ (NSString *)getAlertsSince:(NSString *)userid LastUpdate:(NSString *)lastUpdate Token:(NSString *)authtoken;
+ (NSString *)deleteAlert:(NSString *)alertid Athlete:(NSString *)athleteid Token:(NSString *)authtoken;
+ (NSString *)clearAlerts:(NSString *)athleteid AlertType:(NSString *)alerttype Token:(NSString *)authtoken;

+ (NSString *)getSiteList:(NSString *)state Zip:(NSString *)zip City:(NSString *)city SiteName:(NSString *)sitename Sportname:(NSString *)sportname;
+ (NSString *)changeDefaultSite:(NSString *)sportid Token:(NSString *)authtoken;

+ (NSString *)getStatConsolePlayers:(NSString *)team Token:(NSString *)authtoken;
+ (NSString *)addStatConsolePlayers:(NSString *)team Token:(NSString *)authtoken;

+ (NSString *)getSponsors:(NSString *)authToken;

+ (NSString *)getStandings:(NSString *)authToken;
+ (NSString *)updateTeamStanding:(Standings *)standing Token:(NSString *)authtoken;
+ (NSString *)importTeamStanding:(NSString *)gameid Token:(NSString *)authtoken;

@end
