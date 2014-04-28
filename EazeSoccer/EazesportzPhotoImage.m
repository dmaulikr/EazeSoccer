//
//  EazesportzPhotoImage.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/27/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzPhotoImage.h"

@implementation EazesportzPhotoImage {
    NSDate *image_updated_at;
}

@synthesize theimage;

- (id)initWithId {
    if (self = [super init]) {
        theimage = nil;
        return self;
    } else
        return nil;
}

- (void)setImage:(NSString *)imageurl UpdatedAt:(NSDate *)updated_at {
    if ([image_updated_at compare:updated_at] == NSOrderedDescending) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageurl]];
            theimage = [UIImage imageWithData:image];
            image_updated_at = updated_at;
        });
    }
}
@end
