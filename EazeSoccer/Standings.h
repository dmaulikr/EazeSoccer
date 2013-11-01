//
//  Standings.h
//  Basketball Console
//
//  Created by Gil on 10/22/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Standings : NSObject

@property(nonatomic, strong) NSString *teamname;
@property(nonatomic, strong) NSString *mascot;
@property(nonatomic, strong) NSNumber *leaguewins;
@property(nonatomic, strong) NSNumber *leaguelosses;
@property(nonatomic, strong) NSNumber *nonleaguewins;
@property(nonatomic, strong) NSNumber *nonleaguelosses;
@property(nonatomic, strong) NSString *gameschedule_id;
@property(nonatomic, strong) NSString *sportid;
@property(nonatomic, strong) NSString *oppimageurl;
@property(nonatomic, strong) NSString *teamid;

@end
