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

@synthesize awskeyid;
@synthesize awssecretkey;

- (BOOL)isBasic {
    if ([tier isEqualToString:@"Basic"])
        return YES;
    else
        return NO;
}

@end
