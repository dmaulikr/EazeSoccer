//
//  InAppProducts.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppProducts : NSObject

@property (nonatomic, strong) NSString *referencename;
@property (nonatomic, strong) NSString *productid;
@property (nonatomic, strong) NSString *adtype;
@property (nonatomic, strong) NSString *appleid;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, assign) BOOL playerad;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *ios_client_ad_id;

@property (nonatomic, strong) NSString *tinyurl;
@property (nonatomic, strong) NSString *thumburl;
@property (nonatomic, strong) NSString *mediumurl;

- (id)initWithDictionary:(NSDictionary *)productDictionary;

@end
