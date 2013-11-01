//
//  GameSchedule.m
//  smpwlions
//
//  Created by Gil on 3/15/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "GameSchedule.h"

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
@synthesize lastplay;
@synthesize possession;
@synthesize ballon;
@synthesize own;
@synthesize currentgametime;
@synthesize our;
@synthesize down;
@synthesize currentqtr;
@synthesize gameisfinal;
@synthesize togo;

@synthesize homescore;
@synthesize opponentscore;
@synthesize hometimeouts;
@synthesize opoonenttimeouts;
@synthesize homefouls;
@synthesize visitorfouls;
@synthesize homebonus;
@synthesize visitorbonus;
@synthesize period;

- (id)initWithDictionary:(NSDictionary *)gameScheduleDictionary {
    if ((self = [super init]) && (gameScheduleDictionary.count > 0)) {
        //    gamelogs = [[NSMutableArray alloc] init];
        self.id = [gameScheduleDictionary objectForKey:@"id"];
        opponent = [gameScheduleDictionary objectForKey:@"opponent"];
        leaguegame = [[gameScheduleDictionary objectForKey:@"league"] boolValue];
        opponent_name = [gameScheduleDictionary objectForKey:@"opponent_name"];
        opponent_mascot = [gameScheduleDictionary objectForKey:@"opponent_mascot"];
        opponentpic = [gameScheduleDictionary objectForKey:@"opponentpic"];
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
@end
