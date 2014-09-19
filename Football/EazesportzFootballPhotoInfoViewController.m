//
//  EazesportzFootballPhotoInfoViewController.m
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballPhotoInfoViewController.h"
#import "EazesportzGameLogViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzScoreLogViewController.h"

@interface EazesportzFootballPhotoInfoViewController ()

@end

@implementation EazesportzFootballPhotoInfoViewController {
    EazesportzGameLogViewController *gamelogController;
    EazesportzScoreLogViewController *scorelogController;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
        _gameplayTextField.enabled = NO;
        _gameplayTextField.hidden = YES;
    }
    
    if (![currentSettings.sport.name isEqualToString:@"Basketball"])
        _gameplayTextField.inputView = _gamelogContainer.inputView;

    _gamelogContainer.hidden = YES;
    _scorelogContainer.hidden = YES;
    
    GameSchedule *game = [currentSettings findGame:self.photo.schedule];
    
    if (self.photo.gamelog.length > 0) {
        _gameplayTextField.text = [[game findGamelog:self.photo.gamelog] logentrytext];
    } else if (self.photo.lacross_scoring_id.length > 0) {
        _gameplayTextField.text = [game.lacross_game findScoreLog:self.photo.lacross_scoring_id];
    } else if (self.photo.hockey_scoring_id.length > 0) {
        _gameplayTextField.text = [game.hockey_game findScoreLog:self.photo.hockey_scoring_id];
    } else {
        _gameplayTextField.text = @"";
    }
}

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue {
    if (gamelogController.gamelog) {
        self.photo.gamelog = gamelogController.gamelog.gamelogid;
        _gameplayTextField.text = gamelogController.gamelog.logentrytext;
    } else {
        self.photo.gamelog = @"";
        _gameplayTextField.text = @"";
    }
    
    _gamelogContainer.hidden = YES;
}

- (IBAction)scoreLogSelected:(UIStoryboardSegue *)segue {

    if (scorelogController.lacrosse_score) {
        self.photo.lacross_scoring_id = scorelogController.lacrosse_score.lacross_scoring_id;
        _gameplayTextField.text = [scorelogController.lacrosse_score getScoreLog];
    } else if (scorelogController.soccer_score) {
        self.photo.soccer_scoring_id = scorelogController.soccer_score.soccer_scoring_id;
        _gameplayTextField.text = [scorelogController.soccer_score getScoreLog];
    } else if (scorelogController.hockey_score) {
        self.photo.hockey_scoring_id = scorelogController.hockey_score.hockey_scoring_id;
        _gameplayTextField.text = [scorelogController.hockey_score getScoreLog];
    } else {
        self.photo.lacross_scoring_id = @"";
        _gameplayTextField.text = @"";
    }
    
    _scorelogContainer.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _gameplayTextField) {
        [textField resignFirstResponder];
        
        if (self.photo.game) {
            if ([currentSettings.sport.name isEqualToString:@"Football"]) {
                _gamelogContainer.hidden = NO;
                gamelogController.game = self.photo.game;
                gamelogController.gamelog = nil;
                [gamelogController viewWillAppear:YES];
            } else if (([currentSettings.sport.name isEqualToString:@"Lacrosse"]) || ([currentSettings.sport.name isEqualToString:@"Soccer"]) ||
                       ([currentSettings.sport.name isEqualToString:@"Hockey"])) {
                _scorelogContainer.hidden = NO;
                scorelogController.game = self.photo.game;
                scorelogController.lacrosse_score = nil;
                [scorelogController viewWillAppear:YES];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Select a game before tagging photo by play"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        [super textFieldDidBeginEditing:textField];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"GamelogSelectSegue"]) {
        gamelogController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"ScoreLogSegue"]) {
        scorelogController = segue.destinationViewController;
    }
}

@end
