//
//  EazesportzImage.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 3/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EazesportzImage : NSObject

@property (nonatomic, strong, readonly) NSString *modelid;
@property (nonatomic, strong, readonly) UIImage *tiny;
@property (nonatomic, strong, readonly) UIImage *thumb;
@property (nonatomic, strong, readonly) UIImage *medium;
@property (nonatomic, strong, readonly) UIImage *large;
@property (nonatomic, strong) UIImage *noimage;

- (id)initWithId:(NSString *)gameschedule_id;

- (void)setTiny:(NSString *)tinyurl UpdatedAt:(NSDate *)updated_at;
- (void)setThumb:(NSString *)thumburl UpdatedAt:(NSDate *)updated_at;
- (void)setMedium:(NSString *)mediumurl UpdatedAt:(NSDate *)updated_at;
- (void)setLarge:(NSString *)largeurl UpdatedAt:(NSDate *)updated_at;

@end
