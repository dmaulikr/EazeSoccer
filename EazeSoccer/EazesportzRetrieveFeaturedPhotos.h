//
//  EazesportzRetrieveFeaturedPhotos.h
//  EazeSportz
//
//  Created by Gil on 1/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EazesportzRetrieveFeaturedPhotos : NSObject

@property(nonatomic,strong) NSMutableArray *featuredphotos;

- (void)retrieveFeaturedPhotos:(NSString *)sportid Token:(NSString *)token;

@end
