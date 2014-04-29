//
//  EazesportzRetrieveSponsors.h
//  EazeSportz
//
//  Created by Gil on 1/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sponsor.h"
#import "Athlete.h"

@interface EazesportzRetrieveSponsors : NSObject

@property (nonatomic, strong) NSMutableArray *sponsors;

- (void)retrieveSponsors:(NSString *)sportid Token:(NSString *)authtoken;

- (Sponsor *)getSponsorAd;
- (Sponsor *)getPlayerAd:(Athlete *)ahtlete;

@end
