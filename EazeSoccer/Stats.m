//
//  PassingStats.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 3/28/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Stats.h"

@implementation Stats

@synthesize gamename;
@synthesize gameid;
@synthesize playerid;
@synthesize playername;
@synthesize statid;

@synthesize pass_attempts;
@synthesize comp_percentage;
@synthesize completions;
@synthesize sacks;
@synthesize interceptions;
@synthesize pass_tds;
@synthesize pass_yards;
@synthesize pass_yards_lost;
@synthesize pass_firstdowns;
@synthesize pass_twopointconv;

@synthesize rush_attempts;
@synthesize rush_average;
@synthesize rush_fumbles;
@synthesize rush_fumbles_lost;
@synthesize rush_longest;
@synthesize rush_tds;
@synthesize rush_yards;

@synthesize rec_average;
@synthesize rec_fumbles;
@synthesize rec_fumbles_lost;
@synthesize rec_longest;
@synthesize rec_receptions;
@synthesize rec_tds;
@synthesize rec_yards;
@synthesize rec_twopointconv;

@synthesize tackles;
@synthesize def_fumbles_recovered;
@synthesize def_int_long;
@synthesize def_int_yards;
@synthesize def_interceptions;
@synthesize def_pass_defended;
@synthesize def_sacks;
@synthesize def_td;
@synthesize tackles_assists;

@synthesize fgattempts;
@synthesize fgblocked;
@synthesize fglong;
@synthesize fgmade;
@synthesize xpattempts;
@synthesize xpblocked;
@synthesize xpmade;
@synthesize xpmissed;
@synthesize koattempts;
@synthesize kolong;
@synthesize koreturn;
@synthesize koreturned;
@synthesize kotd;
@synthesize kotouchbacks;
@synthesize koyards;
@synthesize punt_return;
@synthesize punt_returnlong;
@synthesize punt_returntd;
@synthesize punt_returnyards;
@synthesize punts;
@synthesize punts_blocked;
@synthesize punts_long;
@synthesize punts_yards;

- (id)init {
    if (self = [super init]) {
        pass_attempts = 0;
        comp_percentage = 0;
        completions = 0;
        sacks = 0;
        interceptions = 0;
        pass_tds = 0;
        pass_yards = 0;
        pass_yards_lost = 0;
        pass_firstdowns = 0;
        pass_twopointconv = 0;
        
        rush_attempts = 0;
        rush_average = 0;
        rush_fumbles = 0;
        rush_fumbles_lost = 0;
        rush_longest = 0;
        rush_tds = 0;
        rush_yards = 0;
        
        rec_average = 0;
        rec_fumbles = 0;
        rec_fumbles_lost = 0;
        rec_longest = 0;
        rec_receptions = 0;
        rec_tds = 0;
        rec_yards = 0;
        rec_twopointconv = 0;
        
        tackles = 0;
        def_fumbles_recovered = 0;
        def_int_long = 0;
        def_int_yards = 0;
        def_interceptions = 0;
        def_pass_defended = 0;
        def_sacks = 0;
        def_td = 0;
        tackles_assists = 0;
        
        fgattempts = 0;
        fgblocked = 0;
        fglong = 0;
        fgmade = 0;
        xpattempts = 0;
        xpblocked = 0;
        xpmade = 0;
        xpmissed = 0;
        koattempts = 0;
        kolong = 0;
        koreturn = 0;
        koreturned = 0;
        kotd = 0;
        kotouchbacks = 0;
        koyards = 0;
        punt_return = 0;
        punt_returnlong = 0;
        punt_returntd = 0;
        punt_returnyards = 0;
        punts = 0;
        punts_blocked = 0;
        punts_long = 0;
        punts_yards = 0;
        
        return self;
    } else
        return nil;
}

- (NSDictionary *)getRushingStats {
    NSDictionary *rushing = [[NSDictionary alloc] initWithObjectsAndKeys:rush_attempts, @"attempts",rush_average, @"average",
                            rush_fumbles, @"fumbles", rush_fumbles_lost, @"rush_fumbles_lost", rush_longest, @"rush_longest",
                            rush_tds, @"rush_tds", rush_yards, @"rush_yards", nil];
    return rushing;
}

- (Stats *)parseStats:(NSDictionary *)gamestats {
    self.statid = [gamestats objectForKey:@"id"];
    self.gamename = [gamestats objectForKey:@"gamename"];
    self.gameid = [gamestats objectForKey:@"game_id"];
    self.playername = [gamestats objectForKey:@"playername"];
    self.playerid = [gamestats objectForKey:@"player_id"];
    NSDictionary *passing = [gamestats objectForKey:@"passing"];
    if ([passing count] > 0) {
        self.pass_attempts = [passing objectForKey:@"attempts"];
        self.comp_percentage = [passing objectForKey:@"comp_percentage"];
        self.completions = [passing objectForKey:@"completions"];
        self.interceptions = [passing objectForKey:@"interceptions"];
        self.sacks = [passing objectForKey:@"sacks"];
        self.pass_tds = [passing objectForKey:@"td"];
        self.pass_yards = [passing objectForKey:@"yards"];
        self.pass_yards_lost = [passing objectForKey:@"yards_lost"];
        self.pass_firstdowns = [passing objectForKey:@"firstdowns"];
        self.pass_twopointconv = [passing objectForKey:@"twopointconv"];
    }
    NSDictionary *rushing = [gamestats objectForKey:@"rushing"];
    if ([rushing count] > 0) {
        self.rush_attempts = [rushing objectForKey:@"attempts"];
        self.rush_average = [rushing objectForKey:@"average"];
        self.rush_fumbles = [rushing objectForKey:@"fumbles"];
        self.rush_fumbles_lost = [rushing objectForKey:@"fumbles_lost"];
        self.rush_longest = [rushing objectForKey:@"longest"];
        self.rush_tds = [rushing objectForKey:@"td"];
        self.rush_yards = [rushing objectForKey:@"yards"];
        self.rush_firstdowns = [rushing objectForKey:@"firstdowns"];
        self.rush_twopointconv = [rushing objectForKey:@"twopointconv"];
    }
    NSDictionary *receivings = [gamestats objectForKey:@"receiving"];
    if ([receivings count] > 0) {
        self.rec_average = [receivings objectForKey:@"receiving"];
        self.rec_fumbles = [receivings objectForKey:@"fumbles"];
        self.rec_fumbles_lost = [receivings objectForKey:@"fumbles_lost"];
        self.rec_longest = [receivings objectForKey:@"longest"];
        self.rec_receptions = [receivings objectForKey:@"receptions"];
        self.rec_tds = [receivings objectForKey:@"td"];
        self.rec_yards = [receivings objectForKey:@"yards"];
        self.rec_twopointconv = [receivings objectForKey:@"twopointconv"];
    }
    NSDictionary *defense = [gamestats objectForKey:@"defense"];
    if ([defense count] > 0) {
        self.tackles_assists = [defense objectForKey:@"assists"];
        self.def_fumbles_recovered = [defense objectForKey:@"fumbels_recovered"];
        self.def_int_long = [defense objectForKey:@"int_long"];
        self.def_int_yards = [defense objectForKey:@"int_yards"];
        self.def_td = [defense objectForKey:@"int_td"];
        self.def_interceptions = [defense objectForKey:@"interceptions"];
        self.def_pass_defended = [defense objectForKey:@"pass_defended"];
        self.def_sacks = [defense objectForKey:@"sacks"];
        self.tackles = [defense objectForKey:@"tackles"];
        self.safety = [defense objectForKey:@"safety"];
    }
    NSDictionary *kickoffs = [gamestats objectForKey:@"kickoff"];
    if ([kickoffs count] > 0) {
        self.koattempts = [kickoffs objectForKey:@"koattempts"];
        self.koreturned = [kickoffs objectForKey:@"koreturned"];
        self.kotouchbacks = [kickoffs objectForKey:@"kotouchbacks"];
    }
    NSDictionary *placekicker = [gamestats objectForKey:@"placekicker"];
    if ([placekicker count] > 0) {
        self.fgattempts = [placekicker objectForKey:@"fgattempts"];
        self.fgblocked = [placekicker objectForKey:@"fgblocked"];
        self.fglong = [placekicker objectForKey:@"fglong"];
        self.fgmade = [placekicker objectForKey:@"fgmade"];
        self.xpattempts = [placekicker objectForKey:@"xpattempts"];
        self.xpblocked = [placekicker objectForKey:@"xpblocked"];
        self.xpmissed = [placekicker objectForKey:@"xpmissed"];
        self.xpmade = [placekicker objectForKey:@"xpmade"];
    }
    NSDictionary *punter = [gamestats objectForKey:@"punter"];
    if ([punter count] > 0) {
        self.punts = [punter objectForKey:@"punts"];
        self.punts_blocked = [punter objectForKey:@"punts_blocked"];
        self.punts_long = [punter objectForKey:@"punts_long"];
        self.punts_yards = [punter objectForKey:@"punts_yards"];
    }
    NSDictionary *koreturner = [gamestats objectForKey:@"kickoff_returner"];
    if ([koreturner count] > 0) {
        self.kolong = [koreturner objectForKey:@"kolong"];
        self.koreturn = [koreturner objectForKey:@"koreturns"];
        self.kotd = [koreturner objectForKey:@"kotd"];
        self.koyards = [koreturner objectForKey:@"koyards"];
    }
    NSDictionary *puntret = [gamestats objectForKey:@"punt_returner"];
    if ([puntret count] > 0) {
        self.punt_return = [puntret objectForKey:@"punt_return"];
        self.punt_returnlong = [puntret objectForKey:@"punt_returnlong"];
        self.punt_returntd = [puntret objectForKey:@"punt_returntd"];
        self.punt_returnyards = [puntret objectForKey:@"punt_returnyards"];
    }
    return self;
}

- (Stats *)parseStatsTotals:(NSDictionary *)stattotals {
    NSDictionary *defense_totals = [stattotals objectForKey:@"defense_totals"];
    self.def_fumbles_recovered = [defense_totals objectForKey:@"defense_fumbles_recovered"];
    self.tackles_assists = [defense_totals objectForKey:@"defense_assists"];
    self.def_int_long = [defense_totals objectForKey:@"defense_int_long"];
    self.def_int_yards = [defense_totals objectForKey:@"defense_int_yards"];
    self.def_td = [defense_totals objectForKey:@"defense_int_td"];
    self.def_interceptions = [defense_totals objectForKey:@"defense_interceptions"];
    self.def_pass_defended = [defense_totals objectForKey:@"defense_pass_defended"];
    self.def_sacks = [defense_totals objectForKey:@"defense_sacks"];
    self.tackles = [defense_totals objectForKey:@"defense_tackles"];
    self.safety = [ defense_totals objectForKey:@"defense_safety"];
    
    NSDictionary *kickoffreturn = [stattotals objectForKey:@"kickoff_returner_totals"];
    self.koreturn = [kickoffreturn objectForKey:@"returners_koreturns"];
    self.kolong = [kickoffreturn objectForKey:@"returners_kolong"];
    self.kotd = [kickoffreturn objectForKey:@"returners_kotd"];
    self.koyards = [kickoffreturn objectForKey:@"returners_koyards"];
    
    NSDictionary *kototals = [stattotals objectForKey:@"kickoff_totals"];
    self.koattempts = [kototals objectForKey:@"kickers_koattempts"];
    self.koreturned = [kototals objectForKey:@"kickers_koreturned"];
    self.kotouchbacks = [kototals objectForKey:@"kickers_kotouchbacks"];
    
    NSDictionary *plkick = [stattotals objectForKey:@"placekicking_totals"];
    self.fgattempts = [plkick objectForKey:@"kickers_fgattempts"];
    self.fgblocked = [plkick objectForKey:@"kickers_fgblocked"];
    self.fglong = [plkick objectForKey:@"kickers_fglong"];
    self.fgmade = [plkick objectForKey:@"kickers_fgmade"];
    self.xpattempts = [plkick objectForKey:@"kickers_xpattempts"];
    self.xpblocked = [plkick objectForKey:@"kickers_xpblocked"];
    self.xpmade = [plkick objectForKey:@"kickers_xpmade"];
    self.xpmissed = [plkick objectForKey:@"kickers_xpmissed"];
    
    NSDictionary *preturn = [stattotals objectForKey:@"punt_returner_totals"];
    self.punt_return = [preturn objectForKey:@"returners_punt_return"];
    self.punt_returnlong = [preturn objectForKey:@"returners_punt_returnlong"];
    self.punt_returntd = [preturn objectForKey:@"returners_punt_returntd"];
    self.punt_returnyards = [preturn objectForKey:@"returners_punt_returnyards"];
    
    NSDictionary *punter = [stattotals objectForKey:@"punter_totals"];
    self.punts = [punter objectForKey:@"kickers_punts"];
    self.punts_blocked = [punter objectForKey:@"kickers_punts_blocked"];
    self.punts_long = [punter objectForKey:@"kickers_punts_long"];
    self.punts_yards = [punter objectForKey:@"kickers_punts_yards"];
    
    NSDictionary *passing = [stattotals objectForKey:@"passing_totals"];
    self.comp_percentage = [passing objectForKey:@"comp_percentage"];
    self.pass_attempts = [passing objectForKey:@"passing_attempts"];
    self.sacks = [passing objectForKey:@"passing_sacks"];
    self.completions = [passing objectForKey:@"passing_completions"];
    self.pass_yards = [passing objectForKey:@"passing_yards"];
    self.pass_yards_lost = [passing objectForKey:@"passing_yards_lost"];
    self.pass_tds = [passing objectForKey:@"passing_tds"];
    self.interceptions = [passing objectForKey:@"passing_int"];
    self.pass_twopointconv = [passing objectForKey:@"passing_twopointconv"];
    self.pass_firstdowns = [passing objectForKey:@"passing_firstdowns"];
    
    NSDictionary *receive = [stattotals objectForKey:@"receiving_totals"];
    self.rec_average = [receive objectForKey:@"average"];
    self.rec_fumbles = [receive objectForKey:@"receiving_fumbles"];
    self.rec_fumbles_lost = [receive objectForKey:@"receiving_fumbles_lost"];
    self.rec_longest = [receive objectForKey:@"receiving_longest"];
    self.rec_receptions = [receive objectForKey:@"receiving_receptions"];
    self.rec_tds = [receive objectForKey:@"receiving_tds"];
    self.rec_yards = [receive objectForKey:@"receiving_yards"];
    self.rec_twopointconv = [receive objectForKey:@"receiving_twopointconv"];
    
    NSDictionary *rush = [stattotals objectForKey:@"rushing_totals"];
    self.rush_average = [rush objectForKey:@"average"];
    self.rush_attempts = [rush objectForKey:@"rushing_attempts"];
    self.rush_fumbles = [rush objectForKey:@"rushing_fumbles"];
    self.rush_fumbles_lost = [rush objectForKey:@"rushing_fumbles_lost"];
    self.rush_longest = [rush objectForKey:@"rushing_longest"];
    self.rush_tds = [rush objectForKey:@"rushing_tds"];
    self.rush_yards = [rush objectForKey:@"rushing_yards"];
    
    return self;
}

- (BOOL)hasPassing {
    if ([self.pass_attempts intValue] > 0)
        return YES;
    else
        return NO;
}

- (BOOL)hasRushing {
    if ([self.rush_attempts intValue] > 0)
        return YES;
    else
        return NO;
}

- (BOOL)hasReceiving {
    if ([self.rec_receptions intValue] > 0)
        return YES;
    else
        return NO;
}

- (BOOL)hasDefense {
    if (([self.tackles intValue] > 0) || ([self.tackles_assists intValue] > 0) || ([def_interceptions intValue] > 0) ||
        ([self.def_sacks intValue] > 0) || ([self.def_td intValue] > 0) || ([self.def_fumbles_recovered intValue] > 0))
        return YES;
    else
        return NO;
}

- (BOOL)hasPlaceKicker {
    if (([self.fgattempts intValue] > 0) || ([self.xpattempts intValue] > 0))
        return YES;
    else
        return NO;
}

- (BOOL)hasKickoff {
    if ([self.koattempts intValue] > 0)
        return YES;
    else
        return NO;
}

- (BOOL)hasPunter {
    if ([self.punts intValue] > 0)
        return YES;
    else
        return NO;
}

- (BOOL)hasKickoffReturner {
    if ([self.koreturn intValue] > 0)
        return YES;
    else
        return NO;
}

- (BOOL)hasPuntReturner {
    if ([self.punt_return intValue] > 0)
        return YES;
    else
        return NO;
}

@end
