//
//  LiveStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "LiveStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "SoccerPlayerStatsViewController.h"
#import "sportzServerInit.h"
#import "BasketballStatsViewController.h"
#import "EazesportzFootballStatsViewController.h"
#import "EditGameViewController.h"

@interface LiveStatsViewController ()

@end

@implementation LiveStatsViewController {
    SoccerPlayerStatsViewController *soccerStatsController;
    BasketballStatsViewController *basketballStatsController;
    EazesportzFootballStatsViewController *footballStatsController;
}

@synthesize game;

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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.saveButton, self.editButton, self.teamButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithFormat:@"%@%@", @"Stats vs. ", game.opponent];
    
    if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        soccerStatsController.game = game;
        [soccerStatsController viewWillAppear:YES];
    } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
        basketballStatsController.game = game;
        [basketballStatsController viewWillAppear:YES];
    } else if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        footballStatsController.game = game;
        [footballStatsController viewWillAppear:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SoccerPlayerStatsSegue"]) {
        soccerStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"BasketballPlayerStatsSegue"]) {
        basketballStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"FootballPlayerStatsSegue"]) {
        footballStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"EditGameSegue"]) {
        EditGameViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

- (IBAction)changeteamButtonClicked:(id)sender {
    currentSettings.team = nil;
    UITabBarController *tabBarController = self.tabBarController;
    
    for (UIViewController *viewController in tabBarController.viewControllers)
    {
        if ([viewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
    currentSettings.selectedTab = tabBarController.selectedIndex;
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(4 > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = 0;
                        }
                    }];
}

- (IBAction)saveButtonClicked:(id)sender {
    if ([currentSettings.sport.name isEqualToString:@"Basketball"])
        [basketballStatsController saveButtonClicked:self];
    else if ([currentSettings.sport.name isEqualToString:@"Football"])
        [footballStatsController savestatsButtonClicked:self];
    else if ([currentSettings.sport.name isEqualToString:@"Soccer"])
        [soccerStatsController saveButtonClicked:self];
}
@end
