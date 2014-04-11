//
//  EazesportzPlacemark.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EazesportzPlacemark : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *markTitle, *markSubTitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *markTitle, *markSubTitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate andMarkTitle:(NSString *)theMarkTitle andMarkSubTitle:(NSString *)theMarkSubTitle;

@end
