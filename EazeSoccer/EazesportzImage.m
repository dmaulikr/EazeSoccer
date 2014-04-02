//
//  EazesportzImage.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 3/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzImage.h"

@implementation EazesportzImage {
    NSDate *tiny_updated_at, *thumb_updated_at, *medium_updated_at, *large_updated_at;
}

@synthesize noimage;

- (id)initWithId:(NSString *)modelid {
    if (self = [super init]) {
        noimage = nil;
        _modelid = modelid;
        return self;
    } else
         return nil;
}

- (void)setTiny:(NSString *)tinyurl UpdatedAt:(NSDate *)updated_at {
    if ([updated_at compare:tiny_updated_at] == NSOrderedDescending) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:tinyurl]];
            _tiny = [UIImage imageWithData:image];
            tiny_updated_at = updated_at;
        });
    }
}

- (void)setThumb:(NSString *)thumburl UpdatedAt:(NSDate *)updated_at {
    if ([updated_at compare:thumb_updated_at] == NSOrderedDescending) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumburl]];
            _thumb = [UIImage imageWithData:image];
            thumb_updated_at = updated_at;
        });
    }
}

- (void)setMedium:(NSString *)mediumurl UpdatedAt:(NSDate *)updated_at {
    if ([updated_at compare:medium_updated_at] == NSOrderedDescending) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:mediumurl]];
            _medium = [UIImage imageWithData:image];
            medium_updated_at = updated_at;
        });
    }
}

- (void)setLarge:(NSString *)largeurl UpdatedAt:(NSDate *)updated_at {
    if ([updated_at compare:large_updated_at] == NSOrderedDescending) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:largeurl]];
            _large = [UIImage imageWithData:image];
            large_updated_at = updated_at;
        });
    }
}

@end
