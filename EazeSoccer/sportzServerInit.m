//
//  sportzServerInit.m
//  SportzSoftwareApp
//
//  Created by Gil on 2/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "FootballStats.h"

@implementation sportzServerInit 

- (NSString *)getSportzServerUrlString
{
    
    NSBundle *mainBundle;
    mainBundle = [NSBundle mainBundle];
    return [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];

}

- (NSString *)getSportzServerHome
{

    NSBundle *mainBundle;
    mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingString:@"/home.json"];
    
}

+ (NSString *)getSport:(NSString *)authtoken
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)addSport:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return  serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@", @"/sports.json?auth_token=", authtoken];
}

+ (NSString *)updatelogo:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/updatelogo.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

- (NSString *)getSportzServerSite:(NSString*)sitename State:(NSString *)state City:(NSString *)city Zip:(NSString *)zip
{
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sites.json?"];
    
    if (!sitename) {
        serverUrlString = [serverUrlString stringByAppendingString:@"&sitename="];
        serverUrlString = [serverUrlString stringByAppendingString:sitename];
    }
    
    if ([zip length] > 0) {
        serverUrlString = [serverUrlString stringByAppendingString:@"&zip="];
        serverUrlString = [serverUrlString stringByAppendingString:zip];
    }
    
    if (!state) {
        serverUrlString = [serverUrlString stringByAppendingString:@"&state="];
        serverUrlString = [serverUrlString stringByAppendingString:state];
    }
    
    if (!city ) {
        serverUrlString = [serverUrlString stringByAppendingString:@"&city="];
        serverUrlString = [serverUrlString stringByAppendingString:city];
    }
    
    return serverUrlString;

}

- (NSString *)getLoginRequest {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
//    return serverUrlString = [serverUrlString stringByAppendingString:@"/api/v1/tokens.json"];
    return serverUrlString = [serverUrlString stringByAppendingString:@"/users/sign_in.json"];
}

+ (NSString *)getUser:(NSString *)userid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users/"];
    serverUrlString = [serverUrlString stringByAppendingString:userid];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAUser:(NSString *)userid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users/"];
    serverUrlString = [serverUrlString stringByAppendingString:userid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/getuser.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updateUser:(NSString *)userid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users/"];
    serverUrlString = [serverUrlString stringByAppendingString:userid];
    serverUrlString = [serverUrlString stringByAppendingFormat:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updateUser:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updateUserInfo:(NSString *)userid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@", @"/users/", userid,
                              @"/update_user_info.json?auth_token=", authtoken];
}

+ (NSString *)registerUser {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingString:@"/users.json"];    
}

+ (NSString *)getAllUsers:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users.json?site="];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:currentSettings.user.authtoken];
}

+ (NSString *)findUsers:(NSString *)email Username:(NSString *)username Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users.json?site="];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    
    if (email.length > 0) {
        serverUrlString = [serverUrlString stringByAppendingString:[NSString stringWithFormat:@"%@%@", @"&email=", email]];
    }
    
    if (username.length > 0)
        serverUrlString = [serverUrlString stringByAppendingString:[NSString stringWithFormat:@"%@%@", @"&name=", username]];
    
    serverUrlString = [serverUrlString stringByAppendingString:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:currentSettings.user.authtoken];
}

+ (NSString *)deleteAvatar:(NSString *)userid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users/"];
    serverUrlString = [serverUrlString stringByAppendingString:userid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/delete_avatar.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)uploadUserAvatar:(NSString *)userid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SecureSportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users/"];
    serverUrlString = [serverUrlString stringByAppendingString:userid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/uploadavatar.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)logout:(NSString*)token {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
//    serverUrlString = [serverUrlString stringByAppendingString:@"/api/v1/tokens/"];
//    serverUrlString = [serverUrlString stringByAppendingString:token];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@", @"/users/sign_out.json?auth_token=", token];
}

+ (NSString *)newsfeed:(NSString *)updated_at Token:authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    
    if (updated_at.length > 0) {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@", @"/newsfeeds.json?updated_at=", updated_at, @"&auth_token="];
    } else {
        serverUrlString = [serverUrlString stringByAppendingString:@"/newsfeeds.json?auth_token="];
    }
    
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)newNewsFeed:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/newsfeeds.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updateNewsFeed:(NSString *)newsfeed Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/newsfeeds/", newsfeed,
                              @".json?auth_token=", authtoken];
}

+ (NSString *)deleteNewsFeed:(NSString *)newsfeed Token:(NSString *)authoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    return serverUrlString = [serverUrlString stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", @"/newsfeeds/", newsfeed,
                                                                       @".json?auth_token=", currentSettings.user.authtoken]];
}

+ (NSString *)getTeams:(NSString*)sport Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:sport];
    serverUrlString = [serverUrlString stringByAppendingString:@"/teams.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)addTeam:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/teams.json?auth_token=",
                              authtoken];
}

+ (NSString *)updateTeam:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/teams/",
                              team, @".json?auth_token=", authtoken];
}

+ (NSString *)updateTeamLogo:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@", @"/teams/", team, @"/updatelogo.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getGameSchedule:(NSString *)team Token:(NSString*)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/teams/"];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"/gameschedules.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];    
}

+ (NSString *)getGame:(NSString *)team Game:(NSString *)game Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/teams/"];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"/gameschedules/"];
    serverUrlString = [serverUrlString stringByAppendingString:game];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];    
}

+ (NSString *)updateGame:(NSString *)team Game:(NSString *)game Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/teams/"];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    if (game != nil) {
        serverUrlString = [serverUrlString stringByAppendingString:@"/gameschedules/"];
        serverUrlString = [serverUrlString stringByAppendingString:game];
    } else {
        serverUrlString = [serverUrlString stringByAppendingString:@"/gameschedules"];
    }
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updateGameLog:(NSString *)team Game:(NSString *)game GameLog:(NSString *)gamelog Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/teams/"];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"/gameschedules/"];
    serverUrlString = [serverUrlString stringByAppendingString:game];
    serverUrlString = [serverUrlString stringByAppendingString:@"/gamelogs/"];
    serverUrlString = [serverUrlString stringByAppendingString:gamelog];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getGameLogs:(NSString *)team Game:(NSString *)game Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/teams/", team, @"/gameschedules/", game, @"/gamelogs/gamelogs.json?auth_token=", authtoken];
}

+ (NSString *)getRoster:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAthlete:(NSString*)athleteid Token:(NSString*)authtoken{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athleteid];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updateAthletePhoto:(NSString *)athleteid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athleteid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/updatephoto.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updateCoachPhoto:(NSString *)coachid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/coaches/"];
    serverUrlString = [serverUrlString stringByAppendingString:coachid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/updatephoto.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)newAthlete:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)followAthlete:(NSString *)athleteid Token:(NSString *)authtoken{    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athleteid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/follow.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)unfollowAthlete:(NSString *)athleteid Token:(NSString *)authtoken{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athleteid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/unfollow.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAthleteStats:(NSString *)athlete Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athlete];
    serverUrlString = [serverUrlString stringByAppendingString:@"/stats.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAthleteGameStats:(NSString *)athlete Game:(NSString *)game Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athlete];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/showdata.json?game="];
    serverUrlString = [serverUrlString stringByAppendingString:game];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getRushingStat:(NSString *)statId Athlete:(NSString *)athlete Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];    
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athlete];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
    serverUrlString = [serverUrlString stringByAppendingString:statId];
    serverUrlString = [serverUrlString stringByAppendingString:@"/getrushing?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getPlayerPassingStats:(NSString *)player Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:player];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/passing.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];    
}
/*
+ (NSString *)updatePlayerPassingStats:(Athlete *)player Token:(NSString *)authtoken {
    FootballStats *statids = [player findGameStatEntries:[currentSettings.game id]];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids football_stat]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_passings/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids passing]];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getPlayerRushingStats:(NSString *)player Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:player];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/rushing.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updatePlayerRushingStats:(Athlete *)player Token:(NSString *)authtoken {
    FootballStats *statids = [player findGameStatEntries:[currentSettings.game id]];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids football_stat]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_rushings/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids rushing]];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getPlayerReceivingStats:(NSString *)player Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:player];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/receiving.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updatePlayerReceivingStats:(Athlete *)player Token:(NSString *)authtoken {
    FootballStats *statids = [player findGameStatEntries:[currentSettings.game id]];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids football_stat]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_receivings/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids receiving]];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getPlayerDefenseStats:(NSString *)player Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:player];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/defense.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updatePlayerDefenseStats:(Athlete *)player Token:(NSString *)authtoken {
    FootballStats *statids = [player findGameStatEntries:[currentSettings.game id]];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids football_stat]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_defenses/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids defense]];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getPlayerSpecialTeamsStats:(NSString *)player Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:player];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/specialteams.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updatePlayerPlaceKickerStats:(Athlete *)player Token:(NSString *)authtoken {
    FootballStats *statids = [player findGameStatEntries:[currentSettings.game id]];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids football_stat]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_kickers/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids kickers]];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)updatePlayerReturnerStats:(Athlete *)player Token:(NSString *)authtoken {
    FootballStats *statids = [player findGameStatEntries:[currentSettings.game id]];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids football_stat]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_returners/"];
    serverUrlString = [serverUrlString stringByAppendingString:[statids returners]];
    serverUrlString = [serverUrlString stringByAppendingString:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)addPlayerPassingStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken {
    FootballStats *rbstats = [player findGameStatEntries:[currentSettings.game id]];
    if ([[rbstats football_stat] length] > 0) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
        serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
        serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
        serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
        serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
        serverUrlString = [serverUrlString stringByAppendingString:[rbstats football_stat]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_passings/addattempt.json"];
        NSArray *keys = [stats allKeys];
        if ([keys count] > 0) {
            serverUrlString = [serverUrlString stringByAppendingString:@"?"];       
            for (int i = 0; i < [keys count]; i++) {
                serverUrlString = [serverUrlString stringByAppendingString:[keys objectAtIndex:i]];
                serverUrlString = [serverUrlString stringByAppendingString:@"="];
                serverUrlString = [serverUrlString stringByAppendingString:[stats objectForKey:[keys objectAtIndex:i]]];
                serverUrlString = [serverUrlString stringByAppendingString:@"&"];
            }
            serverUrlString = [serverUrlString stringByAppendingString:@"auth_token="];
        } else {
            serverUrlString = [serverUrlString stringByAppendingString:@"?auth_token="];        
        }
        return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
    } else {
        return nil;
    }
}

+ (NSString *)addPlayerRushingStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken {
    FootballStats *rbstats = [player findGameStatEntries:[currentSettings.game id]];
    if ([[rbstats football_stat] length] > 0) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
        serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
        serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
        serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
        serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
        serverUrlString = [serverUrlString stringByAppendingString:[rbstats football_stat]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_rushings/addcarry.json"];
        NSArray *keys = [stats allKeys];
        if ([keys count] > 0) {
            serverUrlString = [serverUrlString stringByAppendingString:@"?"];
            for (int i = 0; i < [keys count]; i++) {
                serverUrlString = [serverUrlString stringByAppendingString:[keys objectAtIndex:i]];
                serverUrlString = [serverUrlString stringByAppendingString:@"="];
                serverUrlString = [serverUrlString stringByAppendingString:[stats objectForKey:[keys objectAtIndex:i]]];
                serverUrlString = [serverUrlString stringByAppendingString:@"&"];
            }
            serverUrlString = [serverUrlString stringByAppendingString:@"auth_token="];
        } else {
            serverUrlString = [serverUrlString stringByAppendingString:@"?auth_token="];
        }
        return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
    } else {
        return nil;
    }
}

+ (NSString *)addPlayerDefenseStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken {
    FootballStats *rbstats = [player findGameStatEntries:[currentSettings.game id]];
    if ([[rbstats football_stat] length] > 0) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
        serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
        serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
        serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
        serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
        serverUrlString = [serverUrlString stringByAppendingString:[rbstats football_stat]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_defenses/adddefense.json"];
        NSArray *keys = [stats allKeys];
        if ([keys count] > 0) {
            serverUrlString = [serverUrlString stringByAppendingString:@"?"];
            for (int i = 0; i < [keys count]; i++) {
                serverUrlString = [serverUrlString stringByAppendingString:[keys objectAtIndex:i]];
                serverUrlString = [serverUrlString stringByAppendingString:@"="];
                serverUrlString = [serverUrlString stringByAppendingString:[stats objectForKey:[keys objectAtIndex:i]]];
                serverUrlString = [serverUrlString stringByAppendingString:@"&"];
            }
            serverUrlString = [serverUrlString stringByAppendingString:@"auth_token="];
        } else {
            serverUrlString = [serverUrlString stringByAppendingString:@"?auth_token="];
        }
        return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
    } else {
        return nil;
    }
}

+ (NSString *)addPlayerPlaceKickerStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken {
    FootballStats *rbstats = [player findGameStatEntries:[currentSettings.game id]];
    if ([[rbstats football_stat] length] > 0) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
        serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
        serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
        serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
        serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
        serverUrlString = [serverUrlString stringByAppendingString:[rbstats football_stat]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_kickers/placekicker.json"];
        NSArray *keys = [stats allKeys];
        if ([keys count] > 0) {
            serverUrlString = [serverUrlString stringByAppendingString:@"?"];
            for (int i = 0; i < [keys count]; i++) {
                serverUrlString = [serverUrlString stringByAppendingString:[keys objectAtIndex:i]];
                serverUrlString = [serverUrlString stringByAppendingString:@"="];
                serverUrlString = [serverUrlString stringByAppendingString:[stats objectForKey:[keys objectAtIndex:i]]];
                serverUrlString = [serverUrlString stringByAppendingString:@"&"];
            }
            serverUrlString = [serverUrlString stringByAppendingString:@"auth_token="];
        } else {
            serverUrlString = [serverUrlString stringByAppendingString:@"?auth_token="];
        }
        return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
    } else {
        return nil;
    }
}

+ (NSString *)addPlayerPunterStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken {
    FootballStats *rbstats = [player findGameStatEntries:[currentSettings.game id]];
    if ([[rbstats football_stat] length] > 0) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
        serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
        serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
        serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
        serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
        serverUrlString = [serverUrlString stringByAppendingString:[rbstats football_stat]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_kickers/punter.json"];
        NSArray *keys = [stats allKeys];
        if ([keys count] > 0) {
            serverUrlString = [serverUrlString stringByAppendingString:@"?"];
            for (int i = 0; i < [keys count]; i++) {
                serverUrlString = [serverUrlString stringByAppendingString:[keys objectAtIndex:i]];
                serverUrlString = [serverUrlString stringByAppendingString:@"="];
                serverUrlString = [serverUrlString stringByAppendingString:[stats objectForKey:[keys objectAtIndex:i]]];
                serverUrlString = [serverUrlString stringByAppendingString:@"&"];
            }
            serverUrlString = [serverUrlString stringByAppendingString:@"auth_token="];
        } else {
            serverUrlString = [serverUrlString stringByAppendingString:@"?auth_token="];
        }
        return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
    } else {
        return nil;
    }
}

+ (NSString *)addPlayerKickerStat:(Athlete *)player Stats:(NSDictionary *)stats Token:(NSString *)authtoken {
    FootballStats *rbstats = [player findGameStatEntries:[currentSettings.game id]];
    if ([[rbstats football_stat] length] > 0) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
        serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
        serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
        serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
        serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
        serverUrlString = [serverUrlString stringByAppendingString:[rbstats football_stat]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_kickers/kickoff.json"];
        NSArray *keys = [stats allKeys];
        if ([keys count] > 0) {
            serverUrlString = [serverUrlString stringByAppendingString:@"?"];
            for (int i = 0; i < [keys count]; i++) {
                serverUrlString = [serverUrlString stringByAppendingString:[keys objectAtIndex:i]];
                serverUrlString = [serverUrlString stringByAppendingString:@"="];
                serverUrlString = [serverUrlString stringByAppendingString:[stats objectForKey:[keys objectAtIndex:i]]];
                serverUrlString = [serverUrlString stringByAppendingString:@"&"];
            }
            serverUrlString = [serverUrlString stringByAppendingString:@"auth_token="];
        } else {
            serverUrlString = [serverUrlString stringByAppendingString:@"?auth_token="];
        }
        return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
    } else {
        return nil;
    }
}

+ (NSString *)addPlayerReturnerStat:(Athlete *)player Stats:(NSDictionary *)stats Stattype:(NSString *)stattype Token:(NSString *)authtoken {
    FootballStats *rbstats = [player findGameStatEntries:[currentSettings.game id]];
    if ([[rbstats football_stat] length] > 0) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
        serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
        serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
        serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
        serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
        serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats/"];
        serverUrlString = [serverUrlString stringByAppendingString:[rbstats football_stat]];
        if ([stattype isEqualToString:@"koreturn"])
            serverUrlString = [serverUrlString stringByAppendingString:@"/football_returners/koreturn.json"];
        else
            serverUrlString = [serverUrlString stringByAppendingString:@"/football_returners/puntreturn.json"];
        NSArray *keys = [stats allKeys];
        if ([keys count] > 0) {
            serverUrlString = [serverUrlString stringByAppendingString:@"?"];
            for (int i = 0; i < [keys count]; i++) {
                serverUrlString = [serverUrlString stringByAppendingString:[keys objectAtIndex:i]];
                serverUrlString = [serverUrlString stringByAppendingString:@"="];
                serverUrlString = [serverUrlString stringByAppendingString:[stats objectForKey:[keys objectAtIndex:i]]];
                serverUrlString = [serverUrlString stringByAppendingString:@"&"];
            }
            serverUrlString = [serverUrlString stringByAppendingString:@"auth_token="];
        } else {
            serverUrlString = [serverUrlString stringByAppendingString:@"?auth_token="];
        }
        return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
    } else {
        return nil;
    }
}

+ (NSString *)createPlayerStat:(Athlete *)player Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:[player athleteid]];
    serverUrlString = [serverUrlString stringByAppendingString:@"/football_stats.json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}
*/
+ (NSString *)getCoachList:(NSString *)teamid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/coaches.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:teamid];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];    
}

+ (NSString *)getCoach:(NSString*)coach Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/coaches/",
                             coach, @".json?auth_token=", authtoken];
}

+ (NSString *)newCoach:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/coaches.json?auth_token=", authtoken];
}

+ (NSString *)getTeamPhotos:(NSString *)team Token:(NSString *)authtoken
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/photos.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];    
}

+ (NSString *)getAthletePhotos:(NSString *)athlete Team:(NSString *)team Token:(NSString *)authtoken
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/photos.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&athlete[id]="];
    serverUrlString = [serverUrlString stringByAppendingString:athlete];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getGamePhotos:(NSString *)game Team:(NSString *)team Token:(NSString *)authtoken
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/photos.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&game[id]="];
    serverUrlString = [serverUrlString stringByAppendingString:game];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAthleteGamePhotos:(NSString *)athlete Game:(NSString *)game Team:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/photos.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&game[id]="];
    serverUrlString = [serverUrlString stringByAppendingString:game];
    serverUrlString = [serverUrlString stringByAppendingString:@"&athlete[id]="];
    serverUrlString = [serverUrlString stringByAppendingString:athlete];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];    
}

+ (NSString *)getUserPhotos:(NSString *)user Team:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/photos.json?team_id=", team, @"&user_id=", user, @"&auth_token=", authtoken];
}

+ (NSString *)getGameLogPhotos:(NSString *)gamelogid Team:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/photos.json?team_id=", team, @"&gamelog[id]=", gamelogid, @"&auth_token=", authtoken];
}

+ (NSString *)getPhoto:(NSString *)photo Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/photos/"];
    serverUrlString = [serverUrlString stringByAppendingString:photo];
    serverUrlString = [serverUrlString stringByAppendingFormat:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)newPhoto:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/photos/createmobile.json?auth_token=", authtoken];
}

+ (NSString *)deletePhoto:(NSString *)photoid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/photos/", photoid, @".json?auth_token=", authtoken];
}

+ (NSString *)untagAthletesPhoto:(Photo *)photo Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/photos/"];
    serverUrlString = [serverUrlString stringByAppendingString:photo.photoid];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@", @"/untag_athletes.json?auth_token=", authtoken];
}

+ (NSString *)tagAthletesPhoto:(Photo *)photo Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/photos/",
                              photo.photoid, @"/tag_athletes.json?auth_token=", authtoken];
}

+ (NSString *)getTeamVideos:(NSString *)team Token:(NSString *)authtoken
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/videoclips.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAthleteVideos:(NSString *)athlete Team:(NSString *)team Token:(NSString *)authtoken
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/videoclips.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&athlete[id]="];
    serverUrlString = [serverUrlString stringByAppendingString:athlete];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getGameVideos:(NSString *)game Team:(NSString *)team Token:(NSString *)authtoken
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/videoclips.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&game[id]="];
    serverUrlString = [serverUrlString stringByAppendingString:game];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAthleteGameVideos:(NSString *)athlete Game:(NSString *)game Team:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/videoclips.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"&game[id]="];
    serverUrlString = [serverUrlString stringByAppendingString:game];
    serverUrlString = [serverUrlString stringByAppendingString:@"&athlete[id]="];
    serverUrlString = [serverUrlString stringByAppendingString:athlete];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getUserVideos:(NSString *)user Team:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/videoclips.json?team_id=", team, @"&user[id]=", user, @"&auth_token=", authtoken];
}

+ (NSString *)getGameLogVideos:(NSString *)gamelogid Team:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/videoclips.json?team_id=", team, @"&gamelog[id]=", gamelogid, @"&auth_token=", authtoken];
}

+ (NSString *)getVideo:(NSString *)videoid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/videoclips/"];
    serverUrlString = [serverUrlString stringByAppendingString:videoid];
    serverUrlString = [serverUrlString stringByAppendingFormat:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)deleteVideo:(NSString *)videoid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/videoclips/",
                              videoid, @".json?auth_token=", authtoken];
}

+ (NSString *)newVideo:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/videoclips/createmobile.json?auth_token=", authtoken];
}

+ (NSString *)tagAthletesVideo:(Video *)video Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/videoclips/",
                              video.videoid, @"/tag_athletes.json?auth_token=", authtoken];
}

+ (NSString *)untagAthletesVideo:(Video *)video Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/videoclips/"];
    serverUrlString = [serverUrlString stringByAppendingString:video.videoid];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@", @"/untag_athletes.json?auth_token=", authtoken];
}

+ (NSString *)getContacts:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/contacts.json?authtoken="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getContact:(NSString *)contact Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/contacts/",
                              contact, @".json?auth_token=", authtoken];
}

+ (NSString *)getBlogs:(NSString *)teamid updatedAt:(NSString *)updatedat Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/blogs.json?team_id="];
    serverUrlString = [serverUrlString stringByAppendingString:teamid];
    
    if (updatedat.length > 0) {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@", @"&updated_at=", updatedat, @"&auth_token="];
    } else {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    }
    
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAthleteBlogs:(NSString *)athlete updatedAt:(NSString *)updatedat Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/blogs.json?player="];
    serverUrlString = [serverUrlString stringByAppendingString:athlete];
    
    if (updatedat.length > 0) {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@", @"&updated_at=", updatedat, @"&auth_token="];
    } else {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    }
    
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getCoachBlogs:(NSString *)coach updatedAt:(NSString *)updatedat Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/blogs.json?coachname="];
    serverUrlString = [serverUrlString stringByAppendingString:coach];
    
    if (updatedat.length > 0) {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@", @"&updated_at=", updatedat, @"&auth_token="];
    } else {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    }
    
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getGameBlogs:(NSString *)game updatedAt:(NSString *)updatedat Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/blogs.json?gamename="];
    serverUrlString = [serverUrlString stringByAppendingString:game];
    
    if (updatedat.length > 0) {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@", @"&updated_at=", updatedat, @"&auth_token="];
    } else {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    }
    
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getUserBlogs:(NSString *)user updatedAt:(NSString *)updatedat Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/blogs.json?username="];
    serverUrlString = [serverUrlString stringByAppendingString:user];
    
    if (updatedat.length > 0) {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@", @"&updated_at=", updatedat, @"&auth_token="];
    } else {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    }
    
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getBigPlayBlogs:(NSString *)gamelog updatedAt:(NSString *)updatedat Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/blogs.json?gamelog="];
    serverUrlString = [serverUrlString stringByAppendingString:gamelog];
    
    if (updatedat.length > 0) {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@", @"&updated_at=", updatedat, @"&auth_token="];
    } else {
        serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    }
    
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)newBlog:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/blogs.json"];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)deleteBlog:(NSString *)blogid Token:(NSString *)authoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    return serverUrlString = [serverUrlString stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", @"/blogs/", blogid,
                                                                @".json?auth_token=", currentSettings.user.authtoken]];
}

+ (NSString *)getAlerts:(NSString *)userid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sport_user_alerts.json?user_id="];
    serverUrlString = [serverUrlString stringByAppendingString:userid];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)deleteAlert:(NSString *)alertid Athlete:(NSString *)athleteid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athleteid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/alerts/"];
    serverUrlString = [serverUrlString stringByAppendingString:alertid];
    serverUrlString = [serverUrlString stringByAppendingFormat:@".json?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)clearAlerts:(NSString *)athleteid AlertType:(NSString *)alerttype Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/athletes/"];
    serverUrlString = [serverUrlString stringByAppendingString:athleteid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/alerts/"];
    serverUrlString = [serverUrlString stringByAppendingString:@"clearall?alerttype="];
    serverUrlString = [serverUrlString stringByAppendingString:alerttype];
    serverUrlString = [serverUrlString stringByAppendingString:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getAlertsSince:(NSString *)userid LastUpdate:(NSString *)lastUpdate Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sport_user_alerts.json?user_id="];
    serverUrlString = [serverUrlString stringByAppendingString:userid];
    serverUrlString = [serverUrlString stringByAppendingString:@"&updated_at="];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
//    serverUrlString = [serverUrlString stringByAppendingString:[formatter stringFromDate:lastUpdate]];
    serverUrlString = [serverUrlString stringByAppendingString:lastUpdate];
    serverUrlString = [serverUrlString stringByAppendingString:@"&auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getSiteList:(NSString *)state Zip:(NSString *)zip City:(NSString *)city SiteName:(NSString *)sitename Sportname:(NSString *)sportname {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@%@", @"/sports.json?sport=", sportname, @"&zip=", zip,
                              @"&city=", city, @"&state=", state, @"&sitename=", sitename];
}

+ (NSString *)changeDefaultSite:(NSString *)sportid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/users/"];
    serverUrlString = [serverUrlString stringByAppendingString:sportid];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports.json"];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)getStatConsolePlayers:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/teams/"];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"/getplayers.json"];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];
}

+ (NSString *)addStatConsolePlayers:(NSString *)team Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    serverUrlString = [serverUrlString stringByAppendingString:@"/sports/"];
    serverUrlString = [serverUrlString stringByAppendingString:currentSettings.sport.id];
    serverUrlString = [serverUrlString stringByAppendingString:@"/teams/"];
    serverUrlString = [serverUrlString stringByAppendingString:team];
    serverUrlString = [serverUrlString stringByAppendingString:@"/addplayers.json"];
    serverUrlString = [serverUrlString stringByAppendingFormat:@"?auth_token="];
    return serverUrlString = [serverUrlString stringByAppendingString:authtoken];    
}

+ (NSString *)getSponsors:(NSString *)authToken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/sponsors.json?auth_token=",
                              authToken];
}


+ (NSString *)getStandings:(NSString *)authToken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/teams/",
                              currentSettings.team.teamid, @"/standings.json?auth_token=", authToken];
}

+ (NSString *)updateTeamStanding:(Standings *)standing Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/teams/", currentSettings.team.teamid, @"/standings/savegamerecord.json?gameschedule_id=", standing.gameschedule_id,
                              @"&league_wins=", [standing.leaguewins stringValue], @"&league_losses=", [standing.leaguelosses stringValue],
                              @"&nonleague_wins=", [standing.nonleaguewins stringValue], @"&nonleague_losses=", [standing.nonleaguelosses stringValue],
                              @"&auth_token=", authtoken];
}

+ (NSString *)importTeamStanding:(NSString *)gameid Token:(NSString *)authtoken {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    return serverUrlString = [serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id,
                              @"/teams/", currentSettings.team.teamid, @"/standings/importteamrecord.json?gameschedule_id=",
                              gameid, @"&auth_token=", authtoken];
}

@end
