//
//  EazesportzGameLogViewController.m
//  EazeSportz
//
//  Created by Gil on 11/25/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzGameLogViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzRetrievePlayers.h"

@interface EazesportzGameLogViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzGameLogViewController {
    NSIndexPath *deleteIndexPath;
    NSArray *sortedlogs;
}

@synthesize game;
@synthesize gamelog;

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
    self.title = @"Select Play";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"period" ascending:YES
                                                                     selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO
                                                                     selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray * descriptors = [NSArray arrayWithObjects:lastDescriptor, firstDescriptor, nil];
    game.gamelogs = [(NSArray*)[game.gamelogs sortedArrayUsingDescriptors:descriptors] mutableCopy];
    
    [_gamelogTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return game.gamelogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScoreTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    Gamelogs *log = [game.gamelogs objectAtIndex:indexPath.row];
    cell.textLabel.text = log.logentrytext;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Score Logs";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
        return  NO;
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    gamelog = [game.gamelogs objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Stats will be automatically updated. Click Confirm to Proceed"
                                                       delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_gamelogTableView indexPathForSelectedRow];
    
    if (indexPath.length > 0) {
        gamelog = [game.gamelogs objectAtIndex:indexPath.row];
    } else {
        gamelog = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        Gamelogs *alog = [game.gamelogs objectAtIndex:deleteIndexPath.row];
        if (![alog initDeleteGameLog]) {
            [game.gamelogs removeObjectAtIndex:deleteIndexPath.row];
            [_gamelogTableView reloadData];
            [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid
                                                                Token:currentSettings.user.authtoken];          // Need to optimize and only retrieve stats
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[alog httperror]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

@end
