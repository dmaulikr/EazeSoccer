//
//  Athlete.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 3/26/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Athlete.h"
#import "EazesportzAppDelegate.h"

@implementation Athlete

@synthesize number;
@synthesize lastname;
@synthesize firstname;
@synthesize middlename;
@synthesize name;
@synthesize full_name;
@synthesize logname;
@synthesize height;
@synthesize weight;
@synthesize position;
@synthesize year;
@synthesize season;
@synthesize bio;
@synthesize athleteid;
@synthesize tinypic;
@synthesize thumb;
@synthesize mediumpic;
@synthesize largepic;
@synthesize teamid;
@synthesize teamname;
@synthesize following;
@synthesize hasphotos;
@synthesize hasvideos;
@synthesize processing;

@synthesize football_stats;
@synthesize stats;

@synthesize basketball_stats;

@synthesize soccer_stats;

@synthesize thumbimage;
@synthesize tinyimage;
@synthesize mediumimage;

- (id)init {
    if (self = [super init]) {
        if ([currentSettings.sport.name isEqualToString:@"Football"])
            football_stats = [[NSMutableArray alloc] init];
        else if ([currentSettings.sport.name isEqualToString:@"Basketball"])
            basketball_stats = [[NSMutableArray alloc] init];
        else if ([currentSettings.sport.name isEqualToString:@"Soccer"])
            soccer_stats = [[NSMutableArray alloc] init];
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)athleteDictionary {
    if ((self == [super init]) && (athleteDictionary.count > 0)) {
        athleteid = [athleteDictionary objectForKey:@"id"];
        
        if ((NSNull *)[athleteDictionary objectForKey:@"number"] != [NSNull null])
            number = [athleteDictionary objectForKey:@"number"];
        else
            number = 0;
        
        bio = [athleteDictionary objectForKey:@"bio"];
        name = [athleteDictionary objectForKey:@"name"];
        full_name = [athleteDictionary objectForKey:@"full_name"];
        logname = [athleteDictionary objectForKey:@"logname"];
        firstname = [athleteDictionary objectForKey:@"firstname"];
        middlename = [athleteDictionary objectForKey:@"middlename"];
        lastname = [athleteDictionary objectForKey:@"lastname"];
        height = [athleteDictionary objectForKey:@"height"];
        
        if ((NSNull *)[athleteDictionary objectForKey:@"weight"] != [NSNull null])
            weight = [athleteDictionary objectForKey:@"weight"];
        else
            weight = 0;
        
        position = [athleteDictionary objectForKey:@"position"];
        year = [athleteDictionary objectForKey:@"year"];
        season = [athleteDictionary objectForKey:@"season"];
        teamid = [athleteDictionary objectForKey:@"team_id"];
        teamname = [athleteDictionary objectForKey:@"teamname"];
        tinypic = [athleteDictionary objectForKey:@"tiny"];
        thumb = [athleteDictionary objectForKey:@"thumb"];
        mediumpic = [athleteDictionary objectForKey:@"mediumpic"];
        largepic = [athleteDictionary objectForKey:@"largepic"];
        following = [NSNumber numberWithBool:[[athleteDictionary objectForKey:@"following"] boolValue]];
        hasvideos = [[athleteDictionary objectForKey:@"hasvideos"] boolValue];
        hasphotos = [[athleteDictionary objectForKey:@"hasphotos"] boolValue];
        
        if ([currentSettings.sport.name isEqualToString:@"Football"]) {
            NSArray *fstats = [athleteDictionary objectForKey:@"football_stats"];
            football_stats = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [fstats count]; i++) {
                NSDictionary *entry = [fstats objectAtIndex:i];
                NSDictionary *fbstats = [entry objectForKey:@"football_stat"];
                FootballStats *theentry = [[FootballStats alloc] init];
                theentry.gameschedule_id = [fbstats objectForKey:@"gamescheduleid"];
                theentry.football_stat = [fbstats objectForKey:@"football_stat_id"];
                NSDictionary *statitem = [fbstats objectForKey:@"football_defense"];
                theentry.defense = [statitem objectForKey:@"football_defense_id"];
                statitem = [fbstats objectForKey:@"football_passing"];
                theentry.passing = [statitem objectForKey:@"football_passing_id"];
                statitem = [fbstats objectForKey:@"football_rushing"];
                theentry.rushing = [statitem objectForKey:@"football_rushing_id"];
                statitem = [fbstats objectForKey:@"football_receiving"];
                theentry.receiving = [statitem objectForKey:@"football_receiving_id"];
                statitem = [fbstats objectForKey:@"football_kicker"];
                theentry.kickers = [statitem objectForKey:@"football_kicker_id"];
                statitem = [fbstats objectForKey:@"football_returner"];
                theentry.returners = [statitem objectForKey:@"football_returner_id"];
                [football_stats addObject:theentry];
            }
        } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
            NSArray *bballstats = [athleteDictionary objectForKey:@"basketball_stats"];
            basketball_stats = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [bballstats count]; i++) {
                NSDictionary *entry = [bballstats objectAtIndex:i];
                [basketball_stats addObject:[[BasketballStats alloc] initWithDirectory:[entry objectForKey:@"basketball_stats"]]];
            }
        } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
            NSArray *soccerstats = [athleteDictionary objectForKey:@"soccers"];
            soccer_stats = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < soccerstats.count; i++) {
                NSDictionary *entry = [soccerstats objectAtIndex:i];
                [soccer_stats addObject:[[Soccer alloc] initWithDirectory:[entry objectForKey:@"soccer"]]];
            }
        }
        
        return self;
    } else {
        return nil;
    }
}

- (BasketballStats *)findBasketballGameStatEntries:(NSString *)gameid {
    BasketballStats *entry = nil;
    for (int i = 0; i < [basketball_stats count]; i++) {
        if ([[[basketball_stats objectAtIndex:i] gameschedule_id] isEqualToString:gameid]) {
            entry = [basketball_stats objectAtIndex:i];
        }
    }
    return entry;
}

- (void)updateBasketballGameStats:(BasketballStats *)bballstats Game:(NSString *)gameid {
    int i;
    for (i = 0; i < [basketball_stats count]; i++) {
        if ([[[basketball_stats objectAtIndex:i] gameschedule_id] isEqualToString:gameid]) {
            break;
        }
    }
    
    if (i < basketball_stats.count) {
        [basketball_stats removeObjectAtIndex:i];
    }
    [basketball_stats addObject:bballstats];
}

- (Soccer *)findSoccerGameStats:(NSString *)gameid {
    Soccer *entry = nil;
    for (int i = 0; i < [soccer_stats count]; i++) {
        if ([[[soccer_stats objectAtIndex:i] gameschedule_id] isEqualToString:gameid]) {
            entry = [soccer_stats objectAtIndex:i];
        }
    }
    return entry;
}

- (void)updateSoccerGameStats:(Soccer *)soccerstat Game:(NSString *)gameid {
    int i;
    for (i = 0; i < [soccer_stats count]; i++) {
        if ([[[soccer_stats objectAtIndex:i] gameschedule_id] isEqualToString:gameid]) {
            break;
        }
    }
    
    if (i < soccer_stats.count) {
        [soccer_stats removeObjectAtIndex:i];
    }
    [soccer_stats addObject:soccerstat];
}

- (BOOL)isSoccerGoalie {
    BOOL result = NO;
    
    for (int i = 0; i < soccer_stats.count; i++) {
        if ([[soccer_stats objectAtIndex:i] goalieStats]) {
            result = YES;
            break;
        }
    }
    
    return result;
}

- (UIImage *)getImage:(NSString *)size {
    UIImage *image;
    
    if ([size isEqualToString:@"tiny"] ) {
        
        if ([self.tinypic isEqualToString:@"/pics/tiny/missing.png"]) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if (self.processing) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
        } else if ((self.tinyimage.CIImage == nil) && (self.tinyimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:self.tinypic];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            self.tinyimage = image;
        } else
            image = self.tinyimage;
        
    } else if ([size isEqualToString:@"thumb"]) {
        
        if ([self.thumb isEqualToString:@"/pics/thumb/missing.png"]) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if (self.processing) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
        } else if ((self.thumbimage.CIImage == nil) && (self.thumbimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:self.thumb];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            self.thumbimage = image;
        } else
            image = self.thumbimage;
        
    } else if ([size isEqualToString:@"medium"]) {
        
        if ([self.mediumpic isEqualToString:@"/pics/medium/missing.png"]) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if ((self.mediumimage.CIImage == nil) && (self.mediumimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:self.mediumpic];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            self.mediumimage = image;
        } else
            image = self.mediumimage;
        
    }
    
    return image;
}

@end
