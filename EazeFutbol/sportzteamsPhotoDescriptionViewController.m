//
//  sportzteamsPhotoDescriptionViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "sportzteamsPhotoDescriptionViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "PlayerInfoViewController.h"

@interface sportzteamsPhotoDescriptionViewController ()

@end

@implementation sportzteamsPhotoDescriptionViewController

@synthesize photo;
@synthesize photoDescriptionText;
@synthesize photoNameLabel;

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
    _gameButton.layer.cornerRadius = 4;
    photoNameLabel.layer.cornerRadius = 4;
    _playerTableView.layer.cornerRadius = 4;
    
    if ([photo.athletes count] > 0) {
        NSString *thePlayers = [[photo.athletes objectAtIndex:0] name];
        thePlayers = [thePlayers stringByAppendingString:@"\n"];
        if ([photo.athletes count] > 1) {
            for (int i = 1; i < [photo.athletes count]; i++) {
                thePlayers = [thePlayers stringByAppendingString:[[photo.athletes objectAtIndex:i] name]];
                thePlayers = [thePlayers stringByAppendingString:@"\n"];
            }
        }
    } else {
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (photo) {
        [photoDescriptionText setText:photo.description];
        [photoNameLabel setText:photo.displayname];
        
        if (photo.schedule.length > 0) {
            [_gameButton setTitle:[NSString stringWithFormat:@"%@%@", @"vs. ", [[currentSettings findGame:photo.schedule] opponent]]
                                                    forState:UIControlStateNormal];
            [_gameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _gameButton.enabled = YES;
        } else {
            [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _gameButton.enabled = NO;
        }
        
    } else {
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [photo.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerTags";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *player = [currentSettings findAthlete:[photo.players objectAtIndex:indexPath.row]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = player.full_name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Players";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    NSString *cellText = cell.textLabel.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameDetailSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:photo.schedule];
    } else if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        NSIndexPath *indexPath = [_playerTableView indexPathForSelectedRow];
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings findAthlete:[photo.players objectAtIndex:indexPath.row]];
    }
}

@end
