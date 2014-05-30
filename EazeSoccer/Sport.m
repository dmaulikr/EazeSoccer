//
//  Sport.m
//  sportzSoftwareHome
//
//  Created by Gil on 2/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Sport.h"

@implementation Sport {
    NSString *logosize;
}

@synthesize id;
@synthesize sitename;
@synthesize mascot;
@synthesize year;
@synthesize zip;
@synthesize state;
@synthesize city;
@synthesize country;
@synthesize banner;
@synthesize season;
@synthesize name;
@synthesize sport_logo_thumb;
@synthesize sport_logo_tiny;
@synthesize siteid;
@synthesize has_stats;
@synthesize alert_interval;
@synthesize gamelog_interval;
@synthesize newsfeed_interval;

@synthesize beta;
@synthesize approved;
@synthesize hideAds;

@synthesize review_media;
@synthesize enable_user_pics;
@synthesize enable_user_video;

@synthesize package;
@synthesize silverMedia;
@synthesize goldMedia;
@synthesize platinumMedia;

@synthesize streamingurl;
@synthesize streamingbucket;
@synthesize pricingurl;
@synthesize enablelive;
@synthesize adurl;

@synthesize supportedsports;

@synthesize teamcount;

@synthesize playerPositions;

@synthesize lacrosse_score_codes;
@synthesize lacrosse_periods;
@synthesize lacrosse_shots;
@synthesize lacrosse_personal_fouls;
@synthesize lacrosse_technical_fouls;

@synthesize footballDefensePositions;
@synthesize footballOffensePositions;
@synthesize footballSpecialTeamsPositions;

@synthesize sportimage;

- (id)init {
    if (self = [super init]) {
        playerPositions = [[NSMutableDictionary alloc] init];
        footballSpecialTeamsPositions = [[NSMutableDictionary alloc] init];
        footballOffensePositions = [[NSMutableDictionary alloc] init];
        footballDefensePositions = [[NSMutableDictionary alloc] init];
        logosize = @"";
        hideAds = NO;
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)sportDictionary {
    if ((self = [super init]) && (sportDictionary.count > 0)) {
        playerPositions = [[NSMutableDictionary alloc] init];
        
        self.id = [sportDictionary objectForKey:@"id"];
        sitename = [sportDictionary objectForKey:@"sitename"];
        mascot = [sportDictionary objectForKey:@"mascot"];
        year = [sportDictionary objectForKey:@"year"];
        zip = [sportDictionary objectForKey:@"zip"];
        state = [sportDictionary objectForKey:@"state"];
        city = [sportDictionary objectForKey:@"city"];
        country = [sportDictionary objectForKey:@"country"];
        sport_logo_thumb = [sportDictionary objectForKey:@"sport_logo_thumb"];
        sport_logo_tiny = [sportDictionary objectForKey:@"sport_logo_tiny"];
        banner = [sportDictionary objectForKey:@"banner_url"];
        name = [sportDictionary objectForKey:@"name"];
        season = [sportDictionary objectForKey:@"season"];
        has_stats = [NSNumber numberWithBool:[[sportDictionary objectForKey:@"has_stats"] boolValue]];
        alert_interval = [sportDictionary objectForKey:@"alert_interval"];
        gamelog_interval = [sportDictionary objectForKey:@"gamelog_interval"];
        newsfeed_interval = [sportDictionary objectForKey:@"newsfeed_interval"];
        
        beta = [[sportDictionary objectForKey:@"beta"] boolValue];
        approved = [[sportDictionary objectForKey:@"approved"] boolValue];
        hideAds = [[sportDictionary objectForKey:@"hideads"] boolValue];
        
        review_media = [[sportDictionary objectForKey:@"review_media"] boolValue];
        enable_user_pics = [[sportDictionary objectForKey:@"enable_user_pics"] boolValue];
        enable_user_video = [[sportDictionary objectForKey:@"enable_user_video"] boolValue];
        
        package = [sportDictionary objectForKey:@"package"];
        silverMedia = [[sportDictionary objectForKey:@"silverMedia"] intValue];
        goldMedia = [[sportDictionary objectForKey:@"goldMedia"] intValue];
        platinumMedia = [[sportDictionary objectForKey:@"platinumMedia"] intValue];
        teamcount = [sportDictionary objectForKey:@"teamcount"];
        streamingurl = [sportDictionary objectForKey:@"streamingurl"];
        streamingbucket = [sportDictionary objectForKey:@"streamingbucket"];
        pricingurl = [sportDictionary objectForKey:@"pricingurl"];
        enablelive = [[sportDictionary objectForKey:@"enablelive"] boolValue];
        supportedsports = [sportDictionary objectForKey:@"supportedsports"];
        adurl = [sportDictionary objectForKey:@"adurl"];
        
        if ([name isEqualToString:@"Soccer"]) {
            playerPositions = [self parsePositions:[sportDictionary objectForKey:@"soccer_positions"]];
        } else if ([name isEqualToString:@"Basketball"]) {
            playerPositions = [self parsePositions:[sportDictionary objectForKey:@"basketball_positions"]];
        } else if ([name isEqualToString:@"Football"]) {
            footballOffensePositions = [self parsePositions:[sportDictionary objectForKey:@"football_offense_position"]];
            footballDefensePositions = [self parsePositions:[sportDictionary objectForKey:@"football_defense_position"]];
            footballSpecialTeamsPositions = [self parsePositions:[sportDictionary objectForKey:@"football_specialteams_position"]];
        } else if ([name isEqualToString:@"Lacrosse"]) {
            playerPositions = [self parsePositions:[sportDictionary objectForKey:@"lacrosse_positions"]];
            lacrosse_score_codes = [self parsePositions:[sportDictionary objectForKey:@"lacrosse_score_codes"]];
            lacrosse_shots = [self parsePositions:[sportDictionary objectForKey:@"lacrosse_shots"]];
            lacrosse_periods = [self parsePositions:[sportDictionary objectForKey:@"lacrosse_periods"]];
            lacrosse_technical_fouls = [sportDictionary objectForKey:@"lacrosse_technical_fouls"];
            lacrosse_personal_fouls = [sportDictionary objectForKey:@"lacrosse_personal_fouls"];
        }
        
        return self;
    } else {
        return nil;
    }
}

- (NSMutableDictionary *)parsePositions:(NSArray *)positions {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < positions.count; i++) {
        NSArray *pospair = [positions objectAtIndex:i];
        for (int cnt = 0; cnt < pospair.count; cnt = cnt + 2) {
            [result setObject:[pospair objectAtIndex:cnt + 1] forKey:[pospair objectAtIndex:cnt]];
        }
    }
    
    return result;
}

- (UIImage *)getImage:(NSString *)size {
    UIImage *image;
    
    if ([size isEqualToString:@"tiny"] ) {        
        if ([sport_logo_tiny isEqualToString:@"/sport_logos/tiny/missing.png"]) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if (((sportimage.CIImage == nil) && (sportimage.CGImage == nil)) || (![logosize isEqualToString:@"tiny"])) {
            NSURL * imageURL = [NSURL URLWithString:sport_logo_tiny];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            sportimage = image;
            logosize = size;
        } else
            image = sportimage;
    } else if ([size isEqualToString:@"thumb"]) {        
        if (([sport_logo_thumb isEqualToString:@"/sport_logos/thumb/missing.png"]) || (sport_logo_thumb.length == 0)) {
            image = [UIImage imageNamed:@"photo_not_available.png"];
        } else if (((sportimage.CIImage == nil) && (sportimage.CGImage == nil)) || (![logosize isEqualToString:@"thumb"])) {
            NSURL * imageURL = [NSURL URLWithString:sport_logo_thumb];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            sportimage = image;
            logosize = size;
        } else
            image = sportimage;
    }
    
    return image;
}

@end
