//
//  sportzteamsCoachDataJSON.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sportzteamsCoachDataJSON : NSObject

@property(nonatomic, strong) NSMutableArray *coaches;

- (void)processCoachData:(NSArray *)serverData;

@end
