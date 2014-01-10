//
//  FullCoachSelectionViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/17/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FullCoachSelectionViewController.h"
#import "CoachTableCell.h"
#import "Coach.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"

#import <QuartzCore/QuartzCore.h>

@interface FullCoachSelectionViewController () <UIAlertViewDelegate>

@end

@implementation FullCoachSelectionViewController {
    NSIndexPath *deleteIndexPath;
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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addCoachButton, self.teamButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (currentSettings.coaches.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Coaches"
                                                        message:@"Program administrator has not entered any coaches"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        [self.coachTableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CoachTableCell";
    CoachTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[CoachTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Coach *acoach = [currentSettings.coaches objectAtIndex:indexPath.row];
    cell.coachImage.image = [acoach getImage:@"thumb"];
    cell.coachnameLabel.text = acoach.fullname;
    cell.responsibilityLabel.text = acoach.speciality;
    cell.yearsLabel.text = [acoach.years stringValue];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteIndexPath = [self.coachTableView indexPathForSelectedRow];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"All Coach data will be lost. Click Confirm to Proceed"
                                                       delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if (![[currentSettings.coaches objectAtIndex:deleteIndexPath.row] initDeleteCoach]) {
            [currentSettings.coaches removeObjectAtIndex:deleteIndexPath.row];
            [self.coachTableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[[currentSettings.coaches objectAtIndex:deleteIndexPath.row] httperror]
                                                           delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
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

@end
