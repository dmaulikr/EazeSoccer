//
//  EazesportzProgramCreatedViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/9/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzProgramCreatedViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzProgramCreatedViewController ()

@end

@implementation EazesportzProgramCreatedViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)visitEazesportzButtonClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentSettings.sport.pricingurl]];
}

- (IBAction)getStartedButtonClicked:(id)sender {
    UITabBarController *tabBarController = self.tabBarController;
    
    for (UIViewController *viewController in tabBarController.viewControllers) {
        if ([viewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
    
    if (fromView != toView) {
        // Transition using a page curl.
        [UIView transitionFromView:fromView toView:toView duration:0.5
                           options:(4 > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                        completion:^(BOOL finished) {
                            if (finished) {
                                tabBarController.selectedIndex = 0;
                            }
                        }];
    } else
        [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
