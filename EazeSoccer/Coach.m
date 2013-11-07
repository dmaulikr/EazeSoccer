//
//  m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/2/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Coach.h"

#import "EazesportzAppDelegate.h"

@implementation Coach

@synthesize lastname;
@synthesize firstname;
@synthesize middlename;
@synthesize years;
@synthesize speciality;
@synthesize bio;
@synthesize coachid;
@synthesize fullname;
@synthesize largepic;
@synthesize thumb;
@synthesize tiny;
@synthesize teamid;
@synthesize teamname;
@synthesize processing;

@synthesize thumbimage;
@synthesize tinyimage;

@synthesize httperror;

- (id)initWithDictionary:(NSDictionary *)coachDictionary {
    if ((self = [super init]) && (coachDictionary.count > 0)) {
        coachid = [coachDictionary objectForKey:@"id"];
        bio = [coachDictionary objectForKey:@"bio"];
        fullname = [coachDictionary objectForKey:@"full_name"];
        firstname = [coachDictionary objectForKey:@"firstname"];
        middlename = [coachDictionary objectForKey:@"middlename"];
        lastname = [coachDictionary objectForKey:@"lastname"];
        speciality = [coachDictionary objectForKey:@"speciality"];
        years = [coachDictionary objectForKey:@"years_on_staff"];
        teamid = [coachDictionary objectForKey:@"team_id"];
        thumb = [coachDictionary objectForKey:@"thumb"];
        tiny = [coachDictionary objectForKey:@"tiny"];
        largepic = [coachDictionary objectForKey:@"largepic"];
        processing = [[coachDictionary objectForKey:@"processing"] boolValue];
        return self;
    } else {
        return nil;
    }
}

- (id)initDeleteCoach {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/coaches/", coachid, @".json?auth_token=",
                                       currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] init];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *coachdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if ([httpResponse statusCode] == 200) {
        self = nil;
        return self;
    } else {
        httperror = [coachdata objectForKey:@"error"];
        return  self;
    }
}

- (UIImage *)getImage:(NSString *)size {
    UIImage *image;
    
    if ([size isEqualToString:@"tiny"]) {
        
        if ([self.tiny isEqualToString:@"/coachpics/tiny/missing.png"]) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if (self.processing) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
        } else if ((self.tinyimage.CIImage == nil) && (self.tinyimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:self.tiny];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            self.tinyimage = image;
        } else
            image = self.tinyimage;
        
    } else if ([size isEqualToString:@"thumb"]) {
        
        if ([self.thumb isEqualToString:@"/coachpics/thumb/missing.png"]) {
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
        
    }
    return image;
}

@end
