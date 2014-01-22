//
//  FootballStatTotals.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FootballStatTotals : NSObject

@property(nonatomic, strong) NSNumber *totalfirstdowns;
@property(nonatomic, strong) NSNumber *totalyards;
@property(nonatomic, strong) NSNumber *passingtotalyards;
@property(nonatomic, strong) NSNumber *rushingtotalyards;
@property(nonatomic, strong) NSNumber *penalties;
@property(nonatomic, strong) NSNumber *penaltyyards;
@property(nonatomic, strong) NSNumber *turnovers;

- (id)initWithDictionary:(NSDictionary *)footballStatTotals;

@end
