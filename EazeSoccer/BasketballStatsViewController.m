//
//  BasketballStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/8/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "BasketballStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "BasketballStatTableCell.h"
#import "BasketballStats.h"
#import "LiveBasketballStatsViewController.h"
#import "BasketballTotalStatsViewController.h"
#import "EazesportzBasketballNonScoreStatsViewController.h"

@interface BasketballStatsViewController ()

@end

@implementation BasketballStatsViewController {
    LiveBasketballStatsViewController *liveStatsController;
    BasketballTotalStatsViewController *totalStatsController;
    EazesportzBasketballNonScoreStatsViewController *nonscoreStatsController;
}

@synthesize athlete;
@synthesize game;
@synthesize clock;

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
    _bannerImage.image = [currentSettings getBannerImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _basketballLiveStatsContainer.hidden = YES;
    _basketballTotalStatsContainer.hidden = YES;
    _nonscoreStatsContainer.hidden = YES;
    
    if (game)
        _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats vs. ", game.opponent_name];
    else if (athlete)
        _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats for ", athlete.logname];
    else
        _statLabel.text = @"Select game to enter stats";
    
    if ((game) || (athlete)) {
        [_basketballTableView reloadData];
    }
    
    // Update the clock
    
    _firstPeriodButton.layer.cornerRadius = 8;
    _secondPeriodButton.layer.cornerRadius = 8;
    _thirdPeriodButton.layer.cornerRadius = 8;
    _fourthPeriodButton.layer.cornerRadius = 8;

    _hometeamImage.image = [currentSettings.team getImage:@"thumb"];
    _hometeamLabel.text = currentSettings.team.mascot;
    
    if (game) {
        _visitorImage.hidden = NO;
        _visitorImage.image = [game opponentImage];
        _visitorteamLabel.text = game.opponent_mascot;
        
        if (game.visitorbonus)
            _rightBonusImage.hidden = NO;
        else
            _rightBonusImage.hidden = YES;
        
        if (game.homebonus)
            _leftBonusImage.hidden = NO;
        else
            _leftBonusImage.hidden = YES;
        
        if ([game.possession isEqualToString:@"Home"]) {
            _homePossessionArrow.hidden = NO;
            _visitorPossessionArrow.hidden = YES;
        } else {
            _homePossessionArrow.hidden = YES;
            _visitorPossessionArrow.hidden = NO;
        }
        
        NSArray *splitArray = [game.currentgametime componentsSeparatedByString:@":"];
        _gameclockLabel.text = game.currentgametime;
        _minutesTextField.text = [splitArray objectAtIndex:0];
        _secondsTextField.text = [splitArray objectAtIndex:1];
        _gameclockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
        _homeScoreTextField.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
        _homeScoreLabel.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
        _homeFoulsTextField.text = [NSString stringWithFormat:@"%d", [currentSettings teamFouls:game.id]];
        _visitorScoreLabel.text = [NSString stringWithFormat:@"%d", [game.opponentscore intValue]];
        _visitorScoreTextField.text = [NSString stringWithFormat:@"%d", [game.opponentscore intValue]];
        _visitorFoulsTextField.text = [NSString stringWithFormat:@"%d", [game.visitorfouls intValue]];
        
        switch ([game.period intValue]) {
            case 1:
                [self firstPeriodButtonClicked:self];
                break;
                
            case 2:
                [self secondPeriodButtonClicked:self];
                break;
                
            case 3:
                [self thirdPeriodButtonClicked:self];
                break;
                
            default:
                [self fourthPeriodButtonClicked:self];
                break;
        }
    } else {
        _gameclockLabel.text = @"00:00";
        _visitorImage.hidden = YES;
        _visitorteamLabel.text = @"Visitors";
    }
    
}

- (IBAction)saveButtonClicked:(id)sender {
    if (game) {
        for (int cnt = 0; cnt < currentSettings.roster.count; cnt++) {
            if (![[currentSettings.roster objectAtIndex:cnt] saveBasketballGameStats:game.id]) {
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
            if (![athlete saveBasketballGameStats:[[currentSettings.gameList objectAtIndex:i] id]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                     message:[NSString stringWithFormat:@"%@%@", @"Update failed for  ", [athlete logname]]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    }

    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    game.visitorfouls = [NSNumber numberWithInt:[_visitorFoulsTextField.text intValue]];
    [game saveGameschedule];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stats Posted!"
                                                    message:[NSString stringWithFormat:@"%@%@%@", @"Stats for current players vs. ", game.opponent, @" saved!"]
                                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)liveBasketballPlayerStats:(UIStoryboardSegue *)segue {
    _basketballLiveStatsContainer.hidden = YES;
    
    if (athlete)
        [athlete updateBasketballGameStats:liveStatsController.stats];
    else
        [liveStatsController.player updateBasketballGameStats:liveStatsController.stats];
    
    [_basketballTableView reloadData];
    [self viewWillAppear:YES];
}

- (IBAction)updateTotalBasketballStats:(UIStoryboardSegue *)segue {
    _basketballTotalStatsContainer.hidden = YES;
    
    if (athlete)
        [athlete updateBasketballGameStats:totalStatsController.stats];
    else
        [totalStatsController.player updateBasketballGameStats:totalStatsController.stats];
    
//    [_basketballTableView reloadData];
    [self viewWillAppear:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [currentSettings.roster count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasketballStatTableCell";
    BasketballStatTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BasketballStatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    BasketballStats *stats;
    
    if (indexPath.row < currentSettings.roster.count) {
        Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
        stats = [player findBasketballGameStatEntries:game.id];
        cell.nameLabel.text = player.numberLogname;
        cell.playerImage.image = [player getImage:@"tiny"];
    } else {
        stats = [[BasketballStats alloc] init];
        cell.nameLabel.text = @"Totals";
        cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row < currentSettings.roster.count) {
            if (stats) {
                cell.fgmLabel.text = [stats.twomade stringValue];
                cell.fgaLabel.text = [stats.twoattempt stringValue];
                
                if ([stats.twomade intValue] > 0)
                    cell.fgpLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.twomade intValue] / (float)[stats.twoattempt intValue]];
                else
                    cell.fgpLabel.text = @"0.00";
                
                cell.threepmLabel.text = [stats.threemade stringValue];
                cell.threepaLabel.text = [stats.threeattempt stringValue];
                
                if ([stats.threemade intValue] > 0)
                    cell.threepctLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.threemade intValue] / (float)[stats.threeattempt intValue]];
                else
                    cell.threepctLabel.text = @"0.00";
                
                cell.ftmLabel.text = [stats.ftmade stringValue];
                cell.ftaLabel.text = [stats.ftattempt stringValue];
                
                if ([stats.ftmade intValue] > 0)
                    cell.ftpctLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.ftmade intValue] / (float)[stats.ftattempt intValue]];
                else
                    cell.ftpctLabel.text = @"0.00";
                
                cell.pointsLabel.text = [NSString stringWithFormat:@"%D",([stats.twomade intValue] * 2) + ([stats.threemade intValue] * 3) +
                                         [stats.ftmade intValue]];
            } else {
                cell.fgmLabel.text = @"0";
                cell.fgaLabel.text = @"0";
                cell.fgpLabel.text = @"0.00";
                cell.threepmLabel.text = @"0";
                cell.threepaLabel.text = @"0";
                cell.threepctLabel.text = @"0.00";
                cell.ftmLabel.text = @"0";
                cell.ftaLabel.text = @"0";
                cell.ftpctLabel.text = @"0.00";
                cell.pointsLabel.text = @"0";
            }
        } else {
            int fgm = 0, fga = 0, threefgm = 0, threefga = 0, ftm = 0, fta = 0, points = 0;
            float fgp = 0.0, threefgp = 0.0, ftp = 0.0;
            
            for (int i = 0; i < currentSettings.roster.count; i++) {
                BasketballStats *astat = [[currentSettings.roster objectAtIndex:i] findBasketballGameStatEntries:game.id];
                fgm += [astat.twomade intValue];
                fga += [astat.twoattempt intValue];
                
                if ([astat.twomade intValue] > 0)
                    fgp += [astat.twomade floatValue]/[astat.twoattempt floatValue];
                
                threefga += [astat.threeattempt intValue];
                threefgm += [astat.threemade intValue];
                
                if ([astat.threemade intValue] > 0)
                    threefgp += [astat.threemade floatValue]/[astat.threeattempt floatValue];
                
                ftm += [astat.ftmade intValue];
                fta += [astat.ftattempt intValue];
                
                if ([astat.ftmade intValue] > 0)
                    ftp += [astat.ftmade floatValue]/[astat.ftattempt floatValue];
                
                points += ([astat.threemade intValue] * 3) + ([astat.twomade intValue] * 2) + [astat.ftmade intValue];
            }
            
            cell.fgmLabel.text = [NSString stringWithFormat:@"%d", fgm];
            cell.fgaLabel.text = [NSString stringWithFormat:@"%d", fga];
            cell.fgpLabel.text = [NSString stringWithFormat:@"%.2f", fgp];
            cell.threepmLabel.text = [NSString stringWithFormat:@"%d", threefgm];
            cell.threepaLabel.text = [NSString stringWithFormat:@"%d", threefga];
            cell.threepctLabel.text = [NSString stringWithFormat:@"%.2f", threefgp];
            cell.ftmLabel.text = [NSString stringWithFormat:@"%d", ftm];
            cell.ftaLabel.text = [NSString stringWithFormat:@"%d", fta];
            cell.ftpctLabel.text = [NSString stringWithFormat:@"%.2f", ftp];
            cell.pointsLabel.text = [NSString stringWithFormat:@"%d", points];
        }
    } else {
        if (indexPath.row < currentSettings.roster.count) {
            if (stats) {
                cell.fgmLabel.text = [stats.fouls stringValue];
                cell.fgaLabel.text = [stats.offrebound stringValue];
                cell.fgpLabel.text = [stats.defrebound stringValue];
                cell.threepmLabel.text = [stats.assists stringValue];
                cell.threepaLabel.text = [stats.steals stringValue];
                cell.threepctLabel.text = [stats.blocks stringValue];
                cell.ftmLabel.text = [stats.turnovers stringValue];
                cell.ftaLabel.text = @"";
                cell.ftpctLabel.text = @"";
                cell.pointsLabel.text = @"";
            } else {
                cell.fgmLabel.text = @"0";
                cell.fgaLabel.text = @"0";
                cell.fgpLabel.text = @"0.00";
                cell.threepmLabel.text = @"0";
                cell.threepaLabel.text = @"0";
                cell.threepctLabel.text = @"0.00";
                cell.ftmLabel.text = @"0";
                cell.ftaLabel.text = @"0";
                cell.ftpctLabel.text = @"0.00";
                cell.pointsLabel.text = @"0";
            }
        } else {
            int fouls = 0, orb = 0, drb = 0, assist = 0, steals = 0, blocks = 0, turnovers = 0;
            
            for (int i = 0; i < currentSettings.roster.count; i++) {
                BasketballStats *astat = [[currentSettings.roster objectAtIndex:i] findBasketballGameStatEntries:game.id];
                fouls += [astat.fouls intValue];
                orb += [astat.offrebound intValue];
                drb += [astat.defrebound intValue];
                assist += [astat.assists intValue];
                steals += [astat.steals intValue];
                blocks += [astat.blocks intValue];
                turnovers += [astat.turnovers intValue];
            }
            
            cell.fgmLabel.text = [NSString stringWithFormat:@"%d", fouls];
            cell.fgaLabel.text = [NSString stringWithFormat:@"%d", orb];
            cell.fgpLabel.text = [NSString stringWithFormat:@"%d", drb];
            cell.threepmLabel.text = [NSString stringWithFormat:@"%d", assist];
            cell.threepaLabel.text = [NSString stringWithFormat:@"%d", steals];
            cell.threepctLabel.text = [NSString stringWithFormat:@"%d", blocks];
            cell.ftmLabel.text = [NSString stringWithFormat:@"%d", turnovers];
            cell.ftaLabel.text = @"";
            cell.ftpctLabel.text = @"";
            cell.pointsLabel.text = @"";
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (game)
            return @"              Player                         FGM     FGA      FGP    3PA     3PM      3FGP  FTM     FTA       FTP  PTS";
        else
            return @"              Game                           FGM     FGA      FGP    3PA     3PM      3FGP  FTM     FTA       FTP  PTS";
    } else {
        if (game)
            return @"              Player                       FOULS    ORB    DRB     AST      STL    BLK      TO";
        else
            return @"              Game                         FOULS    ORB    DRB     AST      STL    BLK      TO";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (game) {
        if (indexPath.section == 0) {
            if (indexPath.row < currentSettings.roster.count) {
                liveStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
                liveStatsController.game = game;
                [liveStatsController viewWillAppear:YES];
                _basketballLiveStatsContainer.hidden = NO;
            }
       } else {
           if (indexPath.row < currentSettings.roster.count) {
                nonscoreStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
                nonscoreStatsController.game = game;
                _nonscoreStatsContainer.hidden = NO;
                [nonscoreStatsController viewWillAppear:YES];
           }
       }
//    } else if (athlete) {
//        liveStatsController.player = athlete;
//        liveStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"  message:@"Select game to update stats for player!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (athlete) {
            totalStatsController.player = athlete;
            totalStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        } else {
            totalStatsController.game = game;
            totalStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        }
        
        [totalStatsController viewWillAppear:YES];
        _basketballTotalStatsContainer.hidden = NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Enter Totals";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LiveStatsSegue"]) {
        liveStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TotalStatsSegue"]) {
        totalStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"NonscoreStatsSegue"]) {
        nonscoreStatsController = segue.destinationViewController;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _homeScoreTextField) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Score automatically computed from stats!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        [textField resignFirstResponder];
    } else if (textField == _homeFoulsTextField) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fouls automatically computed from stats!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        [textField resignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _minutesTextField) {
        game.currentgametime = _gameclockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
    } else if (textField == _secondsTextField) {
        game.currentgametime = _gameclockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
    } else if (textField == _visitorScoreTextField) {
        _visitorScoreLabel.text = _visitorScoreTextField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _homeFoulsTextField) ||
        (textField == _visitorFoulsTextField) || (textField == _homeScoreTextField) || (textField == _visitorScoreTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx)
            
            if ((textField == _minutesTextField) || (textField == _secondsTextField)) {
                return (newLength > 2) ? NO : YES;
            } else {
                return (newLength > 3) ? NO : YES;
            }
            else
                return NO;
    } else
        return YES;
}

- (IBAction)firstPeriodButtonClicked:(id)sender {
    game.period = [NSNumber numberWithInt: 1];
    _firstPeriodButton.backgroundColor = [UIColor redColor];
    _secondPeriodButton.backgroundColor = [UIColor whiteColor];
    _thirdPeriodButton.backgroundColor = [UIColor whiteColor];
    _fourthPeriodButton.backgroundColor = [UIColor whiteColor];
    _firstPeriodButton.selected = YES;
    _secondPeriodButton.selected = NO;
    _thirdPeriodButton.selected = NO;
    _fourthPeriodButton.selected = NO;
}

- (IBAction)secondPeriodButtonClicked:(id)sender {
    game.period = [NSNumber numberWithInt: 2];
    _firstPeriodButton.backgroundColor = [UIColor whiteColor];
    _secondPeriodButton.backgroundColor = [UIColor redColor];
    _thirdPeriodButton.backgroundColor = [UIColor whiteColor];
    _fourthPeriodButton.backgroundColor = [UIColor whiteColor];
    _firstPeriodButton.selected = NO;
    _secondPeriodButton.selected = YES;
    _thirdPeriodButton.selected = NO;
    _fourthPeriodButton.selected = NO;
}

- (IBAction)thirdPeriodButtonClicked:(id)sender {
    game.period = [NSNumber numberWithInt: 3];
    _firstPeriodButton.backgroundColor = [UIColor whiteColor];
    _secondPeriodButton.backgroundColor = [UIColor whiteColor];
    _thirdPeriodButton.backgroundColor = [UIColor redColor];
    _fourthPeriodButton.backgroundColor = [UIColor whiteColor];
    _firstPeriodButton.selected = NO;
    _secondPeriodButton.selected = NO;
    _thirdPeriodButton.selected = YES;
    _fourthPeriodButton.selected = NO;
}

- (IBAction)fourthPeriodButtonClicked:(id)sender {
    game.period = [NSNumber numberWithInt: 4];
    _firstPeriodButton.backgroundColor = [UIColor whiteColor];
    _secondPeriodButton.backgroundColor = [UIColor whiteColor];
    _thirdPeriodButton.backgroundColor = [UIColor whiteColor];
    _fourthPeriodButton.backgroundColor = [UIColor redColor];
    _firstPeriodButton.selected = NO;
    _secondPeriodButton.selected = NO;
    _thirdPeriodButton.selected = NO;
    _fourthPeriodButton.selected = YES;
}

- (IBAction)homeBonusButton:(id)sender {
    if (!_leftBonusImage.hidden) {
        _leftBonusImage.hidden = YES;
        game.homebonus = NO;
    } else {
        _leftBonusImage.hidden = NO;
        game.homebonus = YES;
    }
}

- (IBAction)visitorBonusButton:(id)sender {
    if (!_rightBonusImage.hidden) {
        _rightBonusImage.hidden = YES;
        game.visitorbonus = NO;
    } else {
        _rightBonusImage.hidden = NO;
        game.visitorbonus = YES;
    }
}

- (IBAction)saveClockButtonClicked:(id)sender {
}

- (IBAction)possessionArrorButtonClicked:(id)sender {
    if ([game.possession isEqualToString:@"Home"]) {
        _homePossessionArrow.hidden = YES;
        _visitorPossessionArrow.hidden = NO;
        game.possession = @"Visitor";
    } else {
        _homePossessionArrow.hidden = NO;
        _visitorPossessionArrow.hidden = YES;
        game.possession = @"Home";
    }
}

- (IBAction)nonscoreBasketballPlayerStats:(UIStoryboardSegue *)segue {
    _nonscoreStatsContainer.hidden = YES;
    [nonscoreStatsController.player updateBasketballGameStats:nonscoreStatsController.stats];    
    [_basketballTableView reloadData];
    [self viewWillAppear:YES];
}

@end
