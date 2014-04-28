//
//  EazesportzPhotoImage.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/27/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EazesportzPhotoImage : NSObject

@property (nonatomic, strong, readonly) UIImage *theimage;

- (void)setImage:(NSString *)imageurl UpdatedAt:(NSDate *)updated_at;

@end
