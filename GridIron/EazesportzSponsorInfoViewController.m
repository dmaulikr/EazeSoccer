
//
//  EazesportzSponsorInfoViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSponsorInfoViewController.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzSponsorInfoViewController ()

@end

@implementation EazesportzSponsorInfoViewController

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
    
    if (currentSettings.user.userid.length > 0) {
        _createLoginButton.enabled = NO;
        _createLoginButton.hidden = YES;
        _loginMessageLabel.hidden = YES;
    } else {
        _createLoginButton.enabled = YES;
        _createLoginButton.hidden = NO;
        _loginMessageLabel.hidden = NO;
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)learnMoreButtonClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/sports/%@/%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id,
                                        currentSettings.sport.adurl]]];
}
@end
