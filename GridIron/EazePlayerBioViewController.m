//
//  EazePlayerBioViewController.m
//  EazeSportz
//
//  Created by Gil on 3/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazePlayerBioViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzDisplayAdBannerViewController.h"

@interface EazePlayerBioViewController ()

@end

@implementation EazePlayerBioViewController {
    EazesportzDisplayAdBannerViewController *adBannerController;
}

@synthesize player;

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
    _playerBioTextView.layer.borderWidth = 1.0f;
    _playerBioTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savedPlayer:) name:@"AthleteSavedNotification" object:nil];

    _playerNameLabel.text = player.full_name;
    _playerImageView.image = [currentSettings getRosterMediumImage:player];
    _playerBioTextView.text = player.bio;
    
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController displayPlayerAd:player];
    } else {
        _adBannerContainer.hidden = YES;
    }
    
    if (currentSettings.isSiteOwner) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.saveButton, nil];
        _playerBioTextView.editable = YES;
    } else {
        _playerBioTextView.editable = NO;
    }
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)saveButtonClicked:(id)sender {
    player.bio = _playerBioTextView.text;
    [player saveAthlete];
}

- (void)savedPlayer:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Player Bio Updated" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error Saving Bio" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adBannerController = segue.destinationViewController;
    }
}

@end
