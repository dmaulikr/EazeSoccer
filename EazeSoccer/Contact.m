//
//  Contact.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/7/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Contact.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"

@implementation Contact

@synthesize title;
@synthesize name;
@synthesize mobile;
@synthesize fax;
@synthesize phone;
@synthesize email;
@synthesize contactid;

@synthesize httperror;

- (id)initWithDirectory:(NSDictionary *)contactDirectory {
    if ((self = [super init]) && (contactDirectory.count > 0)) {
        contactid = [contactDirectory objectForKey:@"id"];
        title = [contactDirectory objectForKey:@"title"];
        name = [contactDirectory objectForKey:@"name"];
        phone = [contactDirectory objectForKey:@"phone"];
        mobile = [contactDirectory objectForKey:@"mobile"];
        fax = [contactDirectory objectForKey:@"fax"];
        email = [contactDirectory objectForKey:@"email"];
        
        return self;
    } else {
        return nil;
    }
}

- (id)initDeleteContact {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getContact:contactid Token:currentSettings.user.authtoken]];
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
    int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
    NSDictionary *confirmDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        self = nil;
    } else {
        httperror = [confirmDict objectForKey:@"error"];
    }
    
    return self;
    
}

@end
