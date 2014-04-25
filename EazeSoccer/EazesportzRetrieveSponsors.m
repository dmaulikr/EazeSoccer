//
//  EazesportzRetrieveSponsors.m
//  EazeSportz
//
//  Created by Gil on 1/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveSponsors.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"

@implementation EazesportzRetrieveSponsors {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableArray *pricearray, *levelsarray, *playerads;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
    long adcount, adindex, adlevel;
}

@synthesize sponsors;

- (id)init {
    if (self = [super init]) {
        adindex = adlevel = 0;
        pricearray = [[NSMutableArray alloc] init];
        return self;
    } else
        return nil;
}

- (void)retrieveSponsors:(NSString *)sportid Token:(NSString *)authtoken {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (authtoken)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], @"/sports/",
                                    sportid, @"/sponsors.json?auth_token=", authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], @"/sports/",
                                    sportid, @"/sponsors.json"]];
    
    originalRequest = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:originalRequest delegate:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        if (sponsors) {
            NSMutableArray *sponsorlist = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < serverData.count; i++) {
                Sponsor *sponsor = [[Sponsor alloc] initWithDirectory:[serverData objectAtIndex:i]];
                [self replaceSponsorImages:sponsor];
                [sponsorlist addObject:sponsor];
            }
            
            [self cleanUpSponsorImageList:sponsorlist];
        } else {
            sponsors = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < serverData.count; i++) {
                Sponsor *sponsor = [[Sponsor alloc] initWithDirectory:[serverData objectAtIndex:i]];
                [sponsor loadImages];
                [sponsors addObject:sponsor];
            }
        }
        
        if (sponsors.count > 0) {
            currentSettings.sport.hideAds = YES;
            pricearray = [[NSMutableArray alloc] init];
            playerads = [[NSMutableArray alloc] init];
            
            NSMutableArray *adlist = [[NSMutableArray alloc] init];
            float oldprice = 0.0;
            
            for (int i = 0; i < sponsors.count; i++) {
                
                if (oldprice > [[sponsors objectAtIndex:i] price]) {
                    if ([[sponsors objectAtIndex:i] playerad]) {
                        [playerads addObject:[sponsors objectAtIndex:i]];
                    } else if (adlist.count > 0) {
                        [pricearray addObject:adlist];
                    }
                    adlist = [[NSMutableArray alloc] init];
                }
                
                [adlist addObject:[sponsors objectAtIndex:i]];
                oldprice = [[sponsors objectAtIndex:i] price];
            }
            
            if (adlist.count > 0)
                [pricearray addObject:adlist];
            
            [self resetLevelsArray];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorListChangedNotification" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retreving Sponsors", @"Result", nil]];
    }
}

- (void)resetLevelsArray {
    adlevel = pricearray.count - 1;
    adindex = 0;
    
    if (pricearray.count == 1) {
        levelsarray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < pricearray.count; i++)
            [levelsarray addObject:[NSNumber numberWithInt:0]];
    } else {
        levelsarray = nil;
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if (redirectResponse) {
        NSMutableURLRequest *newrequest = [originalRequest mutableCopy];
        [newrequest setURL:[request URL]];
        return  newrequest;
    } else {
        return request;
    }
}

- (void)replaceSponsorImages:(Sponsor *)sponsor {
    BOOL found = NO;
    
    for (int i = 0; i < sponsors.count; i++) {
        
        if ([[[sponsors objectAtIndex:i] sponsorid] isEqualToString:sponsor.sponsorid]) {
            found = YES;
            break;
        }
    }
    
    if (!found) {
        [sponsor loadImages];
        [sponsors addObject:sponsor];
    }
}

- (void)cleanUpSponsorImageList:(NSMutableArray *)sponsorlist {
    
    for (int i = 0; i < sponsors.count; i++) {
        BOOL found = NO;
        
        for (int cnt = 0; cnt < sponsorlist.count; cnt++) {
            if ([[[sponsors objectAtIndex:cnt] sponsorid] isEqualToString:[[sponsors objectAtIndex:i] sponsorid] ]) {
                found = YES;
                break;
            }
        }
        
        if (!found) {
            [sponsors removeObjectAtIndex:i];
        }
    }
}

- (Sponsor *)getSponsorAd {
/*
    for (int i = 0; i < pricearray.count; i++) {
        if ([[levelsarray objectAtIndex:i] intValue] == [[pricearray objectAtIndex:i] count]) {
            [self resetLevelsArray];
            [self getSponsorAd];
        } else {
            
        }
            
    }
    
    if (levelsarray) {
        if ((adlevel == 0) && (adindex == [[levelsarray objectAtIndex:adlevel] intValue])) {
            [self resetLevelsArray];
            [self getSponsorAd];
        } else if (adindex >= [[levelsarray objectAtIndex:adlevel] intValue]) {
            [self getSponsorAd];
            adlevel--;
        } else {
            int numadsdisplayed = [[levelsarray objectAtIndex:adlevel] intValue];
            numadsdisplayed++;
            [levelsarray replaceObjectAtIndex:adlevel withObject:[NSNumber numberWithInt:numadsdisplayed]];
            NSUInteger randomIndex = arc4random() % [[pricearray objectAtIndex:adlevel] count];
            Sponsor *thead = [[pricearray objectAtIndex:adlevel] objectAtIndex:randomIndex];
            adlevel--;
            adindex++;
            
            return thead;
        }
    } else if (pricearray.count > 0) {
        NSUInteger randomIndex = arc4random() % [[pricearray objectAtIndex:0] count];
        return [[pricearray objectAtIndex:adlevel] objectAtIndex:randomIndex];
    }
    
    return nil;
 */
    if (sponsors.count > 0) {
        NSUInteger randomIndex = arc4random() % sponsors.count;
        return [sponsors objectAtIndex:randomIndex];
    } else
        return nil;
}

@end
