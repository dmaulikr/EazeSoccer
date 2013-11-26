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

@interface BasketballStatsViewController ()

@end

@implementation BasketballStatsViewController {
    LiveBasketballStatsViewController *liveStatsController;
    BasketballTotalStatsViewController *totalStatsController;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:@"Make sure to press SAVE to post stats to cloud. \n Swipe cell to enter stats by total"
                                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (athlete)
        return [currentSettings.gameList count];
    else
        return [currentSettings.roster count];
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
    BOOL hasstats = NO;
    
    if (athlete) {
        GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
        stats = [athlete findBasketballGameStatEntries:agame.id];
        cell.nameLabel.text = agame.opponent;
        cell.playerImage.image = [agame opponentImage];
    } else {
        Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
        stats = [player findBasketballGameStatEntries:game.id];
        cell.nameLabel.text = player.numberLogname;
        cell.playerImage.image = [player getImage:@"tiny"];
    }
    
    if (stats) {
        hasstats = YES;
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
        
        cell.foulLabel.text = [stats.fouls stringValue];
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
        cell.foulLabel.text = @"0";
        cell.pointsLabel.text = @"0";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (game)
        return @"              Player                FGM    FGA      FGP   3PA    3PM       3FGP  FTM     FTA        FTP  FOULS POINTS";
    else
        return @"              Game                  FGM    FGA      FGP   3PA    3PM       3FGP  FTM     FTA        FTP  FOULS POINTS";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (game) {
        liveStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        liveStatsController.game = game;
    } else if (athlete) {
        liveStatsController.player = athlete;
        liveStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"  message:@"Select game to update stats for player!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    [liveStatsController viewWillAppear:YES];
    _basketballLiveStatsContainer.hidden = NO;
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

@end
