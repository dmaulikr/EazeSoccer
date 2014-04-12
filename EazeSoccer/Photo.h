//
//  Photo.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/4/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameSchedule.h"

@interface Photo : NSObject

@property(nonatomic, strong) NSString *displayname;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *teamid;
@property(nonatomic, strong) NSString *schedule;
@property(nonatomic, strong) NSString *owner;
@property(nonatomic, strong) NSMutableArray *players;
@property(nonatomic, strong) NSString *photoid;
@property(nonatomic, strong) NSString *thumbnail_url;
@property(nonatomic, strong) NSString *medium_url;
@property(nonatomic, strong) NSString *large_url;
@property(nonatomic, strong) NSString *gamelog;
@property (nonatomic, assign) BOOL pending;

@property(nonatomic, strong) NSString *sport_id;
@property(nonatomic, strong) NSString *team_id;
@property (nonatomic, strong) NSString *user_id;

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) NSMutableArray *athletes;

@property(nonatomic, strong) UIImage *mediumimage;
@property(nonatomic, strong) UIImage *thumbimage;
@property(nonatomic, strong) UIImage *largeimage;

- (id)initWithDirectory:(NSDictionary *)items;

- (UIImage *)getImage:(NSString *)size;

- (void)loadImagesInBackground;

@end
