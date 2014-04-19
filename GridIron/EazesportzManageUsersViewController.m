//
//  EazesportzManageUsersViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzManageUsersViewController.h"
#import "UsersViewController.h"
#import "EditUserViewController.h"

@interface EazesportzManageUsersViewController ()

@end

@implementation EazesportzManageUsersViewController {
    UsersViewController *userController;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UserSelectSegue"])
        userController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"EditUserSegue"]) {
        EditUserViewController *destController = segue.destinationViewController;
        destController.theuser = userController.user;
    }
}

- (IBAction)selectUser:(UIStoryboardSegue *)segue {
    if (userController.user) {
        [self setTheUser];
    }
}

- (void)setTheUser {
    [self performSegueWithIdentifier:@"EditUserSegue" sender:self];
}

@end
