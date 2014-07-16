//
//  EazeWelcomeViewController.m
//  EazeSportz
//
//  Created by Gil on 1/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeWelcomeViewController.h"
#import "sportzteamsRegisterLoginViewController.h"
#import "Reachability.h"
#import "EazesportzAppDelegate.h"

#import <iAd/iAd.h>

@interface EazeWelcomeViewController () <ADInterstitialAdDelegate>

-(void)showFullScreenAd;

@end

@implementation EazeWelcomeViewController {
    ADInterstitialAd *interstitial;
    BOOL requestingAd;
}


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
    requestingAd = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//Interstitial iAd
-(void)showFullScreenAd {
    //Check if already requesting ad
    if (requestingAd == NO) {
        interstitial = [[ADInterstitialAd alloc] init];
        interstitial.delegate = self;
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
        [self requestInterstitialAdPresentation];
        NSLog(@"interstitialAdREQUEST");
        requestingAd = YES;
    }//end if
}

-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    interstitial = nil;
    requestingAd = NO;
    NSLog(@"interstitialAd didFailWithERROR");
    NSLog(@"%@", error);
}

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"interstitialAdDidLOAD");
    if (interstitialAd != nil && interstitial != nil && requestingAd == YES) {
        [interstitial presentFromViewController:self];
        NSLog(@"interstitialAdDidPRESENT");
    }//end if
}

-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
    interstitial = nil;
    requestingAd = NO;
    NSLog(@"interstitialAdDidUNLOAD");
}

-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
    interstitial = nil;
    requestingAd = NO;
    NSLog(@"interstitialAdDidFINISH");
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *reach = [note object];
    
    if ([reach isReachable]) {
        if ((currentSettings.sport.id.length == 0) || (currentSettings.team.teamid.length == 0))
            [self viewWillAppear:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Network connectivity lost!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
