//
//  EazesportzSponsorMapViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Sponsor.h"

@interface EazesportzSponsorMapViewController : UIViewController

@property (nonatomic, strong) Sponsor *sponsor;

@property (weak, nonatomic) IBOutlet MKMapView *sponsorMap;

@end
