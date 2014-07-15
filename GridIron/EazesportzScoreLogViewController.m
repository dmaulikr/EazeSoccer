//
//  EazesportzScoreLogViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/3/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzScoreLogViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzScoreLogViewController ()

@end

@implementation EazesportzScoreLogViewController {
    NSArray *scores;
}

@synthesize game;
@synthesize lacrosse_score;
@synthesize soccer_score;

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
    
    if ([currentSettings.sport.name isEqualToString:@"Lacrosse"])
        scores = [game.lacross_game getLacrosseScores:YES];
    else
        scores = [game.soccer_game getSoccerScores:YES];
    
    [_scorelogTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScoreLogTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    cell.textLabel.text = [[scores objectAtIndex:indexPath.row] getScoreLog];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Score Log";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
        return  NO;
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings.sport.name isEqualToString:@"Lacrosse"]) {
        lacrosse_score = [scores objectAtIndex:indexPath.row];
        soccer_score = nil;
    } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        soccer_score = [scores objectAtIndex:indexPath.row];
        lacrosse_score = nil;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_scorelogTableView indexPathForSelectedRow];
    
    lacrosse_score = nil;
    soccer_score = nil;
    
    if (indexPath.length > 0) {
        if ([currentSettings.sport.name isEqualToString:@"Lacrosse"])
            lacrosse_score = [scores objectAtIndex:indexPath.row];
        else
            soccer_score = [scores objectAtIndex:indexPath.row];
    }
}

@end
