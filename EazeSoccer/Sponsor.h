//
//  Sponsor.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/10/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sponsor : NSObject

@property(nonatomic, strong) NSString *sponsorid;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *zip;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *fax;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *adurl;
@property(nonatomic, strong) NSString *thumb;
@property(nonatomic, strong) NSString *medium;
@property(nonatomic, strong) NSString *large;
@property(nonatomic, strong) NSNumber *priority;
@property(nonatomic, strong) NSNumber *teamonly;
@property(nonatomic, strong) NSString *teamid;

@end
