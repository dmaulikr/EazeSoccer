//
//  Sportadinv.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sportadinv : NSObject

@property (nonatomic, strong) NSString *sportadinvid;
@property (nonatomic, strong) NSString *sportid;
@property (nonatomic, strong) NSString *adlevelname;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) BOOL forsale;
@property (nonatomic, strong) NSDate *expiration;

- (id)initWithDirectory:(NSDictionary *)sponsorDictionary;

@end
