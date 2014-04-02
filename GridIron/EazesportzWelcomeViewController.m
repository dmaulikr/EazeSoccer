//
//  EazesportzWelcomeViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 3/30/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWelcomeViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeLoginViewController.h"

@interface EazesportzWelcomeViewController ()

@end

@implementation EazesportzWelcomeViewController

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
    _sponsorButton.hidden = YES;
    currentSettings.firstuse = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CreateNewSiteSegue"]) {
        EazeLoginViewController *destController = segue.destinationViewController;
        destController.registeradmin = YES;
    }
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
