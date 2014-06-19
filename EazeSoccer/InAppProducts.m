//
//  InAppProducts.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "InAppProducts.h"

@implementation InAppProducts

@synthesize productid;
@synthesize referencename;
@synthesize adtype;
@synthesize appleid;
@synthesize price;
@synthesize playerad;
@synthesize description;
@synthesize ios_client_ad_id;


@synthesize tinyurl;
@synthesize thumburl;
@synthesize mediumurl;

- (id)initWithDictionary:(NSDictionary *)productDictionary {
    if (self = [super init]) {
        productid = [productDictionary objectForKey:@"productid"];
        referencename = [productDictionary objectForKey:@"referencename"];
        adtype = [productDictionary objectForKey:@"adtype"];
        appleid = [productDictionary objectForKey:@"appleid"];
        price = [productDictionary objectForKey:@"price"];
        playerad = [[productDictionary objectForKey:@"playerad"] boolValue];
        description = [productDictionary objectForKey:@"description"];
        ios_client_ad_id = [productDictionary objectForKey:@"id"];
        
        tinyurl = [productDictionary objectForKey:@"tiny"];
        thumburl = [productDictionary objectForKey:@"thumb"];
        mediumurl = [productDictionary objectForKey:@"medium"];

        return self;
    } else {
        return nil;
    }
}

@end
