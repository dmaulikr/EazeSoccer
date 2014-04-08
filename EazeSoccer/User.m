//
//  User.m
//  sportzSoftwareHome
//
//  Created by Gil on 2/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username;
@synthesize authtoken;
@synthesize email;
@synthesize userid;
@synthesize admin;
@synthesize userUrl;
@synthesize tiny;
@synthesize userthumb;
@synthesize bio_alert;
@synthesize blog_alert;
@synthesize media_alert;
@synthesize stat_alert;
@synthesize score_alert;
@synthesize teammanagerid;
@synthesize isactive;
@synthesize avatarprocessing;
@synthesize tier;
@synthesize default_site;
@synthesize adminsite;

@synthesize awskeyid;
@synthesize awssecretkey;

@synthesize tinyimage;
@synthesize thumbimage;

- (BOOL)isBasic {
    if ([tier isEqualToString:@"Basic"])
        return YES;
    else
        return NO;
}

- (id)init {
    if (self = [super init]) {
        email = nil;
        authtoken = nil;
        userid = nil;
        username = nil;
        return  self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)userDictionary {
    if ((self = [super init]) && (userDictionary.count > 0)) {
        email = [userDictionary objectForKey:@"email"];
        userid = [userDictionary objectForKey:@"id"];
        username = [userDictionary objectForKey:@"name"];
        avatarprocessing = [[userDictionary objectForKey:@"avatarprocessing"] boolValue];
        
        if ((NSNull *)[userDictionary objectForKey:@"avatarthumburl"] != [NSNull null])
            userthumb = [userDictionary objectForKey:@"avatarthumburl"];
        else
            userthumb = @"";
        
        if ((NSNull *)[userDictionary objectForKey:@"avatartinyurl"] != [NSNull null])
            tiny = [userDictionary objectForKey:@"avatartinyurl"];
        else
            tiny = @"";
        
        [self loadImages];
        
        isactive = [NSNumber numberWithInteger:[[userDictionary objectForKey:@"is_active"] integerValue]];
        bio_alert = [NSNumber numberWithInteger:[[userDictionary objectForKey:@"bio_alert"] integerValue]];
        blog_alert = [NSNumber numberWithInteger:[[userDictionary objectForKey:@"blog_alert"] integerValue]];
        media_alert = [NSNumber numberWithInteger:[[userDictionary objectForKey:@"media_alert"] integerValue]];
        stat_alert = [NSNumber numberWithInteger:[[userDictionary objectForKey:@"stat_alert"] integerValue]];
        score_alert = [NSNumber numberWithInteger:[[userDictionary objectForKey:@"score_alert"] integerValue]];
        admin = [[userDictionary objectForKey:@"admin"] boolValue];
        awssecretkey = [userDictionary objectForKey:@"awskey"];
        awskeyid = [userDictionary objectForKey:@"awskeyid"];
        tier = [userDictionary objectForKey:@"tier"];
        authtoken = [userDictionary objectForKey:@"authentication_token"];
        
        if ((NSNull *)[userDictionary objectForKey:@"default_site"] != [NSNull null])
            default_site = [userDictionary objectForKey:@"default_site"];
        else
            default_site = @"";
        
        adminsite = [userDictionary objectForKey:@"adminsite"];
        
        return self;
    } else {
        return nil;
    }
}

- (void)loadImages {
    if (![tiny isEqualToString:@"/avatar/tiny/missing.png"]) {
        tinyimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:tiny]];
            tinyimage = [UIImage imageWithData:image];
        });
    } else {
        tinyimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    
    if (![userthumb isEqualToString:@"/avatar/thumb/missing.png"]) {
        thumbimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:userthumb]];
            thumbimage = [UIImage imageWithData:image];
        });
    } else {
        thumbimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
}

@end
