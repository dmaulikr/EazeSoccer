//
//  Coach.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/2/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coach : NSObject

@property(nonatomic, strong) NSString *lastname;
@property(nonatomic, strong) NSString *middlename;
@property(nonatomic, strong) NSString *firstname;
@property(nonatomic, strong) NSString *fullname;
@property(nonatomic, strong) NSString *speciality;
@property(nonatomic, strong) NSNumber *years;
@property(nonatomic, strong) NSString *bio;
@property(nonatomic, strong) NSString *coachid;
@property(nonatomic, strong) NSString *teamid;
@property(nonatomic, strong) NSString *thumb;
@property(nonatomic, strong) NSString *tiny;
@property(nonatomic, strong) NSString *medium;
@property(nonatomic, strong) NSString *teamname;
@property(nonatomic, assign) BOOL processing;

@property(nonatomic, strong) UIImage *thumbimage;
@property(nonatomic, strong) UIImage *tinyimage;
@property(nonatomic, strong) UIImage *mediumimage;

@property(nonatomic, strong) NSString *httperror;

- (UIImage *)getImage:(NSString *)size;

- (id)initWithDictionary:(NSDictionary *)coachDictionary;
- (id)initDeleteCoach;

- (void)loadImages;

@end
