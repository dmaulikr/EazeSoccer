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
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
    int adcount, adindex;
}

@synthesize sponsors;

- (void)retrieveSponsors:(NSString *)sportid Token:(NSString *)authtoken {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (authtoken)
        url = [NSURL URLWithString:[sportzServerInit getSponsors:currentSettings.user.authtoken]];
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
        
        if (sponsors.count > 0)
            currentSettings.sport.hideAds = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorListChangedNotification" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SponsorListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retreving Sponsors", @"Result", nil]];
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
    Sponsor *thead = nil;
    
    switch (adcount) {
        case 0:
            thead = [self findSponsorAd:@"Platinum"];
            break;
            
        case 1:
            thead = [self findSponsorAd:@"Gold"];
            break;
            
        case 2:
            thead = [self findSponsorAd:@"Platinum"];
            break;
            
        case 3:
            thead = [self findSponsorAd:@"Gold"];
            break;
            
        case 4:
            thead = [self findSponsorAd:@"Platinum"];
            break;
            
        default:
            thead = [self findSponsorAd:@"Silver"];
            break;
    }
    
    adcount++;
    
    if (adcount == 5)
        adcount = 0;
    
    if (thead == nil)
        thead = [self findSponsorAd:@"Platinum"];
    
    return thead;
}

- (Sponsor *)findSponsorAd:(NSString *)level {
    Sponsor *foundad = nil;
    int i;
    
    for (i = adindex; i < sponsors.count; i++) {
        if ([[[sponsors objectAtIndex:i] sponsorlevel] isEqualToString:level]) {
            foundad = [sponsors objectAtIndex:i];
            break;
        }
    }
    
    adindex = i;
    
    if (adindex == sponsors.count)
        adindex = 0;
    
    return foundad;
}

@end
