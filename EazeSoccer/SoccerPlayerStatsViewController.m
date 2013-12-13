//
//  SoccerPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "SoccerPlayerStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "SoccerPlayerStatsTableCell.h"
#import "LiveSoccerStatsViewController.h"
#import "UpdateSoccerTotalsViewController.h"

@interface SoccerPlayerStatsViewController ()

@end

@implementation SoccerPlayerStatsViewController {
    LiveSoccerStatsViewController *liveStatsController;
    UpdateSoccerTotalsViewController *totalStatsController;
}

@synthesize game;
@synthesize athlete;
@synthesize goalies;

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
    _infoImage.image = [currentSettings getBannerImage];
    _periodTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorCKTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorSavesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorShotsTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _soccerStatsContainer.hidden = YES;
    _totalStatsContainer.hidden = YES;
    
    if (game) {
        self.title = game.game_name;
        _finalButton.enabled = YES;
        _finalButton.hidden = NO;
        
        if (game.gameisfinal)
            _finalLabel.hidden = NO;
        else
            _finalLabel.hidden = YES;
        
        _clockLabel.text = game.currentgametime;
        _homeImageView.image = [currentSettings.team getImage:@"tiny"];
        _visitorImageView.image = [game opponentImage];
        
        _homeTeamLabel.text = currentSettings.team.mascot;
        _visitorTeamLabel.text = game.opponent_mascot;
        _homeScoreLabel.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
        _visitorScoreLabel.text = [game.opponentscore stringValue];
        _periodTextField.text = [game.period stringValue];
        _visitorShotsLabel.text = [game.socceroppsog stringValue];
        _visitorCKLabel.text = [game.socceroppck stringValue];
        _visitorSavesLabel.text = [game.socceroppsaves stringValue];
        
        _homeCKLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeCK]];
        _homeSavesLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeSaves]];
        _homeShotsLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeShots]];
    } else if (athlete)
        self.title = athlete.full_name;
    else {
        self.title = @"Select a game to enter stats!";
        _finalButton.enabled = NO;
        _finalButton.hidden = YES;
        _finalLabel.hidden = YES;
    }
    
    if ((game) || (athlete)) {
        [_soccerPlayerStatsTableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (game)
        return 2;
    else if (athlete) {
        if ([athlete isSoccerGoalie])
            return 2;
        else
            return 1;
    } else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (game) {
        if (section == 0)
            return currentSettings.roster.count + 1;
        else {
           goalies = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < currentSettings.roster.count; i++) {
                Athlete *aplayer = [currentSettings.roster objectAtIndex:i];
                if ([aplayer isSoccerGoalie]) {
                    [goalies addObject:aplayer];
                }
            }
            return goalies.count + 1;
        }
    } else if (athlete) {
        if (section == 0)
            return currentSettings.gameList.count + 1;
        else if ([athlete isSoccerGoalie]) {
            return currentSettings.gameList.count + 1;
        } else {
            return 0;
        }
    } else if (section == 0) {
        return currentSettings.roster.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SoccerStatsTableCell";
    SoccerPlayerStatsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Soccer *stats;
    
    if (indexPath.section == 0) {
        
        if (game) {
            if (indexPath.row < currentSettings.roster.count) {
                Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
                cell.playerName.text = player.numberLogname;
                stats = [player findSoccerGameStats:game.id];
                cell.imageView.image = [player getImage:@"tiny"];
            } else {
                cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
                cell.playerName.text = @"Totals";
                stats = [[Soccer alloc] init];
                
                int goals = 0, shots = 0, assists = 0, steals = 0, cornerkicks = 0;
                    
                for (int i = 0; i < currentSettings.roster.count; i++) {
                    Soccer *astat = [[currentSettings.roster objectAtIndex:i] findSoccerGameStats:game.id];
                    goals += [astat.goals intValue];
                    shots += [astat.shotstaken intValue];
                    assists += [astat.assists intValue];
                    steals += [astat.steals intValue];
                    cornerkicks += [astat.cornerkicks intValue];
                }
            }
        } else if (athlete) {
            if (indexPath.row < currentSettings.gameList.count) {
                GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
                cell.playerName.text = agame.opponent;
                stats = [athlete findSoccerGameStats:agame.id];
                cell.imageView.image = [agame opponentImage];
            } else {
                cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
                cell.playerName.text = @"Totals";
                stats = [[Soccer alloc] init];
                
                int goals = 0, shots = 0, assists = 0, steals = 0, cornerkicks = 0;
                
                for (int i = 0; i < currentSettings.gameList.count; i++) {
                    Soccer *astat = [athlete findSoccerGameStats:[[currentSettings.gameList objectAtIndex:i] id]];
                    goals += [astat.goals intValue];
                    shots += [astat.shotstaken intValue];
                    assists += [astat.assists intValue];
                    steals += [astat.steals intValue];
                    cornerkicks += [astat.cornerkicks intValue];
                }
            }
        } else {
            Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
            cell.playerName.text = player.numberLogname;
            stats = [[Soccer alloc] init];
            cell.imageView.image = [player getImage:@"tiny"];
        }
        
        cell.label1.text = [stats.goals stringValue];
        cell.label2.text = [stats.shotstaken stringValue];
        cell.label3.text = [stats.assists stringValue];
        cell.label4.text = [stats.steals stringValue];
        cell.label5.text = [stats.cornerkicks stringValue];
        cell.label6.text = [NSString stringWithFormat:@"%d", ([stats.goals intValue] * 2) + [stats.assists intValue]];
    } else {
        if (game) {
            if (indexPath.row < goalies.count) {
                Athlete *player = [goalies objectAtIndex:indexPath.row];
                cell.playerName.text = player.numberLogname;
                stats = [player findSoccerGameStats:game.id];
                cell.imageView.image = [player getImage:@"tiny"];
            } else {
                cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
                cell.playerName.text = @"Totals";
                stats = [[Soccer alloc] init];
                
                int goalssaved = 0, goalsagainst = 0, minutesplayed = 0;
                
                for (int i = 0; i < goalies.count; i++) {
                    Soccer *astat = [[goalies objectAtIndex:i] findSoccerGameStats:game.id];
                    goalsagainst += [astat.goalsagainst intValue];
                    goalssaved += [astat.goalssaved intValue];
                    minutesplayed += [astat.minutesplayed intValue];
                }
            }
        } else {
            if (indexPath.row < currentSettings.gameList.count) {
                GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
                cell.playerName.text = agame.opponent;
                stats = [athlete findSoccerGameStats:agame.id];
                cell.imageView.image = [agame opponentImage];
            } else {
                cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
                cell.playerName.text = @"Totals";
                stats = [[Soccer alloc] init];
                
                int goalssaved = 0, goalsagainst = 0, minutesplayed = 0;
                
                for (int i = 0; i < currentSettings.gameList.count; i++) {
                    Soccer *astat = [athlete findSoccerGameStats:[[currentSettings.gameList objectAtIndex:i] id]];
                    goalsagainst += [astat.goalsagainst intValue];
                    goalssaved += [astat.goalssaved intValue];
                    minutesplayed += [astat.minutesplayed intValue];
                }
            }
        }

        cell.label1.text = [stats.goalssaved stringValue];
        cell.label2.text = [stats.goalsagainst stringValue];
        cell.label3.text = @"";
        cell.label4.text = [stats.minutesplayed stringValue];
        cell.label5.text = @"";
        cell.label6.text = @"";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (game)
            return @"               Player                  Goals     Shots    Assists   Steals       C/K      Points";
        else
            return @"               Game                    Goals     Shots    Assists   Steals       C/K      Points";
    } else {
        if (game)
            return @"               Goalie                  Saves    Goals Against      Minutes";
        else
            return @"Goalie Stats for Game     Saves    Goals Against      Minutes";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (game) {
        if (indexPath.section == 0) {
            if (indexPath.row < currentSettings.roster.count) {
                liveStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
                _soccerStatsContainer.hidden = NO;
                liveStatsController.game = game;
                [liveStatsController viewWillAppear:YES];
            }
        } else {
            if (indexPath.row < goalies.count) {
                liveStatsController.player = [goalies objectAtIndex:indexPath.row];
                _soccerStatsContainer.hidden = NO;
                liveStatsController.game = game;
                [liveStatsController viewWillAppear:YES];
            }
        }
        
    } else if (athlete) {
        if (indexPath.row < currentSettings.gameList.count) {
            liveStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
            liveStatsController.player = athlete;
            _soccerStatsContainer.hidden = NO;
            [liveStatsController viewWillAppear:YES];
            liveStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"  message:@"Select game to update stats for player!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            totalStatsController.soccerstats = [[currentSettings.roster objectAtIndex:indexPath.row] findSoccerGameStats:game.id];
            totalStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        } else {
            totalStatsController.soccerstats = [[goalies objectAtIndex:indexPath.row] findSoccerGameStats:game.id];
            totalStatsController.player = [goalies objectAtIndex:indexPath.row];
        }
        [totalStatsController viewWillAppear:YES];
        _totalStatsContainer.hidden = NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Enter Totals";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SoccerPlayerStatsSegue"]) {
        liveStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"SoccerStatTotalsSegue"]) {
        totalStatsController = segue.destinationViewController;
    } else {
        NSIndexPath *indexPath = [_soccerPlayerStatsTableView indexPathForSelectedRow];
        
        if (indexPath.section == 0) {
            
        } else {
            
        }
    }
}

- (IBAction)liveSoccerPlayerStats:(UIStoryboardSegue *)segue {
    [liveStatsController.player updateSoccerGameStats:liveStatsController.playerStats];
    _soccerStatsContainer.hidden = YES;
//    [_soccerPlayerStatsTableView reloadData];
    [self viewWillAppear:YES];
}

- (IBAction)updateTotalSoccerStats:(UIStoryboardSegue *)segue {
    [totalStatsController.player updateSoccerGameStats:totalStatsController.soccerstats];
    _totalStatsContainer.hidden = YES;
    [_soccerPlayerStatsTableView reloadData];
}

- (IBAction)saveButtonClicked:(id)sender {
    if (game) {
        for (int cnt = 0; cnt < currentSettings.roster.count; cnt++) {
            if (![[currentSettings.roster objectAtIndex:cnt] saveSoccerGameStats:game.id]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"%@%@", @"Update failed for  ", [[currentSettings.roster objectAtIndex:cnt] logname]]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    } else {
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if (![athlete saveSoccerGameStats:[[currentSettings.gameList objectAtIndex:i] id]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"%@%@", @"Update failed for  ", [athlete logname]]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    }
    
    game.socceroppck = [NSNumber numberWithInt:[_visitorCKTextField.text intValue]];
    game.socceroppsaves = [NSNumber numberWithInt:[_visitorSavesTextField.text intValue]];
    game.socceroppsog = [NSNumber numberWithInt:[_visitorShotsTextfield.text intValue]];
    game.currentgametime = _clockLabel.text;
    game.period = [NSNumber numberWithInt:[_periodTextField.text intValue]];
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    
    [game saveGameschedule];
    
/*    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stats Posted!"
                                                    message:[NSString stringWithFormat:@"%@%@%@", @"Stats for current players vs. ", game.opponent, @" saved!"]
                                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show]; */
}

- (IBAction)finalButtonClicked:(id)sender {
    if (_finalLabel.hidden) {
        _finalLabel.hidden = NO;
        game.gameisfinal = YES;
    } else {
        _finalLabel.hidden = YES;
        game.gameisfinal = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _periodTextField) {
        NSString *validRegEx =@"^[0-4.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            return (newLength > 1) ? NO : YES;
        } else
            return NO;
    } else {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            
            if ((textField == _minutesTextField) || (textField == _secondsTextField)) {
                return (newLength > 2) ? NO : YES;
            } else
                return (newLength > 1) ? NO : YES;
        } else
            return  NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((textField == _minutesTextField) || (textField == _secondsTextField))
        _clockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
    else if (textField == _visitorShotsTextfield)
        _visitorShotsLabel.text = _visitorShotsTextfield.text;
    else if (textField == _visitorScoreTextField)
        _visitorScoreLabel.text = _visitorScoreTextField.text;
    else if (textField == _visitorSavesTextField)
        _visitorSavesLabel.text = _visitorSavesTextField.text;
    else if (textField == _visitorCKTextField)
        _visitorCKLabel.text = _visitorCKTextField.text;
}

@end
