//
//  Sportadinv.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sport.h"
#import "User.h"

@interface Sportadinv : NSObject

@property (nonatomic, strong) NSString *sportadinvid;
@property (nonatomic, strong) NSString *sportid;
@property (nonatomic, strong) NSString *adlevelname;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) BOOL forsale;
@property (nonatomic, strong) NSDate *expiration;

@property (nonatomic, strong) NSString *httperror;

- (id)initWithDirectory:(NSDictionary *)sponsorDictionary;
- (id)initDelete;

- (BOOL)deleteSportadinv:(User *)user;

- (BOOL)saveSportadinv:(Sport *)sport User:(User *)user ;

- (NSString *)adnameprice;

@end
