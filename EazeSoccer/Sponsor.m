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
@synthesize tiny;
@synthesize thumb;
@synthesize medium;
@synthesize large;
@synthesize sponsorlevel;
@synthesize teamonly;
@synthesize teamid;
@synthesize country;

@synthesize user_id;
@synthesize athlete_id;
@synthesize sportadinv_id;

@synthesize ios_client_ad;

@synthesize adprice;
@synthesize forsale;
@synthesize adsponsorlevel;
@synthesize playerad;

@synthesize tinyimage;
@synthesize thumbimage;
@synthesize mediumimage;
@synthesize largeimage;
@synthesize sponsorpic_updated_at;

@synthesize portraitbanner;
@synthesize landscapebanner;
@synthesize portraitBannerImage;
@synthesize landscapeBannerImage;
@synthesize adbanner_updated_at;

@synthesize httperror;

- (id)init {
    if (self = [super init]) {
        athlete_id = @"";
        user_id = @"";
        sponsorid = @"";
        
        return self;
    } else
        return nil;
}

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
        adprice = [[sponsorDictionary objectForKey:@"price"] floatValue];
        forsale = [[sponsorDictionary objectForKey:@"forsale"] boolValue];
        adsponsorlevel = [sponsorDictionary objectForKey:@"adsponsorlevel"];
        playerad = [[sponsorDictionary objectForKey:@"playerad"] boolValue];
        
        country = [sponsorDictionary objectForKey:@"country"];
        
        teamid = [sponsorDictionary objectForKey:@"teamid"];
        sportadinv_id = [sponsorDictionary objectForKey:@"sportadinv_id"];
        
        ios_client_ad = [sponsorDictionary objectForKey:@"ios_client_ad"];
        
        user_id = [sponsorDictionary objectForKey:@"user_id"];
        athlete_id = [sponsorDictionary objectForKey:@"athlete_id"];        
        
        large = [sponsorDictionary objectForKey:@"large"];
        medium = [sponsorDictionary objectForKey:@"medium"];
        thumb = [sponsorDictionary objectForKey:@"thumb"];
        tiny = [sponsorDictionary objectForKey:@"tiny"];
        portraitbanner = [sponsorDictionary objectForKey:@"portraitbanner"];
        landscapebanner = [sponsorDictionary objectForKey:@"landscapebanner"];
        
        sponsorpic_updated_at = [sponsorDictionary objectForKey:@"sponsorpic_updated_at"];
        adbanner_updated_at = [sponsorDictionary objectForKey:@"adbanner_updated_at"];
        
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
    
    if (sponsorid.length > 0) {
        url = [NSURL URLWithString:[serverUrlString stringByAppendingFormat:@"%@%@%@%@%@%@", @"/sports/", currentSettings.sport.id, @"/sponsors/",
                                    self.sponsorid, @".json?&auth_token=", currentSettings.user.authtoken]];
    } else {
        url = [NSURL URLWithString:[serverUrlString stringByAppendingFormat:@"%@%@%@%@", @"/sports/", currentSettings.sport.id,
                                    @"/sponsors.json?auth_token=", currentSettings.user.authtoken]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableDictionary *sponsordict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:currentSettings.team.teamid, @"team_id",
                                        currentSettings.user.userid, @"user_id", athlete_id, @"athlete_id", name, @"name",
                                        [addrnum stringValue], @"addrnum", street, @"street", city, @"city", state, @"state", zip, @"zip",
                                        phone, @"phone", fax, @"fax", mobile, @"mobile", email, @"contactemail", adurl, @"adurl", sponsorlevel,
                                        @"sponsorlevel", country, @"country", nil];
    
    if (sportadinv_id.length > 0)
        [sponsordict setValue:sportadinv_id forKeyPath:@"sportadvin_id"];
    else if (ios_client_ad.length > 0)
        [sponsordict setValue:ios_client_ad forKeyPath:@"ios_client_ad_id"];
    
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
    
    if (sponsorid.length == 0) {
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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorSavedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
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
        
        [currentSettings.sponsors retrieveSponsors:currentSettings.sport.id Token:currentSettings.user.authtoken];
    } else {
        httperror = [serverData objectForKey:@"error"];
        
        if (deleteSponsor)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorDeletedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:httperror, @"Result", nil]];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorSavedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:httperror, @"Result", nil]];        
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


- (void)loadImages {
    if (tiny.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:tiny]];
            tinyimage = [UIImage imageWithData:image];
        });
    } else {
        tinyimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    
    if (thumb.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumb]];
            thumbimage = [UIImage imageWithData:image];
        });
    } else {
        thumbimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }

    if (medium.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:medium]];
            mediumimage = [UIImage imageWithData:image];
        });
    } else {
        mediumimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    
    if (large.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:large]];
            largeimage = [UIImage imageWithData:image];
        });
    } else {
        largeimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }

    if (portraitbanner.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:portraitbanner]];
            portraitBannerImage = [UIImage imageWithData:image];
        });
    } else {
        portraitBannerImage = nil;
    }
    
    if (landscapebanner.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:landscapebanner]];
            landscapeBannerImage = [UIImage imageWithData:image];
        });
    } else {
        landscapeBannerImage = nil;
    }
}

- (UIImage *)getPortraitBanner {
    if (landscapeBannerImage != nil)
        return landscapeBannerImage;
    else if (portraitBannerImage != nil)
        return portraitBannerImage;
    else
        return nil;
}

- (UIImage *)bannerImage {
    
    if (self.tiny.length == 0) {
/*
        if ([currentSettings.sport.name isEqualToString:@"Football"]) {
            return [UIImage imageNamed:@"football-field.png"];
        } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
            return [UIImage imageNamed:@"bballongymfloor.png"];
        } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
            return [UIImage imageNamed:@"Soccerbanner.png"];
        } else
            return  nil; 
 */
        return [currentSettings.team getImage:@"tiny"];
    } else {
        return self.tinyimage;
    }
}

@end
