//
//  EazeHomeViewController.m
//  EazeSportz
//
//  Created by Gil on 3/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeHomeViewController.h"
#import "EazeHomeTableViewCell.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzRetrieveCoaches.h"
#import "EazesportzRetrieveGames.h"
#import "EazesportzRetrieveTeams.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzRetrieveAlerts.h"
#import "EazesportzRetrieveNews.h"
#import "Newsfeed.h"
#import "EazeNewsViewController.h"
#import "EazeFootballGameSummaryViewController.h"
#import "EazeBasketballGameSummaryViewController.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "EazesportzRetrieveFeaturedVideosController.h"
#import "EazesportzRetrieveFeaturedPhotos.h"
#import "EazeFeaturedPhotosViewController.h"
#import "EazeEventViewController.h"
#import "EditTeamViewController.h"
#import "EazesportzCheckAdImageViewController.h"
#import "FindSiteViewController.h"
#import "EazesportzSendNotificationData.h"
#import "EazesportzLacrosseGameSummaryViewController.h"
#import "EazesportzWaterPoloGameSummaryViewController.h"
#import "EazesportzWaterPoloGameSummaryStatsViewController.h"
#import "EazesportzHockeyGameSummaryViewController.h"

#import "Reachability.h"

@interface EazeHomeViewController () <UIAlertViewDelegate>

@end

@implementation EazeHomeViewController {
    EazesportzRetrieveTeams *getTeams;
    EazesportzRetrieveNews *getNews;
    Newsfeed *newsitem;
    GameSchedule *game;
    BOOL editTeam, gotgamelist, netok;
    EazesportzCheckAdImageViewController *adController;
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
    getTeams = [[EazesportzRetrieveTeams alloc] init];
    getNews = [[EazesportzRetrieveNews alloc] init];
    _activityIndicator.hidesWhenStopped = YES;
    netok = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.tabBarController.tabBar.hidden = NO;
    _adContainer.hidden = YES;
    [_activityIndicator stopAnimating];
    _teamPicker.hidden = YES;
    
    if (currentSettings.sponsors.sponsors.count == 0)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSponsors:) name:@"SponsorListChangedNotification" object:nil];
    else {
        _adContainer.hidden = NO;
        [adController viewWillAppear:YES];
    }
        
    if (currentSettings.team.teamid.length > 0) {
        if (currentSettings.teams.count > 1)
            _changeTeamButton.enabled = YES;
        else {
            _changeTeamButton.enabled = NO;
        }
        
        if ([getNews retrieveNewsSynchronous:currentSettings.sport Team:currentSettings.team User:currentSettings.user].count > 0)
            newsitem = [getNews.news objectAtIndex:0];
        else
            newsitem = nil;
        
    } else if (currentSettings.sport.id.length > 0) {
        if (currentSettings.teams.count > 1) {
            _teamPicker.hidden = NO;
            [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
            [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:NO];
            [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:NO];
            [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:NO];
            _changeTeamButton.enabled = YES;
            [_teamPicker reloadAllComponents];
        } else if (currentSettings.teams.count == 1) {
            currentSettings.team = [currentSettings.teams objectAtIndex:0];
            _changeTeamButton.enabled = NO;
            [self teamSelected];
        } else {
            [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
            [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:NO];
            [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:NO];
            [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:[NSString stringWithFormat:@"No Teams entered yet for %@. \nSelect '+' to add a team!",
                                                                 currentSettings.sport.sitename]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            currentSettings.gameList = nil;
            newsitem = nil;
        }
    } else {
        _changeTeamButton.enabled = NO;
    }

    if (currentSettings.isSiteOwner) {
        if (currentSettings.teams.count > 0)
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addTeamButton, self.editTeamButton, self.changeTeamButton, nil];
        else
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addTeamButton, nil];
    } else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.changeTeamButton, nil];
    
    self.navigationController.toolbarHidden = YES;
    
    [_homeTableView reloadData];
    
    editTeam = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (netok) {
        if (([currentSettings.user loggedIn]) && (currentSettings.user.adminsite.length == 0) && (currentSettings.user.admin)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You must define your site before continuing"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        } else if (currentSettings.firstuse) {
            [self performSegueWithIdentifier:@"WelcomeSegue" sender:self];
        } else if (currentSettings.changesite) {
            [self performSegueWithIdentifier:@"FindSiteSegue" sender:self];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotGames:) name:@"GameListChangedNotification" object:nil];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *reach = [note object];
    
    if ([reach isReachable]) {
        netok = YES;
        
        if ((currentSettings.sport.id.length == 0) || (currentSettings.team.teamid.length == 0))
            NSLog(@"user.admin%d", currentSettings.user.admin);
            NSLog(@"user.adminsite=%@", currentSettings.user.adminsite);
            
            if (currentSettings.firstuse) {
                [self performSegueWithIdentifier:@"WelcomeSegue" sender:self];
            } else if (([currentSettings.user loggedIn]) && (currentSettings.user.admin) && (currentSettings.user.adminsite.length == 0)) {
                [self performSegueWithIdentifier:@"ProgramInfoSegue" sender:self];
            } else if ((currentSettings.changesite) || (![[NSUserDefaults standardUserDefaults] objectForKey:@"currentsite"])) {
                [self performSegueWithIdentifier:@"FindSiteSegue" sender:self];
            } else {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotGames:) name:@"GameListChangedNotification" object:nil];
            }
            
            [self viewWillAppear:YES];
    } else {
        netok = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Network connectivity lost!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)gotSponsors:(NSNotification *)notification {
    if (currentSettings.sponsors.sponsors.count > 0) {
        adController.sponsor = nil;
        [adController viewWillAppear:YES];
        _adContainer.hidden = NO;
    }
}

- (void)closeAdSponsor:(UIStoryboardSegue *)segue {
    _adContainer.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (currentSettings.team.teamid.length == 0)
  //      return 0;
    if (currentSettings.sport.enablelive)
        return 6;
    else
        return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HomeTableViewCell";
    EazeHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.homeTableCellTitle.numberOfLines = 2;
    cell.homeTableCellText.numberOfLines = 2;
    
    switch (indexPath.row) {
            
        case 0:
            cell.backgroundColor = [UIColor whiteColor];
            if (currentSettings.team.teamid.length > 0) {
                cell.homeTableCellImage.image = [currentSettings.team getImage:@"thumb"];
                cell.homeTableCellTitle.text = currentSettings.sport.sitename;
                cell.homeTableCellText.text = currentSettings.team.mascot;
            } else if (currentSettings.sport.id.length > 0) {
                cell.homeTableCellImage.image = [currentSettings.sport getImage:@"thumb"];
                cell.homeTableCellTitle.text = currentSettings.sport.sitename;
                cell.homeTableCellText.text = @"";
            } else {
                cell.homeTableCellTitle.text = @"Welcome to GameTracker";
                cell.homeTableCellText.text = @"Select a site to contine";
            }
            break;
            
        case 1:
            cell.backgroundColor = [UIColor whiteColor];
            cell.homeTableCellImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"news_icon.JPG"], 1)];
            
            if (newsitem) {
                cell.homeTableCellTitle.text = [NSString stringWithFormat:@"News for %@", currentSettings.team.mascot];
                cell.homeTableCellText.text = newsitem.title;
            } else {
                if (currentSettings.team.teamid.length > 0)
                    cell.homeTableCellTitle.text = [NSString stringWithFormat:@"No News for %@", currentSettings.team.mascot];
                else
                    cell.homeTableCellTitle.text = @"News";
                
                cell.homeTableCellText.text = @"";
            }
            break;
            
        case 2:
            game = [self lastGame];
            cell.backgroundColor = [UIColor whiteColor];
            cell.homeTableCellImage.image = [UIImage imageNamed:@"Terrible-football-play.png"];
            
            if (game) {
                if (currentSettings.team.teamid.length > 0) {
                    cell.homeTableCellTitle.text = [NSString stringWithFormat:@"Game %@ vs %@",  currentSettings.team.mascot, game.opponent_mascot];
                    cell.homeTableCellText.text = game.game_name;
                } else  {
                    cell.homeTableCellTitle.text = @"No Team Selected";
                    cell.homeTableCellText.text = @"";
                }
            } else {
                cell.homeTableCellTitle.text = @"No games scheduled";
                cell.homeTableCellText.text = @"Contact admin with questions";
            }
            break;
            
        case 3:
            cell.backgroundColor = [UIColor whiteColor];
            cell.homeTableCellImage.image = [UIImage imageNamed:@"camera-icon-md.png"];
            cell.homeTableCellTitle.text = @"Game Photos";
            cell.homeTableCellText.text = [ NSString stringWithFormat:@"Featured photos for %@", currentSettings.team.teamid.length > 0 ?
                                           currentSettings.team.mascot : @" - No Team Selected"];
            break;
            
        case 4:
            cell.backgroundColor = [UIColor whiteColor];
            cell.homeTableCellImage.image = [UIImage imageNamed:@"sports-highlights.png"];
            cell.homeTableCellTitle.text = @"Game Highlights";
            cell.homeTableCellText.text = [ NSString stringWithFormat:@"Featured highlights for %@", currentSettings.team.teamid.length > 0 ?
                                           currentSettings.team.mascot : @" - No Team Selected"];
            break;
            
        default:
            cell.backgroundColor = [UIColor whiteColor];
            cell.homeTableCellImage.image = [UIImage imageNamed:@"videoicon.jpg"];
            cell.homeTableCellTitle.text = @"Live Video";
            cell.homeTableCellText.text = @"Broadcast Schedule";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentSettings.team.teamid.length > 0) {
        switch (indexPath.row) {
                
            case 0:
                if (currentSettings.roster)
                    [self performSegueWithIdentifier:@"RosterSegue" sender:self];
                break;
                
            case 1:
//                if (currentSettings.gameList.count > 0)
                if (gotgamelist)
                    [self performSegueWithIdentifier:@"NewsInfoSegue" sender:self];
                break;
                
            case 2:
                if (game) {
                    if ([currentSettings.sport.name isEqualToString:@"Football"])
                        [self performSegueWithIdentifier:@"FootballGameInfoSegue" sender:self];
                    else if ([currentSettings.sport.name isEqualToString:@"Basketball"])
                        [self performSegueWithIdentifier:@"BasketballGameInfoSegue" sender:self];
                    else if ([currentSettings.sport.name isEqualToString:@"Soccer"])
                        [self performSegueWithIdentifier:@"SoccerGameInfoSegue" sender:self];
                    else if ([currentSettings.sport.name isEqualToString:@"Lacrosse"])
                        [self performSegueWithIdentifier:@"LacrosseGameInfoSegue" sender:self];
                    else if ([currentSettings.sport.name isEqualToString:@"Water Polo"]) {
                        UIViewController *mainViewController = [[UIStoryboard storyboardWithName:@"WaterPolo" bundle:nil] instantiateInitialViewController];
                        
                        [self.navigationController presentViewController:mainViewController animated:YES completion:nil];
//                        [self performSegueWithIdentifier:@"WaterPoloGameSummarySegue" sender:self];
                    } else if ([currentSettings.sport.name isEqualToString:@"Hockey"])
                        [self performSegueWithIdentifier:@"HockeyGameSummary" sender:self];
                }
                break;
                
            case 3:
                if (currentSettings.teamPhotos.featuredphotos.count > 0)
                    [self performSegueWithIdentifier:@"FeaturedPhotosSegue" sender:self];
                break;
                
            case 4:
                if (currentSettings.teamVideos.featuredvideos.count > 0)
                    [self performSegueWithIdentifier:@"FeaturedVideosSegue" sender:self];
                break;
                
            default:
                if ((currentSettings.sport.enablelive) && (currentSettings.user.userid.length > 0))
                    [self performSegueWithIdentifier:@"BroadcastEventsSegue" sender:self];
                else if (currentSettings.user.userid.length == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You must log in to view live events." delegate:nil
                                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert setAlertViewStyle:UIAlertViewStyleDefault];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:[NSString stringWithFormat:@"%@ does not support live events", currentSettings.team.team_name]
                                                    delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert setAlertViewStyle:UIAlertViewStyleDefault];
                    [alert show];
                }
                break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewsInfoSegue"]) {
        EazeNewsViewController *destController = segue.destinationViewController;
        destController.news = getNews.news;
    } else if ([segue.identifier isEqualToString:@"FootballGameInfoSegue"]) {
        EazeFootballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"BasketballGameInfoSegue"]) {
        EazeBasketballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"SoccerGameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"LacrosseGameInfoSegue"]) {
        EazesportzLacrosseGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"WaterPoloGameSummarySegue"]) {
        EazesportzWaterPoloGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"HockeyGameSummary"]) {
        EazesportzHockeyGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"FeaturedPhotosSegue"]) {
        EazeFeaturedPhotosViewController *destController = segue.destinationViewController;
        destController.photos = currentSettings.teamPhotos.featuredphotos;
    } else if ([segue.identifier isEqualToString:@"BroadcastEventsSegue"]) {
        EazeEventViewController *destController = segue.destinationViewController;
        destController.sport = currentSettings.sport;
        destController.team = currentSettings.team;
        destController.user = currentSettings.user;
    } else if ([segue.identifier isEqualToString:@"EditTeamSegue"]) {
        EditTeamViewController *destController = segue.destinationViewController;
        if (editTeam)
            destController.team = currentSettings.team;
        else
            destController.team = nil;
    } else if ([segue.identifier isEqualToString:@"AdSegue"] ) {
        adController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"FindSiteSegue"]) {
        FindSiteViewController *destController = segue.destinationViewController;
        destController.findsite = NO;
    }
}

- (IBAction)changeTeamButtonClicked:(id)sender {
    _teamPicker.hidden = NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    return currentSettings.teams.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[currentSettings.teams objectAtIndex:row] team_name];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentSettings.team = [currentSettings.teams objectAtIndex:row];
    [self teamSelected];
}

- (void)teamSelected {
    _changeTeamButton.enabled = YES;
    _teamPicker.hidden = YES;
    [_activityIndicator startAnimating];
    
    [[[EazesportzSendNotificationData alloc] init] sendNotificationData:currentSettings.sport Team:currentSettings.team Athlete:nil User:currentSettings.user];
    
    [currentSettings.visitingteams retrieveVisitingTeams:currentSettings.sport User:currentSettings.user];
    currentSettings.opponentimages = [[NSMutableArray alloc] init];
    currentSettings.rosterimages = [[NSMutableArray alloc] init];
    [currentSettings.inventorylist retrieveSportadinv:currentSettings.sport User:currentSettings.user];
    [currentSettings.sponsors retrieveSponsors:currentSettings.sport.id Token:currentSettings.user.authtoken];
    [[[EazesportzRetrieveGames alloc] init] retrieveGames:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [currentSettings.coaches retrieveCoaches:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [currentSettings.teamVideos retrieveFeaturedVideos:currentSettings.sport.id Token:currentSettings.user.authtoken];
    [currentSettings.teamPhotos retrieveFeaturedPhotos:currentSettings.sport.id Token:currentSettings.user.authtoken];
    
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:YES];
    [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:YES];

    [self viewWillAppear:YES];
}

- (GameSchedule *)lastGame {
    GameSchedule *agame = nil;
    
    if (currentSettings.gameList.count > 0) {
        NSDate *date = [[NSDate alloc] init];
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([[[currentSettings.gameList objectAtIndex:i] gamedatetime] compare:date] == NSOrderedAscending) {
                agame = [currentSettings.gameList objectAtIndex:i];
            }
        }
        
        if ((!agame) && (currentSettings.gameList.count > 0)) {
            agame = [currentSettings.gameList objectAtIndex:0];
        }
    }
    
    return agame;
}


- (void)gotGames:(NSNotification *)notification {
    [_activityIndicator stopAnimating];
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        gotgamelist = YES;
        [_homeTableView reloadData];
    } else {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieving game data. Check your internet connection"
                                                           delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Refresh", nil];
        [errorView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Refresh"]) {
        [self teamSelected];
    } else if ([title isEqualToString:@"Ok"]) {
        [self performSegueWithIdentifier:@"ProgramInfoSegue" sender:self];
    }
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)addTeamButtonClicked:(id)sender {
    editTeam = NO;
    [self performSegueWithIdentifier:@"EditTeamSegue" sender:self];
}

- (IBAction)editTeamButtonClicked:(id)sender {
    editTeam = YES;
    [self performSegueWithIdentifier:@"EditTeamSegue" sender:self];
}

@end
