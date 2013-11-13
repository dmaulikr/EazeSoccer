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

@implementation Team {
    NSString *logosize;
}

@synthesize teamid;
@synthesize mascot;
@synthesize title;
@synthesize team_name;
@synthesize team_logo;
@synthesize tiny_logo;

@synthesize teamimage;

- (id)init {
    if (self = [super init]) {
        logosize = @"";
        return self;
    } else
        return nil;
}

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
        
        if ((NSNull *)[teamDictionary objectForKey:@"tiny_logo"] != [NSNull null])
            tiny_logo = [teamDictionary objectForKey:@"tiny_logo"];
        else
            tiny_logo = @"";
        
        return self;
    } else {
        return nil;
    }
}

- (UIImage *)getImage:(NSString *)size {
    UIImage *image;
    
    if ([size isEqualToString:@"tiny"]) {
        
        if (([self.tiny_logo isEqualToString:@"/team_logos/tiny/missing.png"]) || (self.team_logo.length == 0)) {
            image = [currentSettings.sport getImage:@"tiny"];
        } else if (((self.teamimage.CIImage == nil) && (self.teamimage.CGImage == nil)) || (![logosize isEqualToString:@"tiny"])) {
            NSURL * imageURL = [NSURL URLWithString:self.tiny_logo];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            self.teamimage = image;
            logosize = size;
        } else
            image = self.teamimage;
        
    } else if ([size isEqualToString:@"thumb"]) {
        
        if (([self.team_logo isEqualToString:@"/team_logos/thumb/missing.png"]) || (self.team_logo.length == 0)) {
            image = [currentSettings.sport getImage:@"thumb"];
        } else if (((self.teamimage.CIImage == nil) && (self.teamimage.CGImage == nil)) || (![logosize isEqualToString:@"thumb"])) {
            NSURL * imageURL = [NSURL URLWithString:self.team_logo];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            self.teamimage = image;
            logosize = size;
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
