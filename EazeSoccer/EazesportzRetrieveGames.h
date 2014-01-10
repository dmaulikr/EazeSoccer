//
//  EazesportzRetrieveGames.h
//  EazeSportz
//
//  Created by Gil on 1/9/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EazesportzRetrieveGames : NSObject

- (void)retrieveGames:(NSString *)sportid Team:(NSString *)teamid Token:(NSString *)authtoken;

@end
