//
//  PlayerSelectionViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 5/19/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "PlayerSelectionViewController.h"
#import "RosterTableCell.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "EditPlayerViewController.h"
#import "FindPlayerViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface PlayerSelectionViewController ()

@end

@implementation PlayerSelectionViewController {
    FindPlayerViewController *findPlayerController;
}

@synthesize player;
@synthesize rosterdata;
@synthesize jersey;
@synthesize position;

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
    rosterdata = currentSettings.roster;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    jersey = @"";
    position = @"";
    player = nil;
//    [currentSettings retrievePlayers];
    rosterdata = currentSettings.roster;
    _findPlayerContainer.hidden = YES;
    [_playerTableView reloadData];
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
    return rosterdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RosterTableCell";
    RosterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[RosterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *aplayer = [rosterdata objectAtIndex:indexPath.row];
    cell.playernameLabel.text = aplayer.name;
    cell.playerNumberLabel.text = [aplayer.number stringValue];
    cell.playerPositionLabel.text = aplayer.position;
    
    if ([currentSettings getRosterTinyImage:aplayer] == nil) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:aplayer.tinypic]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell.tag == indexPath.row) {
                    cell.rosterImage.image = [UIImage imageWithData:image];
                    [cell setNeedsLayout];
                }
            });
        });
    } else {
        cell.rosterImage.image = [currentSettings getRosterTinyImage:aplayer];
    }
    
    if ([currentSettings hasAlerts:aplayer.athleteid] == NO)
        cell.alertLabel.textColor = [UIColor clearColor];
    else
        cell.alertLabel.textColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Players";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FindPlayerSegue"]) {
        findPlayerController = segue.destinationViewController;
    } else {
        NSIndexPath *indexPath = [_playerTableView indexPathForSelectedRow];
        if (indexPath.length > 0) {
            player = [rosterdata objectAtIndex:indexPath.row];
            
            if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
                EditPlayerViewController *editDestViewController = segue.destinationViewController;
                editDestViewController.player = player;
            }
        }
    }
}

- (IBAction)searchButtonClicked:(id)sender {
    _findPlayerContainer.hidden = NO;
}

- (IBAction)searchPlayerSelected:(UIStoryboardSegue *)segue {
    _findPlayerContainer.hidden = YES;
    
    if ((findPlayerController.positionTextField.text.length > 0) || (findPlayerController.numberTextField.text.length > 0)) {
        jersey = findPlayerController.numberTextField.text;
        position = findPlayerController.positionTextField.text;
        [self searchPlayer];
    }
}

- (void)searchPlayer {
    if (jersey.length > 0) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        Athlete *aplayer = [currentSettings findAthleteByNumber:[f numberFromString:jersey]];
        rosterdata = [[NSMutableArray alloc] initWithObjects:aplayer, nil];
    } else {
        rosterdata = [currentSettings findAthleteByPosition:position];
    }
    [_playerTableView reloadData];
}

@end
