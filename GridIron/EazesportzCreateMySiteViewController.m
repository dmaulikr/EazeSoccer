//
//  EazesportzCreateMySiteViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 3/31/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzCreateMySiteViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeLoginViewController.h"

@interface EazesportzCreateMySiteViewController ()

@end

@implementation EazesportzCreateMySiteViewController

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginSegue"]) {
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

- (IBAction)createMySiteButtonClicked:(id)sender {
    if (currentSettings.user.userid.length > 0) {
        [self performSegueWithIdentifier:@"CreateSiteSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

@end
