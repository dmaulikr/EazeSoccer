//
//  Sport.m
//  sportzSoftwareHome
//
//  Created by Gil on 2/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Sport.h"

@implementation Sport

@synthesize id;
@synthesize sitename;
@synthesize mascot;
@synthesize year;
@synthesize zip;
@synthesize banner;
@synthesize season;
@synthesize name;
@synthesize sport_logo;
@synthesize sport_logo_medium;
@synthesize sport_logo_thumb;
@synthesize sport_logo_tiny;
@synthesize siteid;
@synthesize has_stats;
@synthesize alert_interval;
@synthesize gamelog_interval;
@synthesize newsfeed_interval;
@synthesize beta;
@synthesize approved;

@synthesize playerPositions;

@synthesize sportimage;

- (id)init {
    if (self = [super init]) {
        playerPositions = [[NSMutableDictionary alloc] init];
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
        sport_logo = [sportDictionary objectForKey:@"sport_logo"];
        sport_logo_thumb = [sportDictionary objectForKey:@"sport_logo_thumb"];
        sport_logo_medium = [sportDictionary objectForKey:@"sport_logo_medium"];
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
        
        if ([name isEqualToString:@"Soccer"]) {
            playerPositions = [self parsePositions:[sportDictionary objectForKey:@"soccer_positions"]];
        } else if ([name isEqualToString:@"Basketball"]) {
            playerPositions = [self parsePositions:[sportDictionary objectForKey:@"basketball_positions"]];
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
        } else if ((sportimage.CIImage == nil) && (sportimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:sport_logo_tiny];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            sportimage = image;
        } else
            image = sportimage;
    } else if ([size isEqualToString:@"thumb"]) {        
        if (([sport_logo_thumb isEqualToString:@"/sport_logos/thumb/missing.png"]) || (sport_logo_thumb.length == 0)) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if ((sportimage.CIImage == nil) && (sportimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:sport_logo_thumb];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            sportimage = image;
        } else
            image = sportimage;
    }
    
    return image;
}

@end
