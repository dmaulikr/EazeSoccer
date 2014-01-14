//
//  Sponsor.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/10/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Sponsor.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzRetrieveSponsors.h"

@implementation Sponsor {
    NSMutableURLRequest *originalRequest;
    int responseStatusCode;
    NSMutableData *theData;
    
    BOOL deleteSponsor;
}

@synthesize sponsorid;
@synthesize addrnum;
@synthesize name;
@synthesize street;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize phone;
@synthesize mobile;
@synthesize fax;
@synthesize adurl;
@synthesize email;
@synthesize thumb;
@synthesize medium;
@synthesize large;
@synthesize sponsorlevel;
@synthesize teamonly;
@synthesize teamid;

@synthesize httperror;

- (id)initWithDirectory:(NSDictionary *)sponsorDictionary {
    if ((self = [super init]) && (sponsorDictionary.count > 0)) {
        
        sponsorid = [sponsorDictionary objectForKey:@"id"];
        name = [sponsorDictionary objectForKey:@"name"];
        addrnum = [sponsorDictionary objectForKey:@"addrnum"];
        street = [sponsorDictionary objectForKey:@"street"];
        city = [sponsorDictionary objectForKey:@"city"];
        state = [sponsorDictionary objectForKey:@"state"];
        zip = [sponsorDictionary objectForKey:@"zip"];
        phone = [sponsorDictionary objectForKey:@"phone"];
        mobile = [sponsorDictionary objectForKey:@"mobile"];
        fax = [sponsorDictionary objectForKey:@"fax"];
        adurl = [sponsorDictionary objectForKey:@"adurl"];
        email = [sponsorDictionary objectForKey:@"contactemail"];
        sponsorlevel = [sponsorDictionary objectForKey:@"sponsorlevel"];
        teamid = [sponsorDictionary objectForKey:@"teamid"];

        if ((NSNull *)[sponsorDictionary objectForKey:@"large"] != [NSNull null])
            large = [sponsorDictionary objectForKey:@"large"];
        else
            large = @"";
        
        if ((NSNull *)[sponsorDictionary objectForKey:@"medium"] != [NSNull null])
            medium = [sponsorDictionary objectForKey:@"medium"];
        else
            medium = @"";

        if ((NSNull *)[sponsorDictionary objectForKey:@"thumb"] != [NSNull null])
            thumb = [sponsorDictionary objectForKey:@"thumb"];
        else
            thumb = @"";
        
        return self;
    } else {
        return nil;
    }
    
}

- (void)saveSponsor {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *serverUrlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    NSURL *url;
    
    if (self.sponsorid) {
        url = [NSURL URLWithString:[serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/sponsors/",
                                    self.sponsorid, @".json?&auth_token=", currentSettings.user.authtoken]];
    } else {
        url = [NSURL URLWithString:[serverUrlString stringByAppendingFormat:@"%@%@%@%@", @"/sports/", currentSettings.sport.id,
                                    @"/sponsors.json?auth_token=", currentSettings.user.authtoken]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableDictionary *sponsordict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name, @"name", [addrnum stringValue], @"addrnum",
                                        street, @"street", zip, @"zip", phone, @"phone", fax, @"fax", mobile, @"mobile",
                                        email, @"contactemail", adurl, @"adurl", sponsorlevel, @"sponsorlevel", currentSettings.team.teamid, @"team_id", nil];

    NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
    [jsonDict setValue:sponsordict forKey:@"sponsor"];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (!self.sponsorid) {
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:@"PUT"];
    }
    
    [request setHTTPBody:jsonData];
    
    originalRequest = request;
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download cound not complete - please make sure you're connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    
    if (responseStatusCode == 200) {
        
        [[[EazesportzRetrieveSponsors alloc] init] retrieveSponsors:currentSettings.sport.id Token:currentSettings.user.authtoken];
        
        if (deleteSponsor) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorDeletedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
            [self initDelete];
        } else {
            
            if (self.sponsorid.length == 0)
                self.sponsorid = [[serverData objectForKey:@"sponsor"] objectForKey:@"_id"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorSavedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
        }
    } else {
        if (deleteSponsor)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorDeletedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:httperror, @"Result", nil]];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorSavedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:httperror, @"Result", nil]];
        
        httperror = [serverData objectForKey:@"error"];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if (redirectResponse) {
        NSMutableURLRequest *newrequest = [originalRequest mutableCopy];
        [newrequest setURL:[request URL]];
        return  newrequest;
    } else {
        NSMutableURLRequest *newRequest = [originalRequest mutableCopy];
        
        //        [newRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", @"http://powerful-everglades-2345.herokuapp.com",
        //                                                 @"/sports/", currentSettings.sport.id, @"/teams/",
        //                                                 currentSettings.team.teamid, @"/gameschedules/", self.id, @".json?auth_token=", currentSettings.user.authtoken]]];
        return request;
    }
    
}

- (void)deleteSponsor {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/sponsors/", sponsorid, @".json?auth_token=", currentSettings.user.authtoken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    NSURLResponse* response;
    //    NSError *error = nil;
    NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    
    deleteSponsor = YES;
    originalRequest = request;
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (id)initDelete {
    self = nil;
    return self;
}

@end
