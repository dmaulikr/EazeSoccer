//
//  sportzteamsAlertsJSON.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/28/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sportzteamsAlertsJSON : NSObject

@property(nonatomic, strong) NSMutableArray *alerts;

- (void)processAlertData:(NSArray *)alertData;

@end
