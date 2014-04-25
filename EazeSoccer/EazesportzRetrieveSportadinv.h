//
//  EazesportzRetrieveSportadinv.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sportadinv.h"
#import "Sport.h"
#import "User.h"

@interface EazesportzRetrieveSportadinv : NSObject

@property (nonatomic, strong) NSMutableArray *inventorylist;

- (void)retrieveSportadinv:(Sport *)sport User:(User *)user;

@end
