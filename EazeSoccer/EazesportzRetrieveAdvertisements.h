//
//  EazesportzRetieveAdvertisements.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sport.h"

@interface EazesportzRetrieveAdvertisements : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *advertisements;

- (void)retrieveUserAds:(Sport *)sport UserId:(NSString *)userid;

@end
