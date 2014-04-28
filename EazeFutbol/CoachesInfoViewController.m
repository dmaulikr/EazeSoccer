//
//  sportzteamsCoachesInfoViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/2/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "CoachesInfoViewController.h"
#import "EazesportzAppDelegate.h"
#import "EditCoachViewController.h"
#import "EazesportzDisplayAdBannerViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface CoachesInfoViewController ()

@end

@implementation CoachesInfoViewController {
    EazesportzDisplayAdBannerViewController *adBannerController;
}

@synthesize coach;
@synthesize years;
@synthesize staffPosition;
@synthesize coachImage;
@synthesize bioTextVeiw;

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
//    self.view.backgroundColor = [UIColor clearColor];
    self.years.layer.cornerRadius = 6;
    bioTextVeiw.editable = NO;
    bioTextVeiw.layer.cornerRadius = 6;
    self.staffPosition.layer.cornerRadius = 6;
    staffPosition.numberOfLines = 2;
    _yearsonstaffLabel.layer.cornerRadius = 6;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = coach.fullname;
    [years setText:[coach.years stringValue]];
    [bioTextVeiw setText:coach.bio];
    self.title = coach.fullname;
    [staffPosition setText:coach.speciality];
    coachImage.image = [coach mediumimage];
    
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController viewWillAppear:YES];
    } else {
        _adBannerContainer.hidden = YES;
    }

    if (currentSettings.isSiteOwner) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButton,  nil];
    }
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _bannerView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditCoachSegue"]) {
        EditCoachViewController *destController = segue.destinationViewController;
        destController.coach = coach;
    } else if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adBannerController = segue.destinationViewController;
    }
}

@end
