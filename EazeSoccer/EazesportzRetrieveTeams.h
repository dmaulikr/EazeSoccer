//
//  EazesportzRetrieveTeams.h
//  EazeSportz
//
//  Created by Gil on 1/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EazesportzRetrieveTeams : NSObject

@property(nonatomic, strong) NSMutableArray *teams;

- (void)retrieveTeams:(NSString *)sportid Token:(NSString *)authtoken;

@end
