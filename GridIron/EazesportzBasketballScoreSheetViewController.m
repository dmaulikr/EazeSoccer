//
//  EazesportzBasketballScoreSheetViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzBasketballScoreSheetViewController.h"

#import "EazesportzAppDelegate.h"
#import "EazesportzBasktetballStatTableViewCell.h"
#import "EazesportzBasketballOtherStatsViewController.h"

@interface EazesportzBasketballScoreSheetViewController ()

@end

@implementation EazesportzBasketballScoreSheetViewController {
    Athlete *player;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([currentSettings isSiteOwner])
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.otherBarButton, self.saveBarButton, nil];
    else
        self.navigationItem.rightBarButtonItem = self.otherBarButton;
    
    self.navigationController.toolbarHidden = YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OtherStatsSegue"]) {
        EazesportzBasketballOtherStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentSettings.roster.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EazesportzBasktetballStatTableViewCell *cell = [[EazesportzBasktetballStatTableViewCell alloc] init];
    static NSString *CellIdentifier = @"BasketballStatsCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[EazesportzBasktetballStatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(158.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(330.0f, 7.0f, 46, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"2PT" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(twopointButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(196.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(460.0f, 7.0f, 46, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"3PT" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(threepointButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(234.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(590.0f, 7.0f, 46, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"FT" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(freethrowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    Athlete *athlete = [currentSettings.roster objectAtIndex:indexPath.row];
    cell.playerLabel.text = athlete.numberLogname;
    cell.pointsLabel.text = [[[athlete findBasketballGameStatEntries:game.id] pointTotal:game.id] stringValue];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView;
    static NSString *CellIdentifier = @"StatsHeaderCell";
    headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    headerView.backgroundColor = [UIColor cyanColor];
    
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
        return 30.0;
    else
        return 44.0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    BasketballStats *stats;
    
    if (player)
        stats = [player findBasketballGameStatEntries:game.id];
    
    if ([title isEqualToString:@"FG Made"]) {
        stats.twomade = [NSNumber numberWithInt:[stats.twomade intValue] + 1];
        stats.twoattempt = [NSNumber numberWithInt:[stats.twoattempt intValue] + 1];
    } else if ([title isEqualToString:@"FG Missed"]) {
        stats.twoattempt = [NSNumber numberWithInt:[stats.twoattempt intValue] + 1];
    } else if ([title isEqualToString:@"3FG Made"]) {
        stats.threemade = [NSNumber numberWithInt:[stats.threemade intValue] + 1];
        stats.threeattempt = [NSNumber numberWithInt:[stats.threeattempt intValue] + 1];
    } else if ([title isEqualToString:@"3FG Missed"]) {
        stats.threeattempt = [NSNumber numberWithInt:[stats.threeattempt intValue] + 1];
    } else if ([title isEqualToString:@"FT Made"]) {
        stats.ftmade = [NSNumber numberWithInt:[stats.ftmade intValue] + 1];
        stats.ftattempt = [NSNumber numberWithInt:[stats.ftattempt intValue] + 1];
    } else if ([title isEqualToString:@"FT Missed"]) {
        stats.ftattempt = [NSNumber numberWithInt:[stats.ftattempt intValue] + 1];
    }
    
    [player updateBasketballGameStats:stats];
    
    [_scoreSheetTableView reloadData];
}

- (IBAction)twopointButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Field Goal"
                                                    message:[NSString stringWithFormat:@"Add Field Goal Stats %@", player.logname] delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"FG Made", @"FG Missed", nil];
    [alert show];
}

- (IBAction)threepointButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"3PT Field Goal" message:[NSString stringWithFormat:@"Add 3PT Stats %@", player.logname]
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"3FG Made", @"3FG Missed", nil];
    [alert show];
}

- (IBAction)freethrowButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Free Throw" message:[NSString stringWithFormat:@"Add Free Throw Stats %@", player.logname]
                                                    delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"FT Made", @"FT Missed", nil];
    [alert show];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)saveBarButtonClicked:(id)sender {
    for (int i = 0; i < currentSettings.roster.count; i++) {
        [[currentSettings.roster objectAtIndex:i] saveBasketballGameStats:game.id];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Stats Updated!" delegate:nil
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
