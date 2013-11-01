//
//  Blog.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/22/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Blog : NSObject

@property(nonatomic, strong) NSString *blogtitle;
@property(nonatomic, strong) NSString *entry;
@property(nonatomic, strong) NSString *external_url;
@property(nonatomic, strong) NSString *blogid;
@property(nonatomic, strong) NSString *teamid;
@property(nonatomic, strong) NSString *athlete;
@property(nonatomic, strong) NSString *coach;
@property(nonatomic, strong) NSString *gameschedule;
@property(nonatomic, strong) NSString *user;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *tinyavatar;
@property(nonatomic, strong) NSString *updatedat;
@property(nonatomic, strong) NSString *gamelog;

@property(nonatomic, strong) UIImage *thumbimage;
@property(nonatomic, strong) UIImage *tinyimage;

- (id)initWithDictionary:(NSDictionary *)blogDictionary;

@end
