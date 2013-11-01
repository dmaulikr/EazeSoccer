//
//  Alert.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject

@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSString *created_at;
@property(nonatomic, strong) NSString *alertid;
@property(nonatomic, strong) NSString *user;
@property(nonatomic, strong) NSString *athlete;
@property(nonatomic, strong) NSString *photo;
@property(nonatomic, strong) NSString *videoclip;
@property(nonatomic, strong) NSString *blog;
@property(nonatomic, strong) NSString *sport;
@property(nonatomic, strong) NSString *stat;
@property(nonatomic, strong) NSString *stattype;

@end
