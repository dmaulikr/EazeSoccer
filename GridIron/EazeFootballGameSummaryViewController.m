//
//  EazeFootballGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeFootballGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeFootballGameStatsViewController.h"
#import "EazesportzGetGame.h"
#import "EazesportzRetrieveAlerts.h"
#import "EazesVideosViewController.h"
#import "EazePhotosViewController.h"

@interface EazeFootballGameSummaryViewController () <UIAlertViewDelegate>

@end

@implementation EazeFootballGameSummaryViewController {
    EazesportzGetGame *getGame;
    NSString *quarter;
    
    NSIndexPath *deleteIndexPath;
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
    
    if (currentSettings.isSiteOwner)
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, self.saveGameButton, nil];
    else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, nil];
    
    self.navigationController.toolbarHidden = YES;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeTimeOutTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTimeOutTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _downTextField.keyboardType = UIKeyboardTypeNumberPad;
    _ballonTextField.keyboardType = UIKeyboardTypeNumberPad;
    _togoTextField.keyboardType = UIKeyboardTypeNumberPad;
    _quarterTextField.keyboardType = UIKeyboardTypeNumberPad;
    _lastplayLabel.numberOfLines = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    _clockLabel.text = [game currentgametime];
    
    [self textFieldConfiguration:_secondsTextField];
    [self textFieldConfiguration:_minutesTextField];
    [self textFieldConfiguration:_visitorScoreTextField];
    [self textFieldConfiguration:_homeTimeOutTextField];
    [self textFieldConfiguration:_visitorTimeOutTextField];
    [self textFieldConfiguration:_downTextField];
    [self textFieldConfiguration:_quarterTextField];
    [self textFieldConfiguration:_ballonTextField];
    [self textFieldConfiguration:_togoTextField];
    [self textFieldConfiguration:_homeScoreTextField];
    
    NSArray *gametime = [game.currentgametime componentsSeparatedByString:@":"];
    _minutesTextField.text = [gametime objectAtIndex:0];
    _secondsTextField.text = [gametime objectAtIndex:1];
    _visitorScoreTextField.text = [game.opponentscore stringValue];
    _homeTimeOutTextField.text = [game.hometimeouts stringValue];
    _visitorTimeOutTextField.text = [game.opponenttimeouts stringValue];
    _togoTextField.text = [game.togo stringValue];
    _ballonTextField.text = [game.ballon stringValue];
    _downTextField.text = [game.down stringValue];
    _quarterTextField.text = [game.period stringValue];
    _homeImage.image = [currentSettings.team getImage:@"tiny"];
    _lastplayLabel.text = game.lastplay;
    
    if (game.editHomeScore)
        _homeScoreTextField.text = [game.homescore stringValue];
    else
        _homeScoreTextField.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    
    if ([currentSettings getOpponentImage:game] == nil) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:game.opponentpic]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                _visitorImage.image = [UIImage imageWithData:image];
            });
        });
    } else {
        [_visitorImage setImage:[currentSettings getOpponentImage:game]];
    }

    [_homeMascotButton setTitle:currentSettings.team.mascot forState:UIControlStateNormal];
    [_visitorMascotButton setTitle:game.opponent_mascot forState:UIControlStateNormal];
//    _homeScoreLabel.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    _sumhomeLabel.text = currentSettings.team.mascot;
    _sumvisitorLabel.text = game.opponent_mascot;
    _hq1Label.text = [game.homeq1 stringValue];
    _hq2Label.text = [game.homeq2 stringValue];
    _hq3Label.text = [game.homeq3 stringValue];
    _hq4Label.text = [game.homeq4 stringValue];
    _vq1Label.text = [game.opponentq1 stringValue];
    _vq2Label.text = [game.opponentq2 stringValue];
    _vq3Label.text = [game.opponentq3 stringValue];
    _vq4Label.text = [game.opponentq4 stringValue];
    _htotalLabel.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    _vtotalLabel.text = [NSString stringWithFormat:@"%d", [game.opponentq4 intValue] + [game.opponentq3 intValue] +
                         [game.opponentq2 intValue] + [game.opponentq1 intValue]];
    
    if (currentSettings.isSiteOwner) {
        _visitorMascotButton.enabled = YES;
        _homeMascotButton.enabled = YES;
    } else {
        _visitorMascotButton.enabled = NO;
        _homeMascotButton.enabled = NO;
        [_visitorMascotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_homeMascotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if ([game.possession isEqualToString:currentSettings.team.mascot]) {
        _homePossessionImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"footballpossessionimage.png"], 1)];
        _visitorPossessionImage.hidden = YES;
    } else {
        _visitorPossessionImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"footballpossessionimage.png"], 1)];
        _homePossessionImage.hidden = YES;
    }
    
    [_gamelogTableView reloadData];
}

- (void)textFieldConfiguration:(UITextField *)textField {
    if (currentSettings.isSiteOwner) {
        if (textField == _homeScoreTextField) {
            if (game.editHomeScore) {
                textField.enabled = YES;
                textField.backgroundColor = [UIColor whiteColor];
                textField.textColor = [UIColor blackColor];
            } else {
                textField.enabled = NO;
                textField.backgroundColor = [UIColor blackColor];
                textField.textColor = [UIColor yellowColor];
            }
        } else {
            textField.enabled = YES;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor blackColor];
        }
    } else {
        textField.enabled = NO;
        textField.backgroundColor = [UIColor blackColor];
        textField.textColor = [UIColor yellowColor];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([currentSettings isSiteOwner])
        return @"Score Log - Swipe to Delete";
    else
        return @"Score Log";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[game gamelogs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GameLogTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Gamelogs *log = [[game gamelogs] objectAtIndex:indexPath.row];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    else
        cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    cell.textLabel.text = [log logentrytext];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor darkGrayColor];
    
    if ((log.hasphotos) || (log.hasvideos)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Gamelogs *log = [game.gamelogs objectAtIndex:indexPath.row];
    
    if ((log.hasphotos) && (log.hasvideos)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Media" message:@"Select Photos or Videos" delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Photos", @"Videos", nil];
        [alert show];
    } else if (log.hasvideos) {
        [self performSegueWithIdentifier:@"GameVideoSegue" sender:self];
    } else if (log.hasphotos) {
        [self performSegueWithIdentifier:@"GamePhotoSegue" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([currentSettings isSiteOwner]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            deleteIndexPath = indexPath;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Stats will be automatically updated. Click Confirm to Proceed"
                                                           delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FootballGameStatsSegue"]) {
        EazeFootballGameStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"GamePhotoSegue"]) {
        EazePhotosViewController *destController = segue.destinationViewController;
        destController.game = game;
        currentSettings.photodeleted = YES;
    } else if ([segue.identifier isEqualToString:@"GameVideoSegue"]) {
        EazesVideosViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add TD"]) {
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
    } else if ([title isEqualToString:@"Delete TD"]) {
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
    } else if ([title isEqualToString:@"Add FG"]) {
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
    } else if ([title isEqualToString:@"Delete FG"]) {
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
    } else if ([title isEqualToString:@"Add XP"]) {
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
    } else if ([title isEqualToString:@"Delete XP"]) {
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
    } else if ([title isEqualToString:@"Confirm"]) {
        [[game.gamelogs objectAtIndex:deleteIndexPath.row] initDeleteGameLog];
        [game.gamelogs removeObjectAtIndex:deleteIndexPath.row];
        [self viewWillAppear:YES];
    } else if ([title isEqualToString:@"Photos"])
        [self performSegueWithIdentifier:@"GamePhotoSegue" sender:self];
    else if ([title isEqualToString:@"Videos"])
        [self performSegueWithIdentifier:@"GameVideoSegue" sender:self];
}

- (void)scoreType {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Score"  message:@"Score Type" delegate:self cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"Add TD", @"Delete TD", @"Add FG", @"Delete FG", @"Add XP", @"Delete XP", @"Add 2PT", @"Delete 2PT", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)refreshButtonClicked:(id)sender {
    getGame = [[EazesportzGetGame alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotGame:) name:@"GameDataNotification" object:nil];
    [getGame getGame:currentSettings.sport.id Team:currentSettings.team.teamid Game:game.id Token:currentSettings.user.authtoken];
    
    if (currentSettings.user.userid.length > 0) {
        [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid
                                                          Token:currentSettings.user.authtoken];
    }
}

- (void)gotGame:(NSNotification *)notification {
    game = getGame.game;
    [self viewWillAppear:YES];
}

- (IBAction)statsButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"FootballGameStatsSegue" sender:self];
}

- (IBAction)saveGameButtonClicked:(id)sender {
    game.currentgametime = [NSString stringWithFormat:@"%@:%@", _minutesTextField.text, _secondsTextField.text];
    game.opponenttimeouts = [NSNumber numberWithInt:[_visitorTimeOutTextField.text intValue]];
    game.hometimeouts = [NSNumber numberWithInt:[_homeTimeOutTextField.text intValue]];
    game.down = [NSNumber numberWithInt:[_downTextField.text intValue]];
    game.togo = [NSNumber numberWithInt:[_togoTextField.text intValue]];
    game.period = [NSNumber numberWithInt:[_quarterTextField.text intValue]];
    game.ballon = [NSNumber numberWithInt:[_ballonTextField.text intValue]];
    [game saveGameschedule];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _visitorScoreTextField) || (textField == _minutesTextField) || (_secondsTextField) ||
        (_homeTimeOutTextField) || (_visitorTimeOutTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _ballonTextField) ||
                (textField == _togoTextField)) {
                return (newLength > 2) ? NO : YES;
            } else if ((textField == _quarterTextField) || (textField == _downTextField) || (textField == _visitorTimeOutTextField) ||
                       (textField == _homeTimeOutTextField)) {
                return (newLength > 1) ? NO : YES;
            } else if (textField == _visitorScoreTextField) {
                return (newLength > 3 ? NO : YES);
            } else
                return NO;
        } else
            return NO;
    } else
        return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _visitorScoreTextField) {
        [textField resignFirstResponder];
        UIAlertView *visitoralert = [[UIAlertView alloc] initWithTitle:@"Visitor Score" message:@"Enter Score" delegate:self
                                                    cancelButtonTitle:@"Cancel" otherButtonTitles:@"Q1", @"Q2", @"Q3", @"Q4", nil];
        [visitoralert show];
    } else {
        textField.text = @"";
    }
}

- (IBAction)homeMascotButtonClicked:(id)sender {
    game.possession = currentSettings.team.mascot;
    _homePossessionImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"footballpossessionimage.png"], 1)];
    _visitorPossessionImage.hidden = YES;
    _homePossessionImage.hidden = NO;
}

- (IBAction)visitorMascotButtonClicked:(id)sender {
    game.possession = game.opponent_mascot;
    _visitorPossessionImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"footballpossessionimage.png"], 1)];
    _homePossessionImage.hidden = YES;
    _visitorPossessionImage.hidden = NO;
}

@end
