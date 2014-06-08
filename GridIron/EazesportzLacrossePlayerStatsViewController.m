//
//  EazesportzLacrossePlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/1/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrossePlayerStatsViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzLacrossePlayerStatsViewController ()

@end

@implementation EazesportzLacrossePlayerStatsViewController {
    NSArray *periodarray;
    Lacrosstat *stats;
    LacrossPlayerStat *playerstat;
    int selectedPeriod;
}

@synthesize game;
@synthesize visitingPlayer;
@synthesize player;

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
    _groundBallTextField.keyboardType = UIKeyboardTypeNumberPad;
    _turnoverTextField.keyboardType = UIKeyboardTypeNumberPad;
    _causedTurnoverTextField.keyboardType = UIKeyboardTypeNumberPad;
    _stealsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _faceoffwonTextField.keyboardType = UIKeyboardTypeNumberPad;
    _faceofflostTextField.keyboardType = UIKeyboardTypeNumberPad;

    periodarray = [[currentSettings.sport.lacrosse_periods allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[currentSettings.sport.lacrosse_periods objectForKey:obj1] compare:[currentSettings.sport.lacrosse_periods objectForKey:obj2]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _saveImage.hidden = YES;
    
    if (visitingPlayer) {
        stats = [visitingPlayer findLacrossStat:game];
        _playerStatsNavigationItem.title = visitingPlayer.numberlogname;
    } else {
        stats = [player findLacrosstat:game];
        _playerStatsNavigationItem.title = player.numberLogname;
    }
    
    _groundBallTextField.text = @"0";
    _turnoverTextField.text = @"0";
    _causedTurnoverTextField.text = @"0";
    _stealsTextField.text = @"0";
    _faceoffwonTextField.text = @"0";
    _faceofflostTextField.text = @"0";
    _faceoffviolationTextField.text = @"0";
    
    [_periodSegmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

- (IBAction)saveButtonClicked:(id)sender {
    if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:selectedPeriod]]) {
        playerstat = [stats.player_stats objectAtIndex:selectedPeriod - 1];
    } else {
        playerstat = [[LacrossPlayerStat alloc] init];
        playerstat.period = [NSNumber numberWithInt:selectedPeriod];
        playerstat.lacrosstat_id = stats.lacrosstat_id;
        
        if (visitingPlayer)
            playerstat.visitor_roster_id = visitingPlayer.visitor_roster_id;
        else
            playerstat.athlete_id = player.athleteid;
        
        [stats.player_stats addObject:playerstat];
    }
    
    playerstat.dirty = YES;
    
    playerstat.ground_ball = [NSNumber numberWithInt:[playerstat.ground_ball intValue] +
                              [_groundBallTextField.text intValue]];
    playerstat.turnover =[NSNumber numberWithInt:[playerstat.turnover intValue] +
                          [_turnoverTextField.text intValue]];
    playerstat.caused_turnover =[NSNumber numberWithInt:[playerstat.caused_turnover intValue] +
                          [_causedTurnoverTextField.text intValue]];
    playerstat.steals =[NSNumber numberWithInt:[playerstat.steals intValue] +
                                 [_stealsTextField.text intValue]];
    playerstat.face_off_won =[NSNumber numberWithInt:[playerstat.face_off_won intValue] +
                                 [_faceoffwonTextField.text intValue]];
    playerstat.face_off_lost =[NSNumber numberWithInt:[playerstat.face_off_lost intValue] +
                                 [_faceofflostTextField.text intValue]];
    playerstat.face_off_violation =[NSNumber numberWithInt:[playerstat.face_off_violation intValue] +
                                 [_faceoffviolationTextField.text intValue]];
    [playerstat save:currentSettings.sport Team:currentSettings.team Game:game User:currentSettings.user];
    [stats save:currentSettings.sport Game:game User:currentSettings.user];
    _saveImage.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    if (myStringMatchesRegEx)
        return YES;
    else
        return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _saveImage.hidden = YES;
}

- (IBAction)periodSegmentControlClicked:(id)sender {
    switch (_periodSegmentControl.selectedSegmentIndex) {
        case 0:
            selectedPeriod = 1;
            break;
            
        case 1:
            selectedPeriod = 2;
            break;
            
        case 2:
            selectedPeriod = 3;
            break;
            
        case 3:
            selectedPeriod = 4;
            break;
            
        default:
            selectedPeriod = 5;
            break;
    }
    
    [self populatePlayerStats];
}

- (IBAction)groundBallStepperClicked:(id)sender {
    _saveImage.hidden = YES;
    _groundBallTextField.text = [NSString stringWithFormat:@"%d", (int)_groundballStepper.value];
}

- (IBAction)turnoverStepperClicked:(id)sender {
    _saveImage.hidden = YES;
    _turnoverTextField.text = [NSString stringWithFormat:@"%d", (int)_turnoverStepper.value];
}

- (IBAction)causedTurnoverStepperClicked:(id)sender {
    _saveImage.hidden = YES;
    _causedTurnoverTextField.text = [NSString stringWithFormat:@"%d", (int)_causedturnoverStepper.value];
}

- (IBAction)stealsStepperClicked:(id)sender {
    _saveImage.hidden = YES;
    _stealsTextField.text = [NSString stringWithFormat:@"%d", (int)_stealsStepper.value];
}

- (void)populatePlayerStats {
    if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:selectedPeriod]]) {
        playerstat = [stats.player_stats objectAtIndex:selectedPeriod - 1];
    } else {
        playerstat = [[LacrossPlayerStat alloc] init];
        playerstat.period = [NSNumber numberWithInt:selectedPeriod];
        playerstat.lacrosstat_id = stats.lacrosstat_id;
        
        if (visitingPlayer)
            playerstat.visitor_roster_id = visitingPlayer.visitor_roster_id;
        else
            playerstat.athlete_id = player.athleteid;
        
        [stats.player_stats addObject:playerstat];
    }
    
    _groundBallTextField.text = [playerstat.ground_ball stringValue];
    _turnoverTextField.text = [playerstat.turnover stringValue];
    _causedTurnoverTextField.text = [playerstat.caused_turnover stringValue];
    _stealsTextField.text = [playerstat.steals stringValue];
    _faceoffwonTextField.text = [playerstat.face_off_won stringValue];
    _faceofflostTextField.text = [playerstat.face_off_lost stringValue];
    _faceoffviolationTextField.text = [playerstat.face_off_violation stringValue];
}

@end
