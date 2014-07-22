//
//  EazesportzBasketballOtherStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzBasketballOtherStatsViewController.h"

#import "EazesportzAppDelegate.h"
#import "BasketballStatTableCell.h"

@interface EazesportzBasketballOtherStatsViewController ()

@end

@implementation EazesportzBasketballOtherStatsViewController {
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
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.saveBarButton, _infoBarButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
    BasketballStatTableCell *cell = [[BasketballStatTableCell alloc] init];
    static NSString *CellIdentifier = @"BasketballStatsCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[BasketballStatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(58.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(80.0f, 8.0f, 50, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"PF" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(foulsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(90.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(180.0f, 8.0f, 50.0f, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"ORB" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(offreboundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(128.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(280.0f, 8.0f, 50.0f, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"DRB" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(defreboundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(166.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(380.0f, 8.0f, 50.0f, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"AST" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(assistsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(204.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(480.0f, 8.0f, 50.0f, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
   [btn setTitle:@"STL" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(stealsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(242.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(580.0f, 8.0f, 50.0f, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"BLK" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(blocksButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // The below line will add a state to each button which you can use to later differentiate in your method: btnClicked
    [btn setTag:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        btn.frame = CGRectMake(280.0f, 7.0f, 30, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    } else {
        btn.frame = CGRectMake(680.0f, 8.0f, 50.0f, 30.0f);
        btn.titleLabel.font = [UIFont systemFontOfSize: 17];
    }
    
    [btn setTitle:@"TOV" forState:UIControlStateNormal];
    [cell addSubview:btn];
    [btn addTarget:self action:@selector(turnoversButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    Athlete *athlete = [currentSettings.roster objectAtIndex:indexPath.row];
    cell.nameLabel.text = [athlete.number stringValue];
    BasketballStats *stats = [athlete findBasketballGameStatEntries:game.id];
    cell.fgmLabel.text = [stats.fouls stringValue];
    cell.fgaLabel.text = [stats.offrebound stringValue];
    cell.fgpLabel.text = [stats.defrebound stringValue];
    cell.threepmLabel.text = [stats.assists stringValue];
    cell.threepaLabel.text = [stats.steals stringValue];
    cell.threepctLabel.text = [stats.blocks stringValue];
    cell.ftmLabel.text = [stats.turnovers stringValue];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
        return 30.0;
    else
        return 44.0;
}

- (IBAction)foulsButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
    stats.fouls = [NSNumber numberWithInt:[stats.fouls intValue] + 1];
    [player updateBasketballGameStats:stats];
    [_otherStatsTableView reloadData];
}

- (IBAction)offreboundButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
    stats.offrebound = [NSNumber numberWithInt:[stats.offrebound intValue] + 1];
    [player updateBasketballGameStats:stats];
    [_otherStatsTableView reloadData];
}

- (IBAction)defreboundButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
    stats.defrebound = [NSNumber numberWithInt:[stats.defrebound intValue] + 1];
    [player updateBasketballGameStats:stats];
    [_otherStatsTableView reloadData];
}

- (IBAction)assistsButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
    stats.assists = [NSNumber numberWithInt:[stats.assists intValue] + 1];
    [player updateBasketballGameStats:stats];
    [_otherStatsTableView reloadData];
}

- (IBAction)stealsButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
    stats.steals = [NSNumber numberWithInt:[stats.steals intValue] + 1];
    [player updateBasketballGameStats:stats];
    [_otherStatsTableView reloadData];
}

- (IBAction)blocksButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
    stats.blocks = [NSNumber numberWithInt:[stats.blocks intValue] + 1];
    [player updateBasketballGameStats:stats];
    [_otherStatsTableView reloadData];
}

- (IBAction)turnoversButtonClicked:(id)sender {
    int selectedRow = [sender tag];
    player = [currentSettings.roster objectAtIndex:selectedRow];
    BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
    stats.turnovers = [NSNumber numberWithInt:[stats.turnovers intValue] + 1];
    [player updateBasketballGameStats:stats];
    [_otherStatsTableView reloadData];
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

- (IBAction)infoBarButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Legend" message:@"PF - Personal Fouls\nORB - Offensive Rebounds\nDRB - Defensive Rebounds\nAST - Assists\nSTL - Steals\nBLK - Blocks\nTOV - Turnovers" delegate:nil
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end
