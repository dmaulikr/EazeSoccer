//
//  EazesportzRetrieveSport.h
//  EazeSportz
//
//  Created by Gil on 1/9/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sport.h"

@interface EazesportzRetrieveSport : NSObject

- (void)retrieveSport:(NSString *)sport Token:(NSString *)authtoken;
- (Sport *)retrieveSportSynchronous:(NSString *)sport Token:(NSString *)authtoken ;

@end
