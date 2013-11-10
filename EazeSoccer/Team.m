//
//  Team.m
//  smpwlions
//
//  Created by Gil on 3/9/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Team.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"

@implementation Team

@synthesize teamid;
@synthesize mascot;
@synthesize title;
@synthesize team_name;
@synthesize team_logo;

@synthesize teamimage;

- (id)initWithDictionary:(NSDictionary *)teamDictionary {
    if ((self = [super init]) && (teamDictionary.count > 0)) {
        team_name = [teamDictionary objectForKey:@"team_name"];
        mascot = [teamDictionary objectForKey:@"mascot"];
        teamid = [teamDictionary objectForKey:@"id"];
        title = [teamDictionary objectForKey:@"title"];
        
        if ((NSNull *)[teamDictionary objectForKey:@"team_logo"] != [NSNull null])
            team_logo = [teamDictionary objectForKey:@"team_logo"];
        else
            team_logo = @"";
        
        return self;
    } else {
        return nil;
    }
}

- (UIImage *)getImage:(NSString *)size {
    UIImage *image;
    
    if (([size isEqualToString:@"tiny"]) || ([size isEqualToString:@"thumb"])) {
        
        if (([self.team_logo isEqualToString:@"/team_logos/thumb/missing.png"]) || (self.team_logo.length == 0)) {
            image = [currentSettings.sport getImage:@"thumb"];
        } else if ((self.teamimage.CIImage == nil) && (self.teamimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:self.team_logo];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            self.teamimage = image;
        } else
            image = self.teamimage;
        
    }
    
    return image;
}

- (BOOL)hasImage {
    if (([self.team_logo isEqualToString:@"/team_logos/thumb/missing.png"]) || (self.team_logo.length == 0)) {
        return NO;
    } else {
        return YES;
    }
}

@end
