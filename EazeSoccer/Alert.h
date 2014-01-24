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
@property(nonatomic, strong) NSString *football_passing_id;
@property(nonatomic, strong) NSString *football_rushing_id;
@property(nonatomic, strong) NSString *football_receiving_id;
@property(nonatomic, strong) NSString *football_defense_id;
@property(nonatomic, strong) NSString *football_place_kicker_id;
@property(nonatomic, strong) NSString *football_punter_id;
@property(nonatomic, strong) NSString *football_returner_id;
@property(nonatomic, strong) NSString *football_kicker_id;

@property(nonatomic, strong) NSString *basketball_stat_id;
@property(nonatomic, strong) NSString *soccer_id;

@property(nonatomic, strong) NSString *httperror;

- (id)initWithDirectory:(NSDictionary *)alertDirectory;
- (id)initDeleteAlert;

@end
