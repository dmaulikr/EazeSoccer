//
//  EazesportzRetrieveNews.h
//  EazeSportz
//
//  Created by Gil on 3/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sport.h"
#import "Team.h"
#import "User.h"

@interface EazesportzRetrieveNews : NSObject

@property(nonatomic, strong) NSMutableArray *news;

- (void)retrieveNews:(Sport *)sport Team:(Team *)team User:(User *)user;

- (NSMutableArray *)retrieveNewsSynchronous:(Sport *)sport Team:(Team *)team User:(User *)user;

@end
