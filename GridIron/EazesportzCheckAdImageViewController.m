//
//  EazesportzCheckAdImageViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzCheckAdImageViewController.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzCheckAdImageViewController ()

@end

@implementation EazesportzCheckAdImageViewController

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
    
    if (!sponsor) {
        sponsor = [currentSettings.sponsors getSponsorAd];
    }
    
    self.title = sponsor.name;
//    [_AdLabelButton setTitle:sponsor.name forState:UIControlStateNormal];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        if ((sponsor.mediumimage == nil) && (sponsor.medium.length > 0)) {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sponsor.medium]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _sponsorAdImage.image = [UIImage imageWithData:image];
                });
            });
        } else if (sponsor.medium.length == 0) {
            _sponsorAdImage.image = [currentSettings.team getImage:@"thumb"];
        } else
            _sponsorAdImage.image = sponsor.mediumimage;
    } else {
        if ((sponsor.largeimage == nil) && (sponsor.large.length > 0)) {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sponsor.large]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _sponsorAdImage.image = [UIImage imageWithData:image];
                });
            });
        } else if (sponsor.large.length == 0) {
            _sponsorAdImage.image = [currentSettings.team getImage:@"thumb"];
        } else
            _sponsorAdImage.image = sponsor.largeimage;
    }
}

- (IBAction)adLabelButtonClicked:(id)sender {
    if (sponsor.adurl.length > 0)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sponsor.adurl]];
}

@end
