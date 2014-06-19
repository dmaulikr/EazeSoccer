//
//  EazesportzRetrieveInAppAdProducts.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EazesportzRetrieveInAppAdProducts : NSObject

@property (nonatomic, strong) NSMutableArray *products;

- (void)retrieveProducts;

@end
