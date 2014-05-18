//
//  EazesportzClientNotificationViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/14/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzClientNotificationViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzSendNotificationData.h"

@interface EazesportzClientNotificationViewController ()

@end

@implementation EazesportzClientNotificationViewController

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
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [_athleteSwitch setOn:[[standardUserDefaults objectForKey:@"BioAlerts"] boolValue]];
    [_scoreSwitch setOn:[[standardUserDefaults objectForKey:@"ScoreAlerts"] boolValue]];
    [_mediaSwitch setOn:[[standardUserDefaults objectForKey:@"MediaAlerts"] boolValue]];
    [_blogSwitch setOn:[[standardUserDefaults objectForKey:@"BlogAlerts"] boolValue]];
    [_teamNewsSwitch setOn:[[standardUserDefaults objectForKey:@"TeamAlerts"] boolValue]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertUpdated:) name:@"SponsorListChangedNotification" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)alertUpdated:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Notification preferences updated!" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Notification preferences update failed!" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitButtonClicked:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setValue:[NSNumber numberWithBool:_athleteSwitch.isOn] forKey:@"BioAlerts"];
    [standardUserDefaults setValue:[NSNumber numberWithBool:_scoreSwitch.isOn] forKey:@"ScoreAlerts"];
    [standardUserDefaults setValue:[NSNumber numberWithBool:_mediaSwitch.isOn] forKey:@"MediaAlerts"];
    [standardUserDefaults setValue:[NSNumber numberWithBool:_blogSwitch.isOn] forKey:@"BlogSwitch"];
    [standardUserDefaults setValue:[NSNumber numberWithBool:_teamNewsSwitch.isOn] forKey:@"TeamAlerts"];
    [standardUserDefaults synchronize];
    
    [[[EazesportzSendNotificationData alloc] init] sendNotificationData:currentSettings.sport Team:currentSettings.team Athlete:nil User:currentSettings.user];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
