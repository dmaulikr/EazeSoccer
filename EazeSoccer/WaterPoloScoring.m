//
//  WaterPoloScoring.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "WaterPoloScoring.h"
#import "EazesportzAppDelegate.h"

@implementation WaterPoloScoring

@synthesize waterpolo_scoring_id;
@synthesize waterpolo_stat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize gametime;
@synthesize assist;
@synthesize period;

@synthesize photos;
@synthesize videos;
@synthesize dirty;

- (id)init {
    if (self = [super init]) {
        period = [NSNumber numberWithInt:0];
        assist = @"";
        gametime = @"00:00";
        photos = [[NSMutableArray alloc] init];
        videos = [[NSMutableArray alloc] init];
        dirty = NO;
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)waterpolo_scoring_dictionary {
    if (self == [super init]) {
        waterpolo_scoring_id = [waterpolo_scoring_dictionary objectForKey:@"waterpolo_scoring_id"];
        waterpolo_stat_id = [waterpolo_scoring_dictionary objectForKey:@"waterpolo_stat_id"];
        athlete_id = [waterpolo_scoring_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [waterpolo_scoring_dictionary objectForKey:@"visitor_roster_id"];
        
        gametime = [waterpolo_scoring_dictionary objectForKey:@"gametime"];
        assist = [waterpolo_scoring_dictionary objectForKey:@"assist"];
        period = [waterpolo_scoring_dictionary objectForKey:@"period"];
        
        NSArray *photoarray = [waterpolo_scoring_dictionary objectForKey:@"photos"];
        photos = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < photoarray.count; i++) {
            NSDictionary *dictionary = [photoarray objectAtIndex:i];
            [photos addObject:[dictionary objectForKey:@"id"]];
        }
        
        NSArray *videoarray = [waterpolo_scoring_dictionary objectForKey:@"videos"];
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
                                       period, @"period", assist, @"assist",nil];
    
    if (waterpolo_stat_id)
        [dictionary setValue:waterpolo_stat_id forKey:@"waterpolo_stat_id"];
    
    if (waterpolo_scoring_id)
        [dictionary setValue:waterpolo_scoring_id forKey:@"waterpolo_scoring_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    else
        [dictionary setValue:visitor_roster_id forKey:@"visitor_roster_id"];
    
    return dictionary;
}

- (NSString *)getScoreLog {
    NSString *score = [NSString stringWithFormat:@"%@ - %@: %@", [period stringValue], gametime, [[currentSettings findAthlete:athlete_id] numberLogname]];
    
    if (assist.length > 0)
        score = [score stringByAppendingString:[NSString stringWithFormat:@", Assist: %@", [[currentSettings findAthlete:assist] numberLogname]]];
    
    return score;
}

@end
