//
//  EazesportzPlacemark.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzPlacemark.h"

@implementation EazesportzPlacemark

@synthesize coordinate;
@synthesize markTitle, markSubTitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate andMarkTitle:(NSString *)theMarkTitle andMarkSubTitle:(NSString *)theMarkSubTitle {
	coordinate = theCoordinate;
    markTitle = theMarkTitle;
    markSubTitle = theMarkSubTitle;
	return self;
}

- (NSString *)title {
    return markTitle;
}

- (NSString *)subtitle {
    return markSubTitle;
}

@end
