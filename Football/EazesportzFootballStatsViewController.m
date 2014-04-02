//
//  EazesportzFootballStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/21/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzFootballStatsTableViewCell.h"
#import "EazesportzFootballPassingTotalsViewController.h"
#import "EazesportzFootballRushingTotalsViewController.h"
#import "EazesportzGameLogViewController.h"
#import "PlayerSelectionViewController.h"
#import "EazesportzFootballDefenseTotalsViewController.h"
#import "EazesportzFootballPlaceKickerTotalsViewController.h"
#import "EazesportzFootballKickerTotalsViewController.h"
#import "EazesportzFootballPunterTotalsViewController.h"
#import "EazesportzFootballReturnerTotalsViewController.h"
#import "EazesportzFootballReceivingTotalsViewController.h"
#import "EditGameViewController.h"
#import "Gamelogs.h"
#import "EazesportzFootballTotalsViewController.h"


@interface EazesportzFootballStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzFootballStatsViewController {
    BOOL offense, defense, specialteams;
    
    NSMutableArray *qbs, *rbs, *wrs, *defenselist, *pks, *kickerlist, *returnerlist, *punterlist;
    BOOL qb, rb, wr, pk, punter, kicker, returner, completion;
    NSString *quarter;
    
    PlayerSelectionViewController *playerController;
    EazesportzGameLogViewController *gamelogController;

    NSMutableArray *footballRB, *footballQB, *footballWR, *footballOL, *footballDEF, *footballPK, *footballK, *footballPUNT, *footballRET;
    
    BOOL minuspenalty, addstats, touchdown, safety, twopoint, interception, fumblerecovered, fieldgoal, xpmade, puntreturn, koreturn;
    Athlete *receiver;
}

@synthesize athlete;
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
    offense = YES;
    defense = NO;
    specialteams = NO;
    
    _togoTextField.keyboardType = UIKeyboardTypeNumberPad;
    _downTextField.keyboardType = UIKeyboardTypeNumberPad;
    _ballonTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTimeOutsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _quarterTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeTimeOutsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTimeOutsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _penaltyYardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _yardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _yardsLostTextField.keyboardType = UIKeyboardTypeNumberPad;
    _quarterStatTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesStatTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsStatTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _receiverTextField.inputView = playerController.inputView;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.saveButton, self.editButton, nil];
    
    self.navigationController.toolbarHidden = YES;
    
    footballWR = [[NSMutableArray alloc] init];
    footballQB = [[NSMutableArray alloc] init];
    footballRB = [[NSMutableArray alloc] init];
    footballOL = [[NSMutableArray alloc] init];
    footballDEF = [[NSMutableArray alloc] init];
    footballK = [[NSMutableArray alloc] init];
    footballPK = [[NSMutableArray alloc] init];
    footballPUNT = [[NSMutableArray alloc] init];
    footballRET = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rosterChanged:) name:@"RosterChangedNotification" object:nil];
    
    qbs = [[NSMutableArray alloc] initWithArray:currentSettings.footballQB];
    rbs = [[NSMutableArray alloc] initWithArray:currentSettings.footballRB];
    wrs = [[NSMutableArray alloc] initWithArray:currentSettings.footballWR];
    defenselist = [[NSMutableArray alloc] initWithArray:currentSettings.footballDEF];
    pks = [[NSMutableArray alloc] initWithArray:currentSettings.footballPK];
    punterlist = [[NSMutableArray alloc] initWithArray:currentSettings.footballPUNT];
    kickerlist = [[NSMutableArray alloc] initWithArray:currentSettings.footballK];
    returnerlist = [[NSMutableArray alloc] initWithArray:currentSettings.footballRET];
    
    if (!athlete)
        qb = NO, rb = NO, wr = NO, pk = NO, kicker= NO, punter = NO, returner = NO;
    
    addstats = YES;
    touchdown = twopoint = safety = interception = fumblerecovered = koreturn = puntreturn = NO;
    
    for (int cnt = 0; cnt < currentSettings.roster.count; cnt++) {
        Athlete *player = [currentSettings.roster objectAtIndex:cnt];
        
        if (![qbs containsObject:player]) {
            if ([player isQB:nil])
                [qbs addObject:player];
            else if ([player isQB:game.id])
                [qbs addObject:player];
        }
        
        if (![rbs containsObject:player]) {
            if ([player isRB:nil])
                [rbs addObject:player];
            else if ([player isRB:game.id])
                [rbs addObject:player];
        }
        
        if (![wrs containsObject:player]) {
            if ([player isWR:nil])
                [wrs addObject:player];
            else if ([player isWR:game.id])
                [wrs addObject:player];
        }
        
        if (![defenselist containsObject:player]) {
            if ([player isDEF:nil])
                [defenselist addObject:player];
            else if ([player isDEF:game.id])
                [defenselist addObject:player];
        }
        
        if (![pks containsObject:player]) {
            if ([player isPK:nil])
                [pks addObject:player];
            else if ([player isPK:game.id])
                [pks addObject:player];
        }
        
        if (![punterlist containsObject:player]) {
            if ([player isPunter:nil])
                [punterlist addObject:player];
            else if ([player isPunter:game.id])
                [punterlist addObject:player];
        }
        
        if (![returnerlist containsObject:player]) {
            if ([player isReturner:nil])
                [returnerlist addObject:player];
            else if ([player isReturner:game.id])
                [returnerlist addObject:player];
        }
        
        if (![kickerlist containsObject:player]) {
            if ([player isKicker:nil])
                [kickerlist addObject:player];
            else if ([player isKicker:game.id])
                [kickerlist addObject:player];
        }
    }

    if (game) {
         _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats vs. ", game.opponent_name];
        _lastplayLabel.text = game.lastplay;
        _gameClockLabel.text = game.currentgametime;
        NSArray *timearray = [game.currentgametime componentsSeparatedByString:@":"];
        _minutesTextField.text = timearray[0];
        _secondsTextField.text = timearray[1];
        _homeImageView.image = [currentSettings.team getImage:@"tiny"];
        _visitorImageView.image = [game opponentImage];
        _homeLabel.text = currentSettings.team.mascot;
        _visitorLabel.text = game.opponent;
        _visitorScoreLabel.text = [game.opponentscore stringValue];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
        _penaltyYardsLabel.text = [NSString stringWithFormat:@"%d%@%d", [game.penalty intValue], @"/", [game.penaltyyards intValue]];
        _penaltyYardsTextField.hidden = YES;

        _homeScoreLabel.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];

        _homeTimeOutsTextField.text = [game.hometimeouts stringValue];
        _visitorTimeOutsTextField.text = [game.opponenttimeouts stringValue];
        _ballonTextField.text = [game.ballon stringValue];
        _downTextField.text = [game.down stringValue];
        _togoTextField.text = [game.togo stringValue];
        _quarterTextField.text = [game.period stringValue];

        if (!game.gameisfinal) {
            _finalLabel.hidden = YES;
        }
        
        [_homeMascotButton setTitle:currentSettings.team.mascot forState:UIControlStateNormal];
        [_visitorMascotButton setTitle:game.opponent_mascot forState:UIControlStateNormal];
        
        if ([game.possession isEqualToString:currentSettings.team.mascot]) {
            _homePossessionImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"footballpossessionimage.png"], 1)];
            _visitorPossessionImage.hidden = YES;
            _homePossessionImage.hidden = NO;
        } else {
            _visitorPossessionImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"footballpossessionimage.png"], 1)];
            _homePossessionImage.hidden = YES;
            _visitorPossessionImage.hidden = NO;
        }

         _finalButton.enabled = YES;
        _finalButton.hidden = NO;

        [self displayStats];

        [_statsTableView reloadData];
    } else if (athlete)
        _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats for ", athlete.logname];
    else {
        _statLabel.text = @"Select game to enter stats";
        _finalLabel.hidden = YES;
        _finalButton.enabled = NO;
        _finalButton.hidden = YES;
    }

    _playerSelectContainer.hidden = YES;
    _gamelogContainer.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)rosterChanged:(NSNotification *)notification {
    [_statsTableView reloadData];
}

- (IBAction)offenseButtonClicked:(id)sender {
    offense = YES;
    defense = NO;
    specialteams = NO;
    [_statsTableView reloadData];
}

- (IBAction)defenseButtonClicked:(id)sender {
    offense = NO;
    defense = YES;
    specialteams = NO;
    [_statsTableView reloadData];
}

- (IBAction)specialteamsButtonClicked:(id)sender {
    offense = NO;
    defense = NO;
    specialteams = YES;
    [_statsTableView reloadData];
}

- (IBAction)savestatsButtonClicked:(id)sender {
    game.period = [NSNumber numberWithInt:[_quarterTextField.text intValue]];
    game.togo = [NSNumber numberWithInt:[_togoTextField.text intValue]];
    game.down = [NSNumber numberWithInt:[_downTextField.text intValue]];
    game.ballon = [NSNumber numberWithInt:[_ballonTextField.text intValue]];
    game.period = [NSNumber numberWithInt:[_quarterTextField.text intValue]];
    game.hometimeouts = [NSNumber numberWithInt:[_homeTimeOutsTextField.text intValue]];
    game.opponenttimeouts = [NSNumber numberWithInt:[_visitorTimeOutsTextField.text intValue]];
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    game.currentgametime = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
    [game saveGameschedule];
    
    [self viewWillAppear:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (offense)
        return 3;
    else if (specialteams) {
        return 4;
    } else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (offense) {
        if (section == 0) {
             return qbs.count + 1;
        } else if (section == 1)
            return rbs.count + 1;
        else
            return wrs.count + 1;
//        else
//            return currentSettings.footballOL.count;
    } else if (specialteams) {
        if (section == 0)
            return pks.count + 1;
        else if (section == 1)
            return kickerlist.count + 1;
        else if (section == 2)
             return punterlist.count + 1;
       else
            return returnerlist.count + 1;
    } else {
        return defenselist.count + 1;
    }
}

- (void)displayImage:(Athlete *)player Cell:(UITableViewCell *)cell Row:(NSIndexPath *)indexPath {
    if ([currentSettings getRosterTinyImage:player] == nil) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:player.tinypic]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell.tag == indexPath.row) {
                    cell.imageView.image = [UIImage imageWithData:image];
                    [cell setNeedsLayout];
                }
            });
        });
    } else {
        [cell.imageView setImage:[currentSettings getRosterTinyImage:player]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *acell = [tableView dequeueReusableCellWithIdentifier:@"PlayerTableCell" forIndexPath:indexPath];
    
    if (acell == nil) {
        acell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlayerTableCell"];
    }
    
    Athlete *player;
    
    acell.tag = indexPath.row;
    
    
    if (offense) {
        if (indexPath.section == 0) {
            if (indexPath.row < qbs.count) {
                player = [qbs objectAtIndex:indexPath.row];
                [self displayImage:player Cell:acell Row:indexPath];
                acell.textLabel.text = [player numberLogname];
                acell.detailTextLabel.text = player.position;
            } else if (indexPath.row == (qbs.count)) {
                acell.imageView.image = [currentSettings.team teamimage];
                acell.textLabel.text = @"Add Player";
                acell.detailTextLabel.text = @"";
           }
        } else if (indexPath.section == 1) {
            if (indexPath.row < rbs.count) {
                player = [rbs objectAtIndex:indexPath.row];
                [self displayImage:player Cell:acell Row:indexPath];
                acell.textLabel.text = [player numberLogname];
                acell.detailTextLabel.text = player.position;
            } else if (indexPath.row == (rbs.count)) {
                acell.imageView.image = [currentSettings.team teamimage];
                acell.textLabel.text = @"Add Player";
                acell.detailTextLabel.text = @"";
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row < wrs.count) {
                player = [wrs objectAtIndex:indexPath.row];
                [self displayImage:player Cell:acell Row:indexPath];
                acell.textLabel.text = [player numberLogname];
                acell.detailTextLabel.text = player.position;
            } else if (indexPath.row == (wrs.count)) {
                acell.imageView.image = [currentSettings.team teamimage];
                acell.textLabel.text = @"Add Player";
                acell.detailTextLabel.text = @"";
            }
        }
    } else if (specialteams) {
        if (indexPath.section == 0) {
            if (indexPath.row < pks.count) {
                player = [pks objectAtIndex:indexPath.row];
                [self displayImage:player Cell:acell Row:indexPath];
                acell.textLabel.text = [player numberLogname];
                acell.detailTextLabel.text = player.position;
            } else {
                acell.imageView.image = [currentSettings.team teamimage];
                acell.textLabel.text = @"Add Player";
                acell.detailTextLabel.text = @"";
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row < kickerlist.count) {
                player = [kickerlist objectAtIndex:indexPath.row];
                [self displayImage:player Cell:acell Row:indexPath];
                acell.textLabel.text = [player numberLogname];
                acell.detailTextLabel.text = player.position;
            } else {
                acell.imageView.image = [currentSettings.team teamimage];
                acell.textLabel.text = @"Add Player";
                acell.detailTextLabel.text = @"";
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row < punterlist.count) {
                player = [punterlist objectAtIndex:indexPath.row];
                [self displayImage:player Cell:acell Row:indexPath];
                acell.textLabel.text = [player numberLogname];
                acell.detailTextLabel.text = player.position;
            } else {
                acell.imageView.image = [currentSettings.team teamimage];
                acell.textLabel.text = @"Add Player";
                acell.detailTextLabel.text = @"";
            }
        } else {
            if (indexPath.row < returnerlist.count) {
                player = [returnerlist objectAtIndex:indexPath.row];
                [self displayImage:player Cell:acell Row:indexPath];
                acell.textLabel.text = [player numberLogname];
                acell.detailTextLabel.text = player.position;
            } else {
                acell.imageView.image = [currentSettings.team teamimage];
                acell.textLabel.text = @"Add Player";
                acell.detailTextLabel.text = @"";
            }
        }
    } else {
        if (indexPath.row < defenselist.count) {
            player = [defenselist objectAtIndex:indexPath.row];
            [self displayImage:player Cell:acell Row:indexPath];
            acell.textLabel.text = [player numberLogname];
            acell.detailTextLabel.text = player.position;
        } else {
            acell.imageView.image = [currentSettings.team teamimage];
            acell.textLabel.text = @"Add Player";
            acell.detailTextLabel.text = @"";
        }
    }
    
    return acell;
}

- (EazesportzFootballStatsTableViewCell *)addPlayerCell:(EazesportzFootballStatsTableViewCell *)cell {
    cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
    cell.namelabel.text = @"Add Player";
    cell.label1.text = @"";
    cell.label2.text = @"";
    cell.label3.text = @"";
    cell.label4.text = @"";
    cell.label5.text = @"";
    cell.label6.text = @"";
    cell.label7.text = @"";
    cell.label8.text = @"";
    cell.label9.text = @"";
    cell.label10.text = @"";
    cell.label11.text = @"";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (offense) {
        
        if (section == 0)
            return @"                QB";
        else if (section == 1)
            return @"                Rusher";
        else
            return @"                WR";

    } else if (specialteams) {
        if (section == 0)
            return @"                Place Kicker";
        else if (section == 1)
            return @"                Kicker";
        else if (section== 2)
            return @"                Punter";
        else
            return @"                Returner";
        
    } else
        return @"                Defender";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    playerController.player = nil;
    qb = NO, rb = NO, wr = NO, pk = NO, kicker= NO, punter = NO, returner = NO;
    
    if (game) {
        if (offense) {
            if (indexPath.section == 0) {
                qb = YES;
                if (indexPath.row < qbs.count) {
                    athlete = [qbs objectAtIndex:indexPath.row];
                    [self displayStats];
                } else if (indexPath.row == (qbs.count)) {
                    _playerSelectContainer.hidden = NO;
                }
            } else if (indexPath.section == 1) {
                rb = YES;
                if (indexPath.row < rbs.count) {
                    athlete = [rbs objectAtIndex:indexPath.row];
                    [self displayStats];
                } else if (indexPath.row == (rbs.count)) {
                    _playerSelectContainer.hidden = NO;
                }
            } else {
                wr = YES;
                if (indexPath.row < wrs.count)
                    [self performSegueWithIdentifier:@"TotalsReceivingSegue" sender:self];
                else if (indexPath.row == (wrs.count)) {
                    _playerSelectContainer.hidden = NO;
                }
            }
        } else if (defense) {
            if (indexPath.row < defenselist.count) {
                athlete = [defenselist objectAtIndex:indexPath.row];
                [self displayStats];
            } else {
                _playerSelectContainer.hidden = NO;
            }
        } else {
            if (indexPath.section == 0) {
                pk = YES;
                if (indexPath.row < pks.count) {
                    athlete = [pks objectAtIndex:indexPath.row];
                    [self displayStats];
                } else if (indexPath.row == (pks.count)) {
                    _playerSelectContainer.hidden = NO;
                }
            } else if (indexPath.section == 1) {
                kicker = YES;
                if (indexPath.row < kickerlist.count) {
                    athlete = [kickerlist objectAtIndex:indexPath.row];
                    [self displayStats];
                } else if (indexPath.row == (kickerlist.count)) {
                    _playerSelectContainer.hidden = NO;
                }
            } else if (indexPath.section == 2) {
                punter = YES;
                if (indexPath.row < punterlist.count) {
                    athlete = [punterlist objectAtIndex:indexPath.row];
                    [self displayStats];
                } else if (indexPath.row == (punterlist.count)) {
                    _playerSelectContainer.hidden = NO;
                }
            } else {
                returner = YES;
                if (indexPath.row < returnerlist.count) {
                    athlete = [returnerlist objectAtIndex:indexPath.row];
                    [self displayStats];
                } else if (indexPath.row == (returnerlist.count)) {
                    _playerSelectContainer.hidden = NO;
                }
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"  message:@"Select game to update stats for player!" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"PassingStatSegue"]) {
        EazesportzFootballPassingTotalsViewController *destController = segue.destinationViewController;
        athlete = destController.player = athlete;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"RushingStatSegue"]) {
        EazesportzFootballRushingTotalsViewController *destController = segue.destinationViewController;
        destController.player = athlete;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"DefenseStatSegue"]) {
        EazesportzFootballDefenseTotalsViewController *destController = segue.destinationViewController;
        destController.player = athlete;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PlaceKickerStatSegue"]) {
        EazesportzFootballPlaceKickerTotalsViewController *destController = segue.destinationViewController;
        destController.player = athlete;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"KickerStatSegue"]) {
        EazesportzFootballKickerTotalsViewController *destController = segue.destinationViewController;
        destController.player = athlete;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PunterStatSegue"]) {
        EazesportzFootballPunterTotalsViewController *destController = segue.destinationViewController;
        destController.player = athlete;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"ReturnerStatSegue"]) {
        EazesportzFootballReturnerTotalsViewController *destController = segue.destinationViewController;
        destController.player = athlete;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"TotalsReceivingSegue"]) {
        EazesportzFootballReceivingTotalsViewController *destController = segue.destinationViewController;
        destController.player = athlete;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GamelogSelectSegue"]) {
        gamelogController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"EditGameSgeue"]) {
        EditGameViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"GameTotalsSegue"]) {
        EazesportzFootballTotalsViewController *destController = segue.destinationViewController;
        destController.game = game;
        destController.qbs = qbs;
        destController.rbs = rbs;
        destController.wrs = wrs;
        destController.returnerlist = returnerlist;
        destController.kickerlist = kickerlist;
        destController.punterlist = punterlist;
        destController.pks = pks;
        destController.defenselist = defenselist;
    }
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    if (playerController.player) {
        if (completion) {
            receiver = playerController.player;
            _receiverTextField.text = receiver.logname;
            completion = NO;
        } else if (offense) {
            if (qb) {
                if (![qbs containsObject:playerController.player]) {
                    [qbs addObject:playerController.player];
                } else {
                    [self displayPlayerAlreadyInListAlert:playerController.player];
                }
            } else if (rb) {
                if (![rbs containsObject:playerController.player]) {
                    [rbs addObject:playerController.player];
                } else {
                    [self displayPlayerAlreadyInListAlert:playerController.player];
                }
            } else if (wr) {
                if (![wrs containsObject:playerController.player]) {
                    [wrs addObject:playerController.player];
                } else {
                    [self displayPlayerAlreadyInListAlert:playerController.player];
                }
            }
        } else if (defense) {
            if (![defenselist containsObject:playerController.player]) {
                [defenselist addObject:playerController.player];
            } else {
                [self displayPlayerAlreadyInListAlert:playerController.player];
            }
        } else {
            if (pk) {
                if (![pks containsObject:playerController.player]) {
                    [pks addObject:playerController.player];
                } else {
                    [self displayPlayerAlreadyInListAlert:playerController.player];
                }
            } else if (kicker) {
                if (![kickerlist containsObject:playerController.player]) {
                    [kickerlist addObject:playerController.player];
                } else {
                    [self displayPlayerAlreadyInListAlert:playerController.player];
                }
            } else if (punter) {
                if (![punterlist containsObject:playerController.player]) {
                    [punterlist addObject:playerController.player];
                } else {
                    [self displayPlayerAlreadyInListAlert:playerController.player];
                }
            } else if (returner) {
                if (![returnerlist containsObject:playerController.player]) {
                    [returnerlist addObject:playerController.player];
                } else {
                    [self displayPlayerAlreadyInListAlert:playerController.player];
                }
            }
        }
    }
    
    _playerSelectContainer.hidden = YES;
    [_statsTableView reloadData];
}

- (void)displayPlayerAlreadyInListAlert:(Athlete *)player {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Player already in list!"
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)scoreLogButtonClicked:(id)sender {
    if (_gamelogContainer.hidden) {
        if (game) {
            _gamelogContainer.hidden = NO;
            gamelogController.game = game;
            [gamelogController viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No game selected to display scores."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        _gamelogContainer.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _visitorScoreTextField) ||
        (textField == _homeTimeOutsTextField) || (textField == _visitorTimeOutsTextField) || (textField == _quarterTextField) ||
        (textField == _downTextField) || (textField == _togoTextField) || (textField == _ballonTextField) || (textField == _penaltyYardsTextField) ||
        (textField == _minutesStatTextField) || (textField == _secondsStatTextField) || (textField == _yardsTextField) ||
        (textField == _yardsLostTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx)
            
            if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _ballonTextField) ||
                (textField == _togoTextField) || (textField == _minutesStatTextField) || (textField == _secondsStatTextField)) {
                return (newLength > 2) ? NO : YES;
            } else if ((textField == _quarterTextField) || (textField == _downTextField) || (textField == _visitorTimeOutsTextField) ||
                       (textField == _homeTimeOutsTextField)) {
                return (newLength > 1) ? NO : YES;
            } else if ((textField == _visitorScoreTextField) || (textField == _penaltyYardsTextField) || (textField == _yardsLostTextField) ||
                       (textField == _yardsTextField)) {
                return (newLength > 3 ? NO : YES);
            } else
                return NO;
        else
            return  NO;
    } else
        return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _visitorScoreTextField) {
        [textField resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opponent Score"  message:@"Update Opponents Score"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Q1", @"Q2", @"Q3", @"Q4", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else if (textField == _receiverTextField) {
        if (qb)
            completion = YES;
        [textField resignFirstResponder];
    } else {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _minutesTextField) {
        NSArray *clockentries = [_gameClockLabel.text componentsSeparatedByString:@":"];
        _gameClockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", clockentries[1]];
    } else if (textField == _secondsTextField) {
        NSArray *clockentries = [_gameClockLabel.text componentsSeparatedByString:@":"];
        _gameClockLabel.text = [NSString stringWithFormat:@"%@%@%@", clockentries[0], @":", _secondsTextField.text];
    } else if (textField == _penaltyYardsTextField) {
        if (minuspenalty) {
            minuspenalty = NO;
            game.penaltyyards = [NSNumber numberWithInt:[game.penaltyyards intValue] - [_penaltyYardsTextField.text intValue]];
        } else {
            game.penaltyyards = [NSNumber numberWithInt:[game.penaltyyards intValue] + [_penaltyYardsTextField.text intValue]];
        }

        _penaltyYardsLabel.text = [NSString stringWithFormat:@"%d%@%d", [game.penalty intValue], @"/", [game.penaltyyards intValue]];
        _penaltyYardsTextField.hidden = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Touchdown"]) {
        if ([quarter isEqualToString:@"Q1"])
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] + 6];
        else if ([quarter isEqualToString:@"Q2"])
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] + 6];
        else if ([quarter isEqualToString:@"Q3"])
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] + 6];
        else
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] + 6];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] + 6];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Delete Touchdown"]) {
        if (([quarter isEqualToString:@"Q1"]) && ([game.opponentq1 intValue] >= 6))
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] - 6];
        else if (([quarter isEqualToString:@"Q2"]) && ([game.opponentq2 intValue] >= 6))
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] - 6];
        else if (([quarter isEqualToString:@"Q3"]) && ([game.opponentq3 intValue] >= 6))
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] - 6];
        else if ([game.opponentq4 intValue] >= 6)
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] - 6];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] - 6];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Add Field Goal"]) {
        if ([quarter isEqualToString:@"Q1"])
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] + 3];
        else if ([quarter isEqualToString:@"Q2"])
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] + 3];
        else if ([quarter isEqualToString:@"Q3"])
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] + 3];
        else
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] + 3];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] + 3];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Delete Field Goal"]) {
        if (([quarter isEqualToString:@"Q1"]) && ([game.opponentq1 intValue] >= 3))
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] - 3];
        else if (([quarter isEqualToString:@"Q2"]) && ([game.opponentq1 intValue] >= 3))
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] - 3];
        else if (([quarter isEqualToString:@"Q3"]) && ([game.opponentq1 intValue] >= 3))
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] - 3];
        else if ([game.opponentq1 intValue] >= 3)
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] - 3];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] - 3];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Add Extra Point"]) {
        if ([quarter isEqualToString:@"Q1"])
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] + 1];
        else if ([quarter isEqualToString:@"Q2"])
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] + 1];
        else if ([quarter isEqualToString:@"Q3"])
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] + 1];
        else
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] + 1];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] + 1];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Delete Extra Point"]) {
        if (([quarter isEqualToString:@"Q1"]) && ([game.opponentq1 intValue] >= 1))
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] - 1];
        else if (([quarter isEqualToString:@"Q2"]) && ([game.opponentq1 intValue] >= 1))
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] - 1];
        else if (([quarter isEqualToString:@"Q3"]) && ([game.opponentq1 intValue] >= 1))
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] - 1];
        else if ([game.opponentq1 intValue] >= 1)
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] - 1];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] - 1];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Add 2PT"]) {
        if ([quarter isEqualToString:@"Q1"])
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] + 2];
        else if ([quarter isEqualToString:@"Q2"])
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] + 2];
        else if ([quarter isEqualToString:@"Q3"])
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] + 2];
        else
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] + 2];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] + 2];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Delete 2PT"]) {
        if (([quarter isEqualToString:@"Q1"]) && ([game.opponentq1 intValue] >= 2))
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] - 2];
        else if (([quarter isEqualToString:@"Q2"]) && ([game.opponentq1 intValue] >= 2))
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] - 2];
        else if (([quarter isEqualToString:@"Q3"]) && ([game.opponentq1 intValue] >= 2))
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] - 2];
        else if ([game.opponentq1 intValue] >= 2)
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] - 2];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] - 2];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Q1"]) {
        quarter = @"Q1";
        [self scoreType];
    } else if ([title isEqualToString:@"Q2"]) {
        quarter = @"Q2";
        [self scoreType];
    } else if ([title isEqualToString:@"Q3"]) {
        quarter = @"Q3";
        [self scoreType];
    } else if ([title isEqualToString:@"Q4"]) {
        quarter = @"Q4";
        [self scoreType];
    } else if ([title isEqualToString:@"Add Penalty"]) {
        _penaltyYardsTextField.hidden = NO;
        game.penalty = [NSNumber numberWithInt:[game.penalty intValue] + 1];
    } else if (([title isEqualToString:@"Delete Penalty"]) && ([game.penalty intValue] > 0)) {
        _penaltyYardsTextField.hidden = NO;
        game.penalty = [NSNumber numberWithInt:[game.penalty intValue] - 1];
        minuspenalty = YES;
    }
}

- (void)scoreType {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Score"  message:@"Score Type"
                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Touchdown", @"Delete Touchdown", @"Add Field Goal",
                          @"Delete Field Goal", @"Add Extra Point", @"Delete Extra Point", @"Add 2PT", @"Delete 2PT", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue {
    _gamelogContainer.hidden = YES;
//    [self viewWillAppear:YES];
    [_statsTableView reloadData];
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

- (void)populatePositionLists:(Athlete *)player {
    if ([player isQB:nil])
        [footballQB addObject:player];
    
    if ([player isRB:nil])
        [footballRB addObject:player];
    
    if ([player isWR:nil])
        [footballWR addObject:player];
    
    if ([player isOL:nil])
        [footballOL addObject:player];
    
    if ([player isDEF:nil])
        [footballDEF addObject:player];
    
    if ([player isPK:nil])
        [footballPK addObject:player];
    
    if ([player isKicker:nil])
        [footballK addObject:player];
    
    if ([player isPunter:nil])
        [footballPUNT addObject:player];
    
    if ([player isReturner:nil])
        [footballRET addObject:player];
}

- (IBAction)penaltyButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Penalties"  message:@"Home team penalties"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Penalty", @"Delete Penalty", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)buttonOneClicked:(id)sender {
    if (qb) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats)
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
        else if ([stat.attempts intValue] > 0)
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
        
        _statData2.text = [stat.attempts stringValue];
    } else if (rb) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if (addstats) {
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
            [self yardStats:NO Text:@"Yards"];
        } else if ([stat.attempts intValue] > 0) {
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
            [self yardStats:YES Text:@""];
        }

        _statData1.text = [stat.attempts stringValue];
    } else if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.tackles = [NSNumber numberWithInt:[stat.tackles intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Tackle", athlete.logname];
        } else if ([stat.tackles intValue] > 0) {
            stat.tackles = [NSNumber numberWithInt:[stat.tackles intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData1.text = [stat.tackles stringValue];
    } else if (pk) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats)
            stat.fgattempts= [NSNumber numberWithInt:[stat.fgattempts intValue] + 1];
        else
            stat.fgattempts= [NSNumber numberWithInt:[stat.fgattempts intValue] - 1];
        
        _statData1.text = [stat.fgattempts stringValue];
    } else if (kicker) {
        FootballKickerStats *stat = [athlete findFootballKickerStat:game.id];
        koreturn = YES;
        
        if (addstats) {
            stat.koattempts = [NSNumber numberWithInt:[stat.koattempts intValue] + 1];
            stat.koreturned = [NSNumber numberWithInt:[stat.koreturned intValue] + 1];
        } else {
            stat.koattempts = [NSNumber numberWithInt:[stat.koattempts intValue] - 1];
            stat.koreturned = [NSNumber numberWithInt:[stat.koreturned intValue] - 1];
        }
        
        _statData2.text = [stat.koattempts stringValue];
        _statData3.text = [stat.koreturned stringValue];
    } else if (returner) {
        FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
        
        if (addstats) {
            [self yardStats:NO Text:@"Return Yards"];
            stat.koreturn = [NSNumber numberWithInt:[stat.koreturn intValue] + 1];
            koreturn = YES;
        } else {
            [self yardStats:YES Text:@""];
            stat.koreturn = [NSNumber numberWithInt:[stat.koreturn intValue] - 1];
            koreturn = NO;
        }
        
        _statData1.text = [stat.koreturn stringValue];
    } else {
        FootballPunterStats *stat = [athlete findFootballPunterStat:game.id];
        
        if (addstats) {
            [self yardStats:NO Text:@"Punt Yards"];
            stat.punts = [NSNumber numberWithInt:[stat.punts intValue] + 1];
        } else {
            [self yardStats:YES Text:@""];
            stat.punts = [NSNumber numberWithInt:[stat.punts intValue] - 1];
        }
        
        _statData1.text = [stat.punts stringValue];
    }
}

- (IBAction)buttonTwoClicked:(id)sender {
    if (qb) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats) {
            stat.completions = [NSNumber numberWithInt:[stat.completions intValue] + 1];
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
            _receiverTextField.hidden = NO;
            _receiverTextField.enabled = YES;
            _playerSelectContainer.hidden = NO;
            completion = YES;
            [self yardStats:NO Text:@"Yards"];
            [self fumbleStats:NO];
            playerController.player = nil;
            [playerController viewWillAppear:YES];
        } else if ([stat.completions intValue] > 0) {
            stat.completions = [NSNumber numberWithInt:[stat.completions intValue] - 1];
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
            _receiverTextField.hidden = YES;
            _receiverTextField.enabled = NO;
            _receiverTextField.text = @"";
            _playerSelectContainer.hidden = YES;
            completion = NO;
            [self yardStats:YES Text:@""];
            [self fumbleStats:YES];
        }
        
        _statData1.text = [stat.completions stringValue];
        _statData2.text = [stat.attempts stringValue];
    } else if (rb) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if (addstats )
            stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] + 1];
        else if ([stat.firstdowns intValue] > 0)
            stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] - 1];
        
        _statData6.text = [stat.firstdowns stringValue];
    } else if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.assists = [NSNumber numberWithInt:[stat.assists intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - tackle assist", athlete.logname];
        } else if ([stat.assists intValue] > 0) {
            stat.assists = [NSNumber numberWithInt:[stat.assists intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData2.text = [stat.assists stringValue];
    } else if (pk) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats) {
            stat.fgattempts= [NSNumber numberWithInt:[stat.fgattempts intValue] + 1];
            stat.fgmade = [NSNumber numberWithInt:[stat.fgmade intValue] + 1];
            fieldgoal = YES;
            [self yardStats:NO Text:@"Length"];
            [self scoreStats:NO];
        } else {
            stat.fgattempts= [NSNumber numberWithInt:[stat.fgattempts intValue] - 1];
            stat.fgmade = [NSNumber numberWithInt:[stat.fgmade intValue] - 1];
            fieldgoal = NO;
            [self yardStats:YES Text:@""];
            [self scoreStats:YES];
        }
        
        _statData1.text = [stat.fgattempts stringValue];
        _statData2.text = [stat.fgmade stringValue];
    } else if (kicker) {
        FootballKickerStats *stat = [athlete findFootballKickerStat:game.id];
        
        if (addstats) {
            stat.koreturned = [NSNumber numberWithInt:[stat.koattempts intValue] - 1];
            stat.kotouchbacks = [NSNumber numberWithInt:[stat.kotouchbacks intValue] + 1];
        } else if ([stat.kotouchbacks intValue] > 0){
            stat.kotouchbacks = [NSNumber numberWithInt:[stat.kotouchbacks intValue] - 1];
        }
        
        _statData3.text = [stat.koreturned stringValue];
        _statData4.text = [stat.kotouchbacks stringValue];
    } else if (returner) {
        FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
        
        if (addstats) {
            [self yardStats:NO Text:@"Return Yards"];
            stat.punt_return = [NSNumber numberWithInt:[stat.punt_return intValue] + 1];
            puntreturn = YES;
      } else if ([stat.punt_return intValue] > 0) {
            [self yardStats:YES Text:@""];
            stat.punt_return = [NSNumber numberWithInt:[stat.punt_return intValue] - 1];
            puntreturn = NO;
        }
        
        _statData6.text = [stat.punt_return stringValue];
    } else {
        FootballPunterStats *stat = [athlete findFootballPunterStat:game.id];
        [self yardStats:YES Text:@""];
        
        if (addstats) {
            stat.punts_blocked = [NSNumber numberWithInt:[stat.punts_blocked intValue] + 1];
            stat.punts = [NSNumber numberWithInt:[stat.punts intValue] + 1];
        } else if (([stat.punts_blocked intValue] > 0) && ([stat.punts intValue] > 0)) {
            stat.punts_blocked = [NSNumber numberWithInt:[stat.punts_blocked intValue] - 1];
            stat.punts = [NSNumber numberWithInt:[stat.punts intValue] - 1];
        }
        
        _statData4.text = [stat.punts_blocked stringValue];
        _statData1.text = [stat.punts stringValue];
    }
}

- (IBAction)buttonThreeClicked:(id)sender {
    if (qb) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats)
            stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] + 1];
        else if ([stat.sacks intValue] > 0)
            stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] - 1];
        
        _statData8.text = [stat.sacks stringValue];
    } else if (rb) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if ((addstats) && (!_yardsTextField.hidden)) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
            touchdown = YES;
            [self scoreStats:NO];
        } else if (_yardsTextField.hidden) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Enter rush attempt and yards first!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        } else if ([stat.td intValue] > 0) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            touchdown = NO;
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Sack", athlete.logname];
        } else if ([stat.sacks intValue] > 0) {
            stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData3.text = [stat.sacks stringValue];
    } else if (pk) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats)
            stat.fgblocked = [NSNumber numberWithInt:[stat.fgblocked intValue] + 1];
        else if ([stat.fgblocked intValue] > 0)
            stat.fgblocked = [NSNumber numberWithInt:[stat.fgblocked intValue] - 1];
        
        _statData3.text = [stat.fgblocked stringValue];
    } else if (returner) {
        if ((puntreturn) || (koreturn)) {
            FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
            
            if (addstats) {
                touchdown = YES;
                [self scoreStats:NO];
                if (puntreturn) {
                    stat.punt_returntd = [NSNumber numberWithInt:[stat.punt_returntd intValue] + 1];
                    _statData8.text = [stat.punt_returntd stringValue];
                } else {
                    stat.kotd = [NSNumber numberWithInt:[stat.kotd intValue] + 1];
                    _statData3.text = [stat.kotd stringValue];
                }
            } else {
                touchdown = NO;
                [self scoreStats:YES];
                if ((puntreturn) && ([stat.punt_returntd intValue] > 0)) {
                    stat.punt_returntd = [NSNumber numberWithInt:[stat.punt_returntd intValue] - 1];
                    _statData8.text = [stat.punt_returntd stringValue];
                } else if ((koreturn) && ([stat.kotd intValue] > 0)) {
                    stat.kotd = [NSNumber numberWithInt:[stat.kotd intValue] - 1];
                    _statData3.text = [stat.kotd stringValue];
                }
            }            
         } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please select punt or kickoff return before posting TD!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (IBAction)buttonFourClicked:(id)sender {
    if (qb) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];

        if (_receiverTextField.text.length > 0) {
            FootballReceivingStat *recstat = [receiver findFootballReceivingStat:game.id];
            if (addstats) {
                stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] + 1];
                recstat.firstdowns = [NSNumber numberWithInt:[recstat.firstdowns intValue] + 1];
            } else if ([stat.firstdowns intValue] > 0) {
                stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] - 1];
                recstat.firstdowns = [NSNumber numberWithInt:[recstat.firstdowns intValue] - 1];
            }
            
            _statData6.text = [stat.firstdowns stringValue];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Completion to receiver must be added before adding a first down! If you are adjusting stat errors, use the totals page." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if (rb) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if (addstats) {
            stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] + 1];
            [self scoreStats:NO];
        } else if ([stat.td intValue] > 0) {
            stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] - 1];
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.sackassist = [NSNumber numberWithInt:[stat.sackassist intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - sack assist", athlete.logname];
        } else if ([stat.sackassist intValue] > 0) {
            stat.sackassist = [NSNumber numberWithInt:[stat.sackassist intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData4.text = [stat.sackassist stringValue];
    } else if (pk) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats)
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] + 1];
        else if ([stat.xpattempts intValue] > 0)
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] - 1];
        
        _statData7.text = [stat.xpattempts stringValue];
    }
}

- (IBAction)buttonFiveClicked:(id)sender {
    if (qb) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats)
            stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] + 1];
        else if ([stat.interceptions intValue] > 0)
            stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] - 1];
    
        _statData7.text = [stat.interceptions stringValue];
    } else if (rb) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + 1];
        _statData7.text = [stat.fumbles stringValue];
    } else if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] + 1];
            interception = YES;
            [self yardStats:NO Text:@"Return Yards"];
        } else if ([stat.interceptions intValue] > 0) {
            stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] - 1];
            interception = NO;
            [self yardStats:YES Text:@""];
        }
        
        _statData5.text = [stat.interceptions stringValue];
    } else if (pk) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats) {
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] + 1];
            stat.xpmade = [NSNumber numberWithInt:[stat.xpmade intValue] + 1];
            xpmade = YES;
            [self scoreStats:NO];
        } else if ([stat.xpmade intValue] > 0) {
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] - 1];
            stat.xpmade = [NSNumber numberWithInt:[stat.xpmade intValue] - 1];
            xpmade = NO;
            [self scoreStats:YES];
        }
        
        _statData7.text = [stat.xpattempts stringValue];
        _statData8.text = [stat.xpmade stringValue];
    }
}

- (IBAction)buttonSixClicked:(id)sender {
    if (qb) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats) {
            if (receiver) {
                stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
                touchdown = YES;
                [self scoreStats:NO];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Receiver must be selected to post a score!"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else if ([stat.td intValue] > 0) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            touchdown = NO;
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        _statData5.text = [stat.td stringValue];
    } else if (rb) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + 1];
        _statData8.text = [stat.fumbles_lost stringValue];
    } else if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.pass_defended = [NSNumber numberWithInt:[stat.pass_defended intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Pass Defended", athlete.logname];
        } else if ([stat.pass_defended intValue] > 0) {
            stat.pass_defended = [NSNumber numberWithInt:[stat.pass_defended intValue] - 1];
            game.lastplay = @"";
        }
    
        _statData6.text = [stat.pass_defended stringValue];
    } else if (pk) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats) {
            stat.xpblocked = [NSNumber numberWithInt:[stat.xpblocked intValue] + 1];
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] + 1];
        } else if ([stat.xpblocked intValue] > 0) {
            stat.xpblocked = [NSNumber numberWithInt:[stat.xpblocked intValue] - 1];
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] - 1];
        }
        
        _statData9.text = [stat.xpblocked stringValue];
    }
}

- (IBAction)buttonSevenClicked:(id)sender {
    if (qb) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats) {
            if (receiver) {
                stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] + 1];
                twopoint = YES;
                [self scoreStats:NO];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Receiver must be selected to post a score!"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else if ([stat.twopointconv intValue] > 0) {
            stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] - 1];
            twopoint = NO;
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        _statData10.text = [stat.td stringValue];
    } else if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.fumbles_recovered = [NSNumber numberWithInt:[stat.fumbles_recovered intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Fumble Recovered", athlete.logname];
            [self yardStats:NO Text:@"Return Yards"];
        } else if ([stat.fumbles_recovered intValue] > 0) {
            stat.fumbles_recovered = [NSNumber numberWithInt:[stat.fumbles_recovered intValue] - 1];
            [self yardStats:YES Text:@""];
            game.lastplay = @"";
        }
        
        _statData8.text = [stat.fumbles_recovered stringValue];
    }
}

- (IBAction)buttonEightClicked:(id)sender {
    if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            if ((interception) || (fumblerecovered)) {
                stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
                touchdown = YES;
                [self scoreStats:NO];
            }  else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated! If not, continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else if ([stat.td intValue] > 0) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            touchdown = NO;
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated! If not, continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        _statData9.text = [stat.td stringValue];
    }
}

- (IBAction)buttonNineClicked:(id)sender {
    if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.safety = [NSNumber numberWithInt:[stat.safety intValue] + 1];
            [self scoreStats:NO];
        } else if ([stat.safety intValue] > 0) {
            stat.safety = [NSNumber numberWithInt:[stat.safety intValue] - 1];
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        _statData10.text = [stat.td stringValue];
    }
}

- (void)yardStats:(BOOL)hidden Text:(NSString *)textString {
    _yardsLabel.text = textString;
    
    if (hidden) {
        _yardsLabel.hidden = YES;
        _yardsTextField.hidden = YES;
        _yardsTextField.enabled = NO;
    } else {
        _yardsLabel.hidden = NO;
        _yardsTextField.hidden = NO;
        _yardsTextField.enabled = YES;
    }
}

- (void)scoreStats:(BOOL)hidden {
    if (hidden) {
        _quarterLabel.hidden = YES;
        _quarterStatTextField.hidden = YES;
        _quarterStatTextField.enabled = NO;
        _timeofscoreLabel.hidden = YES;
        _colonLabel.hidden = YES;
        _minutesStatTextField.hidden = YES;
        _minutesStatTextField.enabled = NO;
        _secondsStatTextField.hidden = YES;
        _secondsStatTextField.enabled = NO;
    } else {
        _quarterLabel.hidden = NO;
        _quarterStatTextField.hidden = NO;
        _quarterStatTextField.enabled = YES;
        _timeofscoreLabel.hidden = NO;
        _colonLabel.hidden = NO;
        _minutesStatTextField.hidden = NO;
        _minutesStatTextField.enabled = YES;
        _secondsStatTextField.hidden = NO;
        _secondsStatTextField.enabled = YES;
    }
}

- (void)fumbleStats:(BOOL)hidden {
    if (hidden) {
        _fumbleLostLabel.hidden = YES;
        _fumbleLostSwitch.enabled = NO;
        _fumbleLostSwitch.hidden = YES;
        _fumbleLabel.hidden = YES;
        _fumbleSwitch.enabled = NO;
        _fumbleSwitch.hidden = YES;
    } else {
        _fumbleLostLabel.hidden = NO;
        _fumbleLostSwitch.enabled = YES;
        _fumbleLostSwitch.hidden = NO;
        _fumbleLabel.hidden = NO;
        _fumbleSwitch.enabled = YES;
        _fumbleSwitch.hidden = NO;
        
        if (qb)
            _fumbleLabel.text = @"Receiver Fumble";
        else if (rb)
            _fumbleLabel.text = @"Fumble";
    }
    
    [_fumbleSwitch setOn:NO];
    [_fumbleLostSwitch setOn:NO];
}

- (void)displayStats {
    interception = touchdown = twopoint = safety = fieldgoal = xpmade = puntreturn = koreturn = fumblerecovered = NO;
    
    if (athlete) {
        _refreshButton.hidden = NO;
        _refreshButton.enabled = YES;
        _savePlayerStatsButton.hidden = NO;
        _savePlayerStatsButton.enabled = YES;
        _playerNameLabel.text = [athlete numberLogname];
        _toggleButton.hidden = NO;
        _toggleButton.enabled = YES;
        _totalsButton.hidden = NO;
        _totalsButton.enabled = YES;

        if ([currentSettings getRosterThumbImage:athlete] == nil) {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:athlete.thumb]];
                
                //this will set the image when loading is finished
                dispatch_async(dispatch_get_main_queue(), ^{
                    _playerImageView.image = [UIImage imageWithData:image];
                });
            });
        } else
            _playerImageView.image = [currentSettings getRosterThumbImage:athlete];
        
        if (offense) {
            if (qb) {
                _statTitleLabel.text = @"Passing Statistics";
                FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
                
                _statLabel1.text = @"CMP";
                _statData1.text = [stat.completions stringValue];
                _statLabel2.text = @"ATT";
                _statData2.text = [stat.attempts stringValue];
                _statLabel3.text = @"PCT";
                _statData3.text = [NSString stringWithFormat:@"%.02f", [stat.comp_percentage floatValue]];
                _statLabel4.text = @"YDS";
                _statData4.text = [stat.yards stringValue];
                _statLabel5.text = @"TD";
                _statData5.text = [stat.td stringValue];
                _statLabel6.text = @"FD";
                _statData6.text = [stat.firstdowns stringValue];
                _statLabel7.text = @"INT";
                _statData7.text = [stat.interceptions stringValue];
                _statLabel8.text = @"SCK";
                _statData8.text = [stat.sacks stringValue];
                _statLabel9.text = @"YDL";
                _statData9.text = [stat.yards_lost stringValue];
                _statLabel10.text = @"2PT";
                _statData10.text = [stat.twopointconv stringValue];
                
                [_buttonOne setTitle:@"Attempt" forState:UIControlStateNormal];
                _buttonOne.enabled = YES;
                _buttonOne.hidden = NO;
                [_buttonTwo setTitle:@"Completion" forState:UIControlStateNormal];
                _buttonTwo.enabled = YES;
                _buttonTwo.hidden = NO;
                [_buttonThree setTitle:@"Sack" forState:UIControlStateNormal];
                _buttonThree.enabled = YES;
                _buttonThree.hidden = NO;
                [_buttonFour setTitle:@"First Down" forState:UIControlStateNormal];
                _buttonFour.enabled = YES;
                _buttonFour.hidden = NO;
                [_buttonFive setTitle:@"Interception" forState:UIControlStateNormal];
                _buttonFive.enabled = YES;
                _buttonFive.hidden = NO;
                [_buttonSix setTitle:@"TD" forState:UIControlStateNormal];
                _buttonSix.enabled = YES;
                _buttonSix.hidden = NO;
                [_buttonSeven setTitle:@"2PT Conv" forState:UIControlStateNormal];
                _buttonSeven.enabled = YES;
                _buttonSeven.hidden = NO;
                _buttonEight.enabled = NO;
                _buttonEight.hidden = YES;
                _buttonNine.enabled = NO;
                _buttonNine.hidden = YES;
            } else if (rb) {
                _statTitleLabel.text = @"Rushing Statistics";
                FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
                
                _statLabel1.text = @"ATT";
                _statData1.text = [stat.attempts stringValue];
                _statLabel2.text = @"YDS";
                _statData2.text = [stat.yards stringValue];
                _statLabel3.text = @"AVG";
                _statData3.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
                _statLabel4.text = @"TD";
                _statData4.text = [stat.td stringValue];
                _statLabel5.text = @"LNG";
                _statData5.text = [stat.longest stringValue];
                _statLabel6.text = @"FD";
                _statData6.text = [stat.firstdowns stringValue];
                _statLabel7.text = @"FMB";
                _statData7.text = [stat.fumbles stringValue];
                _statLabel8.text = @"LST";
                _statData8.text = [stat.fumbles_lost stringValue];
                _statLabel9.text = @"2PT";
                _statData9.text = [stat.twopointconv stringValue];
                _statLabel10.text = @"";
                _statData10.text = @"";
                
                [_buttonOne setTitle:@"Attempt" forState:UIControlStateNormal];
                _buttonOne.enabled = YES;
                _buttonOne.hidden = NO;
                [_buttonTwo setTitle:@"First Down" forState:UIControlStateNormal];
                _buttonTwo.enabled = YES;
                _buttonTwo.hidden = NO;
                [_buttonThree setTitle:@"TD" forState:UIControlStateNormal];
                _buttonThree.enabled = YES;
                _buttonThree.hidden = NO;
                [_buttonFour setTitle:@"2PT Conv" forState:UIControlStateNormal];
                _buttonFour.enabled = YES;
                _buttonFour.hidden = NO;
                [_buttonFive setTitle:@"Fumble" forState:UIControlStateNormal];
                _buttonFive.enabled = YES;
                _buttonFive.hidden = NO;
                [_buttonSix setTitle:@"Fumble Lost" forState:UIControlStateNormal];
                _buttonSix.enabled = NO;
                _buttonSix.hidden = YES;
                _buttonSeven.enabled = NO;
                _buttonSeven.hidden = YES;
                _buttonEight.enabled = NO;
                _buttonEight.hidden = YES;
                _buttonNine.enabled = NO;
                _buttonNine.hidden = YES;
            }
        } else if (defense) {
            _statTitleLabel.text = @"Defensive Statistics";
            FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
            
            _statLabel1.text = @"TKL";
            _statData1.text = [stat.tackles stringValue];
            _statLabel2.text = @"AST";
            _statData2.text = [stat.assists stringValue];
            _statLabel3.text = @"SAK";
            _statData3.text = [stat.sacks stringValue];
            _statLabel4.text = @"AST";
            _statData4.text = [stat.sackassist stringValue];
            _statLabel5.text = @"INT";
            _statData5.text = [stat.interceptions stringValue];
            _statLabel6.text = @"PD";
            _statData6.text = [stat.pass_defended stringValue];
            _statLabel7.text = @"RYD";
            _statData7.text = [stat.int_yards stringValue];
            _statLabel8.text = @"FRC";
            _statData8.text = [stat.fumbles_recovered stringValue];
            _statLabel9.text = @"TD";
            _statData9.text = [stat.td stringValue];
            _statLabel10.text = @"SFY";
            _statData10.text = [stat.safety stringValue];
            
            [_buttonOne setTitle:@"Tackle" forState:UIControlStateNormal];
            _buttonOne.enabled = YES;
            _buttonOne.hidden = NO;
            [_buttonTwo setTitle:@"Assist" forState:UIControlStateNormal];
            _buttonTwo.enabled = YES;
            _buttonTwo.hidden = NO;
            [_buttonThree setTitle:@"Sack" forState:UIControlStateNormal];
            _buttonThree.enabled = YES;
            _buttonThree.hidden = NO;
            [_buttonFour setTitle:@"Sack Assist" forState:UIControlStateNormal];
            _buttonFour.enabled = YES;
            _buttonFour.hidden = NO;
            [_buttonFive setTitle:@"Interception" forState:UIControlStateNormal];
            _buttonFive.enabled = YES;
            _buttonFive.hidden = NO;
            [_buttonSix setTitle:@"Pass Def" forState:UIControlStateNormal];
            _buttonSix.enabled = YES;
            _buttonSix.hidden = NO;
            [_buttonSeven setTitle:@"Fumble Rec" forState:UIControlStateNormal];
            _buttonSeven.enabled = YES;
            _buttonSeven.hidden = NO;
            [_buttonEight setTitle:@"TD" forState:UIControlStateNormal];
            _buttonEight.enabled = YES;
            _buttonEight.hidden = NO;
            [_buttonNine setTitle:@"Safety" forState:UIControlStateNormal];
            _buttonNine.enabled = YES;
            _buttonNine.hidden = NO;
        } else if (pk) {
            _statTitleLabel.text = @"Place Kicker Statistics";
            FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
            
            _statLabel1.text = @"FGA";
            _statData1.text = [stat.fgattempts stringValue];
            _statLabel2.text = @"FGM";
            _statData2.text = [stat.fgmade stringValue];
            _statLabel3.text = @"BLK";
            _statData3.text = [stat.fgblocked stringValue];
            _statLabel4.text = @"LNG";
            _statData4.text = [stat.fglong stringValue];
            _statLabel5.text = @"";
            _statData5.text = @"";
            _statLabel6.text = @"";
            _statData6.text = @"";
            _statLabel7.text = @"XPA";
            _statData7.text = [stat.xpattempts stringValue];
            _statLabel8.text = @"XPM";
            _statData8.text = [stat.xpmade stringValue];
            _statLabel9.text = @"BLK";
            _statData9.text = [stat.xpblocked stringValue];
            _statLabel10.text = @"";
            _statData10.text = @"";
            
            [_buttonOne setTitle:@"FGA" forState:UIControlStateNormal];
            _buttonOne.enabled = YES;
            _buttonOne.hidden = NO;
            [_buttonTwo setTitle:@"FGM" forState:UIControlStateNormal];
            _buttonTwo.enabled = YES;
            _buttonTwo.hidden = NO;
            [_buttonThree setTitle:@"Blocked" forState:UIControlStateNormal];
            _buttonThree.enabled = YES;
            _buttonThree.hidden = NO;
            [_buttonFour setTitle:@"XPA" forState:UIControlStateNormal];
            _buttonFour.enabled = YES;
            _buttonFour.hidden = NO;
            [_buttonFive setTitle:@"XPM" forState:UIControlStateNormal];
            _buttonFive.enabled = YES;
            _buttonFive.hidden = NO;
            [_buttonSix setTitle:@"Blocked" forState:UIControlStateNormal];
            _buttonSix.enabled = YES;
            _buttonSix.hidden = NO;
            _buttonSeven.enabled = NO;
            _buttonSeven.hidden = YES;
            _buttonEight.enabled = NO;
            _buttonEight.hidden = YES;
            _buttonNine.enabled = NO;
            _buttonNine.hidden = YES;
        } else if (kicker) {
            _statTitleLabel.text = @"Kicker Statistics";
            FootballKickerStats *stat = [athlete findFootballKickerStat:game.id];
            
            _statLabel1.text = @"";
            _statData1.text = @"";
            _statLabel2.text = @"KO";
            _statData2.text = [stat.koattempts stringValue];
            _statLabel3.text = @"RET";
            _statData3.text = [stat.koreturned stringValue];
            _statLabel4.text = @"TCH";
            _statData4.text = [stat.kotouchbacks stringValue];
            _statLabel5.text = @"";
            _statData5.text = @"";
            _statLabel6.text = @"";
            _statData6.text = @"";
            _statLabel7.text = @"";
            _statData7.text = @"";
            _statLabel8.text = @"";
            _statData8.text = @"";
            _statLabel9.text = @"";
            _statData9.text = @"";
            _statLabel10.text = @"";
            _statData10.text = @"";
            
            [_buttonOne setTitle:@"Kickoff" forState:UIControlStateNormal];
            _buttonOne.enabled = YES;
            _buttonOne.hidden = NO;
            [_buttonTwo setTitle:@"Touchback" forState:UIControlStateNormal];
            _buttonTwo.enabled = YES;
            _buttonTwo.hidden = NO;
            _buttonThree.enabled = NO;
            _buttonThree.hidden = YES;
            _buttonFour.enabled = NO;
            _buttonFour.hidden = YES;
            _buttonFive.enabled = NO;
            _buttonFive.hidden = YES;
            _buttonSix.enabled = NO;
            _buttonSix.hidden = YES;
            _buttonSeven.enabled = NO;
            _buttonSeven.hidden = YES;
            _buttonEight.enabled = NO;
            _buttonEight.hidden = YES;
            _buttonNine.enabled = NO;
            _buttonNine.hidden = YES;
            
        } else if (returner) {
            _statTitleLabel.text = @"Returner Statistics";
            FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
            
            _statLabel1.text = @"RET";
            _statData1.text = [stat.koreturn stringValue];
            _statLabel2.text = @"YDS";
            _statData2.text = [stat.koyards stringValue];
            _statLabel3.text = @"TD";
            _statData3.text = [stat.kotd stringValue];
            _statLabel4.text = @"LNG";
            _statData4.text = [stat.kolong stringValue];
            _statLabel5.text = @"";
            _statData5.text = @"";
            _statLabel6.text = @"PUNT";
            _statData6.text = [stat.punt_return stringValue];
            _statLabel7.text = @"YDS";
            _statData7.text = [stat.punt_returnyards stringValue];
            _statLabel8.text = @"TD";
            _statData8.text = [stat.punt_returntd stringValue];
            _statLabel9.text = @"LNG";
            _statData9.text = [stat.punt_returnlong stringValue];
            _statLabel10.text = @"";
            _statData10.text = @"";
            
            [_buttonOne setTitle:@"Kick Return" forState:UIControlStateNormal];
            _buttonOne.enabled = YES;
            _buttonOne.hidden = NO;
            [_buttonTwo setTitle:@"Punt Return" forState:UIControlStateNormal];
            _buttonTwo.enabled = YES;
            _buttonTwo.hidden = NO;
            [_buttonThree setTitle:@"TD" forState:UIControlStateNormal];
            _buttonThree.enabled = YES;
            _buttonThree.hidden = NO;
            _buttonFour.enabled = NO;
            _buttonFour.hidden = YES;
            _buttonFive.enabled = NO;
            _buttonFive.hidden = YES;
            _buttonSix.enabled = NO;
            _buttonSix.hidden = YES;
            _buttonSeven.enabled = NO;
            _buttonSeven.hidden = YES;
            _buttonEight.enabled = NO;
            _buttonEight.hidden = YES;
            _buttonNine.enabled = NO;
            _buttonNine.hidden = YES;
        } else if (punter) {
            _statTitleLabel.text = @"Punter Statistics";
            FootballPunterStats *stat = [athlete findFootballPunterStat:game.id];
            
            _statLabel1.text = @"PUNT";
            _statData1.text = [stat.punts stringValue];
            _statLabel2.text = @"YDS";
            _statData2.text = [stat.punts_yards stringValue];
            _statLabel3.text = @"LNG";
            _statData3.text = [stat.punts_long stringValue];
            _statLabel4.text = @"BLK";
            _statData4.text = [stat.punts_blocked stringValue];
            _statLabel5.text = @"";
            _statData5.text = @"";
            _statLabel6.text = @"";
            _statData6.text = @"";
            _statLabel7.text = @"";
            _statData7.text = @"";
            _statLabel8.text = @"";
            _statData8.text = @"";
            _statLabel9.text = @"";
            _statData9.text = @"";
            _statLabel10.text = @"";
            _statData10.text = @"";
            
            [_buttonOne setTitle:@"Punt" forState:UIControlStateNormal];
            _buttonOne.enabled = YES;
            _buttonOne.hidden = NO;
            [_buttonTwo setTitle:@"Blocked" forState:UIControlStateNormal];
            _buttonTwo.enabled = YES;
            _buttonTwo.hidden = NO;
            _buttonThree.enabled = NO;
            _buttonThree.hidden = YES;
            _buttonFour.enabled = NO;
            _buttonFour.hidden = YES;
            _buttonFive.enabled = NO;
            _buttonFive.hidden = YES;
            _buttonSix.enabled = NO;
            _buttonSix.hidden = YES;
            _buttonSeven.enabled = NO;
            _buttonSeven.hidden = YES;
            _buttonEight.enabled = NO;
            _buttonEight.hidden = YES;
            _buttonNine.enabled = NO;
            _buttonNine.hidden = YES;
        }
        
        _receiverTextField.hidden = YES;
        _receiverTextField.enabled = NO;
        _yardsTextField.hidden = YES;
        _yardsLabel.hidden = YES;
        
        [self fumbleStats:YES];
        [self scoreStats:YES];
    } else {
        _statTitleLabel.text = @"Player Statistics";
        _playerNameLabel.text = @"";
        _playerImageView.image = nil;
        _statLabel1.text = @"";
        _statLabel2.text = @"";
        _statLabel3.text = @"";
        _statLabel4.text = @"";
        _statLabel5.text = @"";
        _statLabel6.text = @"";
        _statLabel7.text = @"";
        _statLabel8.text = @"";
        _statLabel9.text = @"";
        _statLabel10.text = @"";
        
        _statData1.text = @"";
        _statData2.text = @"";
        _statData3.text = @"";
        _statData4.text = @"";
        _statData5.text = @"";
        _statData6.text = @"";
        _statData7.text = @"";
        _statData8.text = @"";
        _statData9.text = @"";
        _statData10.text = @"";
        
        _buttonOne.enabled = NO;
        _buttonOne.hidden = YES;
        _buttonTwo.enabled = NO;
        _buttonTwo.hidden = YES;
        _buttonThree.enabled = NO;
        _buttonThree.hidden = YES;
        _buttonFour.enabled = NO;
        _buttonFour.hidden = YES;
        _buttonFive.enabled = NO;
        _buttonFive.hidden = YES;
        _buttonSix.enabled = NO;
        _buttonSix.hidden = YES;
        _buttonSeven.enabled = NO;
        _buttonSeven.hidden = YES;
        _buttonEight.enabled = NO;
        _buttonEight.hidden = YES;
        _buttonNine.enabled = NO;
        _buttonNine.hidden = YES;
        
        _yardsLostLabel.hidden = YES;
        _yardsLostTextField.hidden = YES;
        _yardsLostTextField.enabled = NO;
        _receiverTextField.hidden = YES;
        _receiverTextField.enabled = NO;
        _yardsLabel.hidden = YES;
        _yardsTextField.hidden = YES;
        _yardsTextField.enabled = NO;
        
        [self fumbleStats:YES];
        [self scoreStats:YES];
        
        _savePlayerStatsButton.hidden = YES;
        _savePlayerStatsButton.enabled = NO;
        _refreshButton.hidden = YES;
        _refreshButton.enabled = NO;
        _totalsButton.hidden = YES;
        _totalsButton.enabled = NO;
        _toggleButton.hidden = YES;
        _toggleButton.enabled = NO;
    }
}

- (IBAction)savePlayerStatsButtonClicked:(id)sender {
    if (qb) {
        FootballPassingStat *passstat = [athlete findFootballPassingStat:game.id];
        FootballReceivingStat *recstat;
        
        if (receiver) {
            recstat = [receiver findFootballReceivingStat:game.id];
            recstat.receptions = [NSNumber numberWithInt:[recstat.receptions intValue] + 1];
            recstat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue] + [recstat.yards intValue]];
            passstat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue] + [passstat.yards intValue]];
            _statData4.text = [passstat.yards stringValue];
            
            if (touchdown)
                recstat.td = [NSNumber numberWithInt:[recstat.td intValue] + 1];
            else if (twopoint)
                recstat.twopointconv = [NSNumber numberWithInt:[recstat.twopointconv intValue] + 1];
        
            [recstat saveStats];
        }
                
        if (_yardsLostTextField.text.length > 0)
            passstat.yards_lost = [NSNumber numberWithInt:[passstat.yards_lost intValue] + [_yardsLostTextField.text intValue]];
        
        [passstat saveStats];
        
        if ((touchdown) || (twopoint)) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.football_passing_id = passstat.football_passing_id;
            gamelog.assistplayer = receiver.athleteid;
            gamelog.logentry = @"yard pass to";
            [game updateGamelog:gamelog];
            [game saveGameschedule];
        }
        
        receiver = nil;
    } else if (rb) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        stat.yards = [NSNumber numberWithInt:[stat.yards intValue] + [_yardsTextField.text intValue]];
        
        if ([_yardsTextField.text intValue] > [stat.longest intValue])
            stat.longest = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
        
        [stat saveStats];
        
        if ((touchdown) || (twopoint)) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.logentry = @"yard run";
            gamelog.football_rushing_id = stat.football_rushing_id;
            [game updateGamelog:gamelog];
            [game saveGameschedule];
        }
    } else if (defense) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (_yardsTextField.text.length > 0) {
            stat.int_yards = [NSNumber numberWithInt:[stat.int_yards intValue] + [_yardsTextField.text intValue]];
        }
        
        [stat saveStats];
        
        if ((touchdown) || (twopoint)) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.football_defense_id = stat.football_defense_id;
            
            if (touchdown) {
                if (interception)
                    gamelog.logentry = @"yard interception return";
                else
                    gamelog.logentry = @"yard fumble return";
                
                gamelog.score = @"TD";
            } else {
                gamelog.logentry = @"safety";
                gamelog.score = @"2P";
            }
            
            [game updateGamelog:gamelog];
            [game saveGameschedule];
        }
    } else if (pk) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if ((fieldgoal) && ([stat.fglong intValue] > [_yardsTextField.text intValue])) {
            stat.fglong = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
        }
        
        [stat saveStats];
        
        if ((fieldgoal) || (xpmade)) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.football_place_kicker_id = stat.football_place_kicker_id;
            
            if (fieldgoal) {
                gamelog.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
            }
            
            gamelog.logentry = athlete.logname;
            [game updateGamelog:gamelog];
            [game saveGameschedule];
        }
    } else if (returner) {
        FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
        
        if (_yardsTextField.text.length > 0) {
            if (koreturn) {
                stat.koyards = [NSNumber numberWithInt:[stat.koyards intValue] + [_yardsTextField.text intValue]];
                if ([_yardsTextField.text intValue] > [stat.kolong intValue])
                    stat.kolong = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
            } else {
                stat.punt_returnyards = [NSNumber numberWithInt:[stat.punt_returnyards intValue] + [_yardsTextField.text intValue]];
                if ([_yardsTextField.text intValue] > [stat.punt_returnlong intValue])
                    stat.punt_returnlong = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
            }
        }
        
        [stat saveStats];
        
        if (touchdown) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.football_returner_id = stat.football_returner_id;
            gamelog.logentry = athlete.logname;
            [game updateGamelog:gamelog];
            [game saveGameschedule];
        }
    } else if (kicker) {
        FootballKickerStats *stat = [athlete findFootballKickerStat:game.id];
        
        [stat saveStats];
    } else {
        FootballPunterStats *stat = [athlete findFootballPunterStat:game.id];
        stat.punts_yards = [NSNumber numberWithInt:[stat.punts_yards intValue] + [_yardsTextField.text intValue]];
        
        if ([stat.punts_long intValue] < [_yardsTextField.text intValue])
            stat.punts_long = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
        
        [stat saveStats];
    }
    
    _yardsTextField.text = @"";
    _yardsLostTextField.text = @"";
    [self viewWillAppear:YES];
    touchdown = twopoint = fieldgoal = xpmade = puntreturn = koreturn = NO;
}

- (Gamelogs *)populateGameLogEntries {
    Gamelogs *gamelog = [[Gamelogs alloc] init];
    
    gamelog.gameschedule_id = game.id;
    
    switch ([_quarterStatTextField.text intValue]) {
        case 1:
            gamelog.period = @"Q1";
            if (touchdown )
                game.homeq1 = [NSNumber numberWithInt:[game.homeq1 intValue] + 6];
            else if (twopoint)
                game.homeq1 = [NSNumber numberWithInt:[game.homeq1 intValue] + 2];
            else if (fieldgoal)
                game.homeq1 = [NSNumber numberWithInt:[game.homeq1 intValue] + 3];
            else if (xpmade)
                game.homeq1 = [NSNumber numberWithInt:[game.homeq1 intValue] + 1];
            break;
            
        case 2:
            gamelog.period = @"Q2";
            if (touchdown )
                game.homeq2 = [NSNumber numberWithInt:[game.homeq2 intValue] + 6];
            else if (twopoint)
                game.homeq2 = [NSNumber numberWithInt:[game.homeq2 intValue] + 2];
            else if (fieldgoal)
                game.homeq2 = [NSNumber numberWithInt:[game.homeq2 intValue] + 3];
            else if (xpmade)
                game.homeq2 = [NSNumber numberWithInt:[game.homeq2 intValue] + 1];
            break;
            
        case 3:
            gamelog.period = @"Q3";
            if (touchdown )
                game.homeq3 = [NSNumber numberWithInt:[game.homeq3 intValue] + 6];
            else if (twopoint)
                game.homeq3 = [NSNumber numberWithInt:[game.homeq3 intValue] + 2];
            else if (fieldgoal)
                game.homeq3 = [NSNumber numberWithInt:[game.homeq3 intValue] + 3];
            else if (xpmade)
                game.homeq3 = [NSNumber numberWithInt:[game.homeq3 intValue] + 1];
            break;
            
        default:
            gamelog.period = @"Q4";
            if (touchdown )
                game.homeq4 = [NSNumber numberWithInt:[game.homeq4 intValue] + 6];
            else if (twopoint)
                game.homeq4 = [NSNumber numberWithInt:[game.homeq4 intValue] + 2];
            else if (fieldgoal)
                game.homeq4 = [NSNumber numberWithInt:[game.homeq4 intValue] + 3];
            else if (xpmade)
                game.homeq4 = [NSNumber numberWithInt:[game.homeq4 intValue] + 1];
            break;
    }
    
    if ([_minutesStatTextField.text intValue] < 10) {
        int minute = [_minutesStatTextField.text intValue];
        _secondsStatTextField.text = [NSString stringWithFormat:@"0%d", minute];
    }
    
    if ([_secondsStatTextField.text intValue] < 10) {
        int minute = [_secondsStatTextField.text intValue];
        _minutesStatTextField.text = [NSString stringWithFormat:@"0%d", minute];
    }
    
    gamelog.time = [NSString stringWithFormat:@"%@%@%@", _minutesStatTextField.text, @":", _secondsStatTextField.text];
    gamelog.player = athlete.athleteid;
    gamelog.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue]];

    if (touchdown)
        gamelog.score = @"TD";
    else if (twopoint)
        gamelog.score = @"2P";
    else if (xpmade)
        gamelog.score = @"XP";
    else if (fieldgoal)
        gamelog.score = @"FG";
    
    return gamelog;
}

- (IBAction)toggleButtonClicked:(id)sender {
    if (addstats) {
        [_toggleButton setTitle:@"Add" forState:UIControlStateNormal];
        addstats = NO;
    } else {
        [_toggleButton setTitle:@"Subtract" forState:UIControlStateNormal];
        addstats = YES;
    }
}

- (IBAction)refreshButtonClicked:(id)sender {
    if (athlete) {
        Athlete *newplayer = [currentSettings retrievePlayer:athlete.athleteid];
        [currentSettings replaceAthleteById:newplayer];
        athlete = newplayer;
        [self displayStats];
        [_statsTableView reloadData];
    }
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)totalsButtonClicked:(id)sender {
    if (qb)
        [self performSegueWithIdentifier:@"PassingStatSegue" sender:self];
    else if (rb)
        [self performSegueWithIdentifier:@"RushingStatSegue" sender:self];
    else if (defense)
        [self performSegueWithIdentifier:@"DefenseStatSegue" sender:self];
    else if (pk)
        [self performSegueWithIdentifier:@"PlaceKickerStatSegue" sender:self];
    else if (kicker)
        [self performSegueWithIdentifier:@"KickerStatSegue" sender:self];
    else if (returner)
        [self performSegueWithIdentifier:@"ReturnerStatSegue" sender:self];
    else if (punter)
        [self performSegueWithIdentifier:@"PunterStatSegue" sender:self];
}

- (IBAction)fumbleSwitchToggle:(id)sender {
    if ([_fumbleSwitch isOn]) {
        if (qb) {
            FootballReceivingStat *stat = [athlete findFootballReceivingStat:game.id];
            stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + 1];
        } else if (rb) {
            FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
            stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + 1];
            _statData7.text = [stat.fumbles stringValue];
        }
    } else if (![_fumbleSwitch isOn]) {
        if (qb) {
            FootballReceivingStat *stat = [athlete findFootballReceivingStat:game.id];
            if ([stat.fumbles intValue] > 0)
                stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] - 1];
        } else if (rb) {
            FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
            
            if ([stat.fumbles intValue] > 0)
                stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] - 1];
            
            _statData7.text = [stat.fumbles stringValue];
        }
    }
}

- (IBAction)fumblelostSwitchToggle:(id)sender {
    if ([_fumbleLostSwitch isOn]) {
        if (qb) {
            FootballReceivingStat *stat = [athlete findFootballReceivingStat:game.id];
            stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + 1];
        } else if (rb) {
            FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
            stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + 1];
            _statData7.text = [stat.fumbles_lost stringValue];
        }
    } else if (![_fumbleLostSwitch isOn]) {
        if (qb) {
            FootballReceivingStat *stat = [athlete findFootballReceivingStat:game.id];
            if ([stat.fumbles_lost intValue] > 0)
            stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] - 1];
        } else if (rb) {
            FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
            
            if ([stat.fumbles_lost intValue] > 0)
                stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] - 1];
            
            _statData7.text = [stat.fumbles_lost stringValue];
        }
    }
}

- (IBAction)visitorMascotButtonClicked:(id)sender {
    game.possession = game.opponent_mascot;
    _visitorPossessionImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"footballpossessionimage.png"], 1)];
    _homePossessionImage.hidden = YES;
    _visitorPossessionImage.hidden = NO;
}

- (IBAction)homeMascotButtonClicked:(id)sender {
    game.possession = currentSettings.team.mascot;
    _homePossessionImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"footballpossessionimage.png"], 1)];
    _visitorPossessionImage.hidden = YES;
    _homePossessionImage.hidden = NO;
}

@end
