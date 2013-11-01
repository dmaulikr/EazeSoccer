//
//  Contact.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/7/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *fax;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *contactid;

@end
