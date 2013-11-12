//
//  GameSchedule.m
//  smpwlions
//
//  Created by Gil on 3/15/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "GameSchedule.h"
#import "EazesportzAppDelegate.h"

@implementation GameSchedule

@synthesize id;
@synthesize startdate;
@synthesize starttime;
@synthesize location;
@synthesize homeaway;
@synthesize event;
@synthesize opponent;
@synthesize leaguegame;
@synthesize opponent_name;
@synthesize opponent_mascot;
@synthesize opponentpic;
@synthesize eazesportzOpponent;
@synthesize gameisfinal;
@synthesize lastplay;
@synthesize homescore;
@synthesize opponentscore;

@synthesize game_name;

@synthesize homeq1;
@synthesize homeq2;
@synthesize homeq3;
@synthesize homeq4;
@synthesize opponentq1;
@synthesize opponentq2;
@synthesize opponentq3;
@synthesize opponentq4;
@synthesize penalty;
@synthesize firstdowns;
@synthesize penaltyyards;
@synthesize possession;
@synthesize ballon;
@synthesize own;
@synthesize currentgametime;
@synthesize our;
@synthesize down;
@synthesize currentqtr;

@synthesize togo;

@synthesize hometimeouts;
@synthesize opoonenttimeouts;

@synthesize homefouls;
@synthesize visitorfouls;
@synthesize homebonus;
@synthesize visitorbonus;
@synthesize period;

@synthesize socceroppck;
@synthesize socceroppsaves;
@synthesize socceroppsog;

@synthesize httperror;

- (id)initWithDictionary:(NSDictionary *)gameScheduleDictionary {
    if ((self = [super init]) && (gameScheduleDictionary.count > 0)) {
        //    gamelogs = [[NSMutableArray alloc] init];
        self.id = [gameScheduleDictionary objectForKey:@"id"];
        opponent = [gameScheduleDictionary objectForKey:@"opponent"];
        leaguegame = [[gameScheduleDictionary objectForKey:@"league"] boolValue];
        opponent_name = [gameScheduleDictionary objectForKey:@"opponent_name"];
        opponent_mascot = [gameScheduleDictionary objectForKey:@"opponent_mascot"];
        opponentpic = [gameScheduleDictionary objectForKey:@"opponentpic"];
        eazesportzOpponent = [[gameScheduleDictionary objectForKey:@"eazesportzOpponent"] boolValue];
        location = [gameScheduleDictionary objectForKey:@"location"];
        starttime = [gameScheduleDictionary objectForKey:@"starttime"];
        startdate = [gameScheduleDictionary objectForKey:@"gamedate"];
        homeaway = [gameScheduleDictionary objectForKey:@"homeaway"];
        event = [gameScheduleDictionary objectForKey:@"event"];
        game_name = [gameScheduleDictionary objectForKey:@"game_name"];
        homeq1 = [gameScheduleDictionary objectForKey:@"homeq1"];
        homeq2 = [gameScheduleDictionary objectForKey:@"homeq2"];
        homeq3 = [gameScheduleDictionary objectForKey:@"homeq3"];
        homeq4 = [gameScheduleDictionary objectForKey:@"homeq4"];
        opponentq1 = [gameScheduleDictionary objectForKey:@"opponentq1"];
        opponentq2 = [gameScheduleDictionary objectForKey:@"opponentq2"];
        opponentq3 = [gameScheduleDictionary objectForKey:@"opponentq3"];
        opponentq4 = [gameScheduleDictionary objectForKey:@"opponentq4"];
        penaltyyards = [gameScheduleDictionary objectForKey:@"penaltyyards"];
        firstdowns = [gameScheduleDictionary objectForKey:@"firstdowns"];
        penalty = [gameScheduleDictionary objectForKey:@"penalty"];
        down = [gameScheduleDictionary objectForKey:@"down"];
        lastplay = [gameScheduleDictionary objectForKey:@"lastplay"];
        currentgametime = [gameScheduleDictionary objectForKey:@"current_game_time"];
        ballon = [gameScheduleDictionary objectForKey:@"ballon"];
        our = [gameScheduleDictionary objectForKey:@"our"];
        possession = [gameScheduleDictionary objectForKey:@"possession"];
        currentqtr = [gameScheduleDictionary objectForKey:@"currentqtr"];
        gameisfinal = [gameScheduleDictionary objectForKey:@"final"];
        togo = [gameScheduleDictionary objectForKey:@"togo"];
        homescore = [gameScheduleDictionary objectForKey:@"homescore"];
        opponentscore = [gameScheduleDictionary objectForKey:@"opponentscore"];
        hometimeouts = [gameScheduleDictionary objectForKey:@"hometimeouts"];
        opoonenttimeouts = [gameScheduleDictionary objectForKey:@"opponenttimeouts"];
        homebonus = [[gameScheduleDictionary objectForKey:@"homebonus"] boolValue];
        homefouls = [gameScheduleDictionary objectForKey:@"homefouls"];
        visitorbonus = [[gameScheduleDictionary objectForKey:@"visitorbonus"] boolValue];
        visitorfouls = [gameScheduleDictionary objectForKey:@"opponentfouls"];
        period = [gameScheduleDictionary objectForKey:@"currentperiod"];
        
        socceroppsog = [gameScheduleDictionary objectForKey:@"socceroppsog"];
        socceroppsaves = [gameScheduleDictionary objectForKey:@"socceroppsaves"];
        socceroppck = [gameScheduleDictionary objectForKey:@"socceroppck"];
        
        /*
         NSMutableArray *gamelogs = [gameScheduleDictionary objectForKey:@"gamelogs"];
         for (int cnt = 0; cnt < [gamelogs count]; cnt++) {
         NSDictionary *entry = [gamelogs objectAtIndex:cnt];
         NSLog(@"%@", entry);
         NSDictionary *thelog = [entry objectForKey:@"gamelog"];
         Gamelogs *log = [[Gamelogs alloc] init];
         log.gamelogid = [thelog objectForKey:@"id"];
         log.logentry = [thelog objectForKey:@"logentrytext"];
         log.period = [thelog objectForKey:@"period"];
         log.score = [thelog objectForKey:@"score"];
         log.time = [thelog objectForKey:@"time"];
         log.hasvideos = [[thelog objectForKey:@"hasvideos"] boolValue];
         log.hasphotos = [[thelog objectForKey:@"hasphotos"] boolValue];
         [gamelogs addObject:log];
         }
         
        playerlist = [[NSMutableArray alloc] init];
        for (int i = 0; i < [keys count]; i++) {
            Athlete *player = nil;
            if ((player = [currentSettings findAthleteByLogname:[keys objectAtIndex:i]]) != nil) {
                [playerlist addObject:[player athleteid]];
                NSDictionary *gamestats = [gameScheduleDictionary objectForKey:[keys objectAtIndex:i]];
                //            Stats *newstat = [[Stats alloc] init];
                //            [currentSettings addAthleteStats:player Stats:[newstat parseStats:gamestats]];
            }
            if ((NSNull *)[gameScheduleDictionary objectForKey:@"football_stats"] != [NSNull null]) {
                NSDictionary *stattotals = [gameScheduleDictionary objectForKey:@"football_stats"];
                //            totals = [[Stats alloc] init];
                //            [totals parseStatsTotals:stattotals];
            }
        } */
        return self;
    } else {
        return nil;
    }
}

/* @synthesize gamelogs;

- (Gamelogs *)findGamelog:(NSString *)gamelogid {
    Gamelogs *gamelog = nil;
    
    for (int i = 0; i < gamelogs.count; i++) {
        if ([[[gamelogs objectAtIndex:i] gamelogid] isEqualToString:gamelogid]) {
            gamelog = [gamelogs objectAtIndex:i];
            break;
        }
        
    }
    
    return gamelog;
}
*/

- (BOOL)saveGameschedule {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    NSURL *url;
    
    if (self.id) {
        url = [NSURL URLWithString:[serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/teams/",
                                    currentSettings.team.teamid, @"/gameschedules/", self.id, @".json?auth_token=", currentSettings.user.authtoken]];
    } else {
        url = [NSURL URLWithString:[serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/teams/",
                                    currentSettings.team.teamid, @"/gameschedules.json?auth_token=", currentSettings.user.authtoken]];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *pickerDate = [formatter dateFromString:startdate];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *time = [starttime componentsSeparatedByString:@":"];
    
    NSMutableDictionary *gamedict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:opponent, @"opponent",
                                     opponent_mascot, @"opponent_mascot", location, @"location",
                                     event, @"event", startdate, @"gamedate",
                                     [time objectAtIndex:0], @"starttime(4i)", [time objectAtIndex:1], @"starttime(5i)",
                                     homeaway, @"homeaway", [homescore stringValue], @"homescore",
                                     [opponentscore stringValue], @"opponentscore", [[NSNumber numberWithBool:leaguegame] stringValue], @"league", nil];
    
    if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        [gamedict setValue:[socceroppsog stringValue] forKey:@"socceroppsog"];
        [gamedict setValue:[socceroppsaves stringValue] forKey:@"socceroppsaves"];
        [gamedict setValue:[socceroppck stringValue] forKey:@"socceroppck"];
        [gamedict setValue:[period stringValue] forKey:@"currentperiod"];
        NSArray *timearray = [currentgametime componentsSeparatedByString:@":"];
        [gamedict setValue:timearray[0] forKey:@"livegametime(4i)"];
        [gamedict setValue:timearray[1] forKey:@"livegametime(5i)"];
    } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
        [gamedict setValue:[visitorfouls stringValue] forKey:@"opponentfouls"];
        [gamedict setValue:[opponentscore stringValue] forKey:@"opponentscore"];
        [gamedict setValue:[period stringValue] forKey:@"currentperiod"];
        [gamedict setValue:[[NSNumber numberWithBool:visitorbonus] stringValue] forKey:@"visitorbonus"];
        [gamedict setValue:[[NSNumber numberWithBool:homebonus] stringValue] forKey:@"homebonus"];
        NSArray *timearray = [currentgametime componentsSeparatedByString:@":"];
        [gamedict setValue:timearray[0] forKey:@"livegametime(4i)"];
        [gamedict setValue:timearray[1] forKey:@"livegametime(5i)"];
        [gamedict setValue:possession forKey:@"bballpossessionarrow"];
    }
    
    NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
    [jsonDict setValue:gamedict forKey:@"gameschedule"];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (!self.id) {
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:@"PUT"];
    }
    
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([httpResponse statusCode] == 200) {
        
        if (self.id.length == 0)
            self.id = [[serverData objectForKey:@"schedule"] objectForKey:@"_id"];
        
        return YES;
    } else {
        httperror = [serverData objectForKey:@"error"];
        return NO;
    }
}

- (id)initDeleteGame {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/", self.id,
                                        @".json?auth_token=", currentSettings.user.authtoken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if ([httpResponse statusCode] == 200) {
        self = nil;
        return self;
    } else {
        httperror = [serverData objectForKey:@"error"];
        return  self;
    }
}

- (UIImage *)opponentImage {
    if ([opponentpic isEqualToString:@"/opponentpics/original/missing.png"]) {
        return [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    } else {
        NSURL * imageURL = [NSURL URLWithString:opponentpic];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        return [UIImage imageWithData:imageData];
    }
}

@end
