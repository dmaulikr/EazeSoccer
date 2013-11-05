//
//  Newsfeed.h
//  smpwlions
//
//  Created by Gil on 3/10/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Newsfeed : NSObject

@property(nonatomic, strong) NSString *newsid;
@property(nonatomic, strong) NSString *news;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *athlete;
@property(nonatomic, strong) NSString *coach;
@property(nonatomic, strong) NSString *team;
@property(nonatomic, strong) NSString *game;
@property(nonatomic, strong) NSString *external_url;
@property(nonatomic, strong) NSString *updated_at;

- (id)initWithDirectory:(NSDictionary *)newsDict;

@end
