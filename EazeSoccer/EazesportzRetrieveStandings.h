//
//  EazesportzRetrieveStandings.h
//  EazeSportz
//
//  Created by Gil on 1/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EazesportzRetrieveStandings : NSObject

@property(nonatomic,strong) NSMutableArray *standings;

- (void)retrieveStandings:(NSString *)sportid Token:(NSString *)authtoken;

@end
