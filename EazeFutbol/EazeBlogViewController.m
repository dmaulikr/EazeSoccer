//
//  EazeBlogViewController.m
//  EazeSportz
//
//  Created by Gil on 11/14/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeBlogViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeBlogDetailViewController.h"

@interface EazeBlogViewController () <UIAlertViewDelegate>

@end

@implementation EazeBlogViewController

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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addBlogEntryButton, self.refreshButton, self.searchButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (currentSettings.sport.id.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please select a site before continuing"
                                                       delegate:self cancelButtonTitle:@"Select Site" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    } else {
        [super viewWillAppear:animated];
    }
}

- (void)startRefresh {
    [self getBlogs:nil];
}

- (void)displayUpgradeAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:[NSString stringWithFormat:@"%@%@", @"No blogs for ", currentSettings.team.team_name]
                                                    delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BlogEntrySegue"]) {
        NSIndexPath *indexPath = [self.blogTableView indexPathForSelectedRow];
        EazeBlogDetailViewController *destController = segue.destinationViewController;
        destController.blog = [self.blogfeed objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"NewBlogSegue"] ) {
        
    } else
        [super prepareForSegue:segue sender:sender];
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"All"]) {
        self.team = currentSettings.team;
        self.player = nil;
        self.game = nil;
        self.coach = nil;
        self.user = nil;
        [self getBlogs:nil];
    } else if ([title isEqualToString:@"Dismiss"]) {
        self.tabBarController.selectedIndex = 0;
    } else if ([title isEqualToString:@"Select Site"]) {
        self.tabBarController.selectedIndex = 0;
    } else
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
}
*/
- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Enter Blog Search Criteria"
                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"User", @"Coach", @"All", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
