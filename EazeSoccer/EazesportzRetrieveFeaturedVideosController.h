//
//  EazesportzRetrieveFeaturedVideosController.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EazesportzRetrieveFeaturedVideosController : NSObject

@property(nonatomic, strong) NSMutableArray *featuredvideos;

- (void)retrieveFeaturedVideos:(NSString *)sportid Token:(NSString *)token;

@end
