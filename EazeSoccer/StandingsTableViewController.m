//
//  StandingsTableViewController.m
//  Basketball Console
//
//  Created by Gil on 10/22/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "StandingsTableViewController.h"
#import "eazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "StandingsTableViewCell.h"
#import "Standings.h"
#import "EditStandingViewController.h"
#import "EazesportzRetrieveStandings.h"

@interface StandingsTableViewController ()

@end

@implementation StandingsTableViewController {
    NSMutableArray *leaguelist;
    
    EazesportzRetrieveStandings *getStandings;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotStandings:) name:@"StandingsListChangedNotification" object:nil];
}

- (void)gotStandings:(NSNotification *)notification {
    if (![[[notification userInfo] valueForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                message:[[notification userInfo] valueForKey:@"Result"]
                                                delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        leaguelist = getStandings.standings;
        [_standingTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    getStandings = [[EazesportzRetrieveStandings alloc] init];
    [getStandings retrieveStandings:currentSettings.sport.id Token:currentSettings.user.authtoken];
}

- (void)viewDidDisappear:(BOOL)animated {
    // do not forget to unsubscribe the observer, or you may experience crashes towards a deallocated observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return leaguelist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StandingCell";
    StandingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Standings *standing = [leaguelist objectAtIndex:indexPath.row];
    cell.teamNameLabel.text = [NSString stringWithFormat:@"%@%@%@", standing.teamname, @" ", standing.mascot];
    
    if (standing.gameschedule_id.length > 0) {
        if (standing.oppimageurl.length > 0) {
            NSURL * imageURL = [NSURL URLWithString:standing.oppimageurl];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            cell.teamImage.image = [UIImage imageWithData:imageData];
        } else {
            cell.teamImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        }
    } else {
        cell.teamImage.image = [currentSettings.team getImage:@"thumb"];
    }
    
    cell.overallLabel.text = [NSString stringWithFormat:@"%d%@%d%@%d", [standing.leaguewins intValue] + [standing.nonleaguewins intValue], @"-",
                              [standing.leaguelosses intValue] + [standing.nonleaguelosses intValue], @"-",
                              [standing.leagueties intValue] + [standing.nonleagueties intValue]];
    cell.leagueLabel.text = [NSString stringWithFormat:@"%d%@%d%@%d", [standing.leaguewins intValue], @"-", [standing.leaguelosses intValue], @"-",
                             [standing.leagueties intValue]];
    cell.streakLabel.text = @"";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[leaguelist objectAtIndex:indexPath.row] gameschedule_id].length > 0) {
        [self performSegueWithIdentifier:@"StandingSelectSegue" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Record for your team is automatically computed!"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 760.0, 60.0)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 15.0, 200.0, 55.0)];
    label.backgroundColor= [UIColor clearColor];
    label.textColor = [UIColor blueColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.text = @"Team";
    [header addSubview:label];
    
    UILabel *FGALabel = [[UILabel alloc] initWithFrame:CGRectMake(488.0, 15.0, 100.0, 55.0)];
    FGALabel.backgroundColor= [UIColor clearColor];
    FGALabel.textColor = [UIColor blueColor];
    FGALabel.shadowColor = [UIColor whiteColor];
    FGALabel.shadowOffset = CGSizeMake(0, 1);
    FGALabel.font = [UIFont boldSystemFontOfSize:18.0];
    FGALabel.text = @"Overall";
    [header addSubview:FGALabel];
    
    UILabel *FGMLabel = [[UILabel alloc] initWithFrame:CGRectMake(648.0, 15.0, 100.0, 55.0)];
    FGMLabel.backgroundColor= [UIColor clearColor];
    FGMLabel.textColor = [UIColor blueColor];
    FGMLabel.shadowColor = [UIColor whiteColor];
    FGMLabel.shadowOffset = CGSizeMake(0, 1);
    FGMLabel.font = [UIFont boldSystemFontOfSize:18.0];
    FGMLabel.text = @"League";
    [header addSubview:FGMLabel];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"StandingSelectSegue"]) {
        NSIndexPath *indexPath = [_standingTableView indexPathForSelectedRow];
        EditStandingViewController *destController = segue.destinationViewController;
        destController.standing = [leaguelist objectAtIndex:indexPath.row];
    }
}

- (IBAction)teamButtonClicked:(id)sender {
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
