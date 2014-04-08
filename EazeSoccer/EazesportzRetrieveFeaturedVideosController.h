//
//  EazesportzRetrieveFeaturedVideosController.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"

@interface EazesportzRetrieveFeaturedVideosController : NSObject

@property(nonatomic, strong) NSMutableArray *featuredvideos;

- (void)retrieveFeaturedVideos:(NSString *)sportid Token:(NSString *)token;
- (void)addFeaturedVideo:(Video *)video;
- (void)removeFeaturedVideo:(Video *)video;
- (void)saveFeaturedVideos;
- (BOOL)isFeaturedVideo:(Video *)video;

@end
