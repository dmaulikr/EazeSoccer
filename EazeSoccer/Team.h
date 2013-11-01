//
//  Team.h
//  smpwlions
//
//  Created by Gil on 3/9/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property(nonatomic, strong)NSString* teamid;
@property(nonatomic, strong)NSString* mascot;
@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSString* team_name;
@property(nonatomic, strong) NSString *team_logo;

@property(nonatomic, strong)UIImage *teamimage;

- (id)initWithDictionary:(NSDictionary *)teamDictionary;

- (UIImage *)getImage:(NSString *)size;
- (BOOL)hasImage;

@end
