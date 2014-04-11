//
//  EazesportzSponsorMapViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSponsorMapViewController.h"
#import "EazesportzPlacemark.h"

#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344

@interface EazesportzSponsorMapViewController ()

@end

@implementation EazesportzSponsorMapViewController {
    CLLocation *oldLocation;
}

@synthesize sponsor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedLocation:) name:@"NewLocationNotification" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updatedLocation:(NSNotification *)notification {
    CLLocation *newLocation = [[notification userInfo] objectForKey:@"newLocationResult"];
    
    // 2
    if ((oldLocation.coordinate.longitude != newLocation.coordinate.longitude)
        || (oldLocation.coordinate.latitude != newLocation.coordinate.latitude)) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        
        // 3
        [_sponsorMap setRegion:viewRegion animated:YES];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSString* address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", sponsor.addrnum, sponsor.street, sponsor.city, sponsor.state, sponsor.zip];
        
        [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
            if([placemarks count]) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocation *location = placemark.location;
                CLLocationCoordinate2D coordinate = location.coordinate;
                EazesportzPlacemark *sponsorplacemark = [[EazesportzPlacemark alloc] initWithCoordinate:coordinate andMarkTitle:sponsor.name
                                                                                andMarkSubTitle:[NSString stringWithFormat:@"%@ %@",sponsor.phone, sponsor.adurl]];
                [_sponsorMap addAnnotation:sponsorplacemark];
            } else {
                NSLog(@"location error");
                return;
            }
        }];
        
        CLLocationCoordinate2D coord = newLocation.coordinate;
        
        MKCoordinateRegion region;
        region.center = coord;
        
        MKCoordinateSpan span = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
        region.span = span;
        
        [_sponsorMap setRegion:region];
        
        
        EazesportzPlacemark *placeMark = [[EazesportzPlacemark alloc] initWithCoordinate:coord andMarkTitle:@"You" andMarkSubTitle:@"are here"];
        
        [_sponsorMap addAnnotation:placeMark];
        oldLocation = newLocation;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[EazesportzPlacemark class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_sponsorMap dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil; 
}

@end
