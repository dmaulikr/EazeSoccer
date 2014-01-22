//
//  EazeFootballGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeFootballGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeFootballGameStatsViewController.h"

@interface EazeFootballGameSummaryViewController () <UIAlertViewDelegate>

@end

@implementation EazeFootballGameSummaryViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _homeImage.image = [currentSettings.team getImage:@"tiny"];
    _visitorImage.image = [game opponentImage];
    _sbhomeLabel.text = currentSettings.team.mascot;
    _sbvisitorLabel.text = [game opponent_mascot];
    _clockLabel.text = [game currentgametime];
    _homeScoreLabel.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    _visitorScoreLabel.text = [game.opponentscore stringValue];
    _homeTimeOutLabel.text = [game.hometimeouts stringValue];
    _visitorTimeOutLabel.text = [game.opponenttimeouts stringValue];
    _ballonLabel.text = [game.ballon stringValue];
    _downLabel.text = [game.down stringValue];
    _togoLabel.text = [game.togo stringValue];
    _quarterLabel.text = [game.period stringValue];
    _sumhomeLabel.text = currentSettings.team.mascot;
    _sumvisitorLabel.text = game.opponent_mascot;
    _hq1Label.text = [game.homeq1 stringValue];
    _hq2Label.text = [game.homeq2 stringValue];
    _hq3Label.text = [game.homeq3 stringValue];
    _hq4Label.text = [game.homeq4 stringValue];
    _vq1Label.text = [game.opponentq1 stringValue];
    _vq2Label.text = [game.opponentq2 stringValue];
    _vq3Label.text = [game.opponentq3 stringValue];
    _vq4Label.text = [game.opponentq4 stringValue];
    _htotalLabel.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    _vtotalLabel.text = [NSString stringWithFormat:@"%d", [game.opponentq4 intValue] + [game.opponentq3 intValue] + [game.opponentq2 intValue] +
                         [game.opponentq1 intValue]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Score Log";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[game gamelogs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GameLogTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Gamelogs *log = [[game gamelogs] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.text = [log logentrytext];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FootballGameStatsSegue"]) {
        if ([currentSettings.sport isPackageEnabled]) {
            EazeFootballGameStatsViewController *destController = segue.destinationViewController;
            destController.game = game;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Required"
                                 message:[NSString stringWithFormat:@"%@%@%@", @"Photo support not available for ", currentSettings.team.team_name,
                                 @". Contact your administrator with questions."] delegate:self cancelButtonTitle:@"Dismiss"
                                 otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Dismiss"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

@end
