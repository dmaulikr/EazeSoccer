//
//  HockeyScoring.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "HockeyScoring.h"

#import "EazesportzAppDelegate.h"

@implementation HockeyScoring

@synthesize hockey_scoring_id;
@synthesize hockey_stat_id;
@synthesize athlete_id;

@synthesize gametime;
@synthesize assist;
@synthesize period;
@synthesize assisttype;
@synthesize goaltype;

@synthesize photos;
@synthesize videos;
@synthesize dirty;

- (id)init {
    if (self = [super init]) {
        period = [NSNumber numberWithInt:0];
        assist = @"";
        gametime = @"00:00";
        assisttype = @"";
        goaltype = @"";
        photos = [[NSMutableArray alloc] init];
        videos = [[NSMutableArray alloc] init];
        dirty = NO;
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)hockey_scoring_dictionary {
    if (self == [super init]) {
        hockey_scoring_id = [hockey_scoring_dictionary objectForKey:@"hockey_scoring_id"];
        hockey_stat_id = [hockey_scoring_dictionary objectForKey:@"hockey_stat_id"];
        athlete_id = [hockey_scoring_dictionary objectForKey:@"athlete_id"];
        
        gametime = [hockey_scoring_dictionary objectForKey:@"gametime"];
        assist = [hockey_scoring_dictionary objectForKey:@"assist"];
        period = [hockey_scoring_dictionary objectForKey:@"period"];
        assisttype = [hockey_scoring_dictionary objectForKey:@"assisttype"];
        goaltype = [hockey_scoring_dictionary objectForKey:@"goaltype"];
        
        NSArray *photoarray = [hockey_scoring_dictionary objectForKey:@"photos"];
        photos = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < photoarray.count; i++) {
            NSDictionary *dictionary = [photoarray objectAtIndex:i];
            [photos addObject:[dictionary objectForKey:@"id"]];
        }
        
        NSArray *videoarray = [hockey_scoring_dictionary objectForKey:@"videos"];
        videos = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < videoarray.count; i++) {
            NSDictionary *dictionary = [videoarray objectAtIndex:i];
            [videos addObject:[dictionary objectForKey:@"id"]];
        }
        
        return  self;
    } else
        return nil;
}

- (NSMutableDictionary *)getDictionary {
    NSArray *timearray = [gametime componentsSeparatedByString:@":"];
    
    if (timearray.count < 2) {
        timearray = [[NSArray alloc] initWithObjects:@"00", @"00", nil];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:timearray[0], @"minutes", timearray[1], @"seconds",
                                       period, @"period", assist, @"assist", assisttype, @"assisttype", goaltype, @"goaltype", nil];
    
    if (hockey_stat_id)
        [dictionary setValue:hockey_stat_id forKey:@"hockey_stat_id"];
    
    if (hockey_scoring_id)
        [dictionary setValue:hockey_scoring_id forKey:@"hockey_scoring_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    
    return dictionary;
}

- (NSString *)getScoreLog {
    NSString *score = [NSString stringWithFormat:@"%@ - %@: %@", [period stringValue], gametime, [[currentSettings findAthlete:athlete_id] numberLogname]];
    
    if (assist.length > 0)
        score = [score stringByAppendingString:[NSString stringWithFormat:@", Assist: %@", [[currentSettings findAthlete:assist] numberLogname]]];
    
    return score;
}

@end
