//
//  EazesportzFootballVideoInfoViewController.m
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballVideoInfoViewController.h"
#import "EazesportzGameLogViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzScoreLogViewController.h"

@interface EazesportzFootballVideoInfoViewController ()

@end

@implementation EazesportzFootballVideoInfoViewController {
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
    _gameplayTextField.inputView = _gameplayContainer.inputView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((![currentSettings.sport.name isEqualToString:@"Football"]) && (![currentSettings.sport.name isEqualToString:@"Lacrosse"])) {
        _gameplayTextField.enabled = NO;
        _gameplayTextField.hidden = YES;
    }
    
    if ([currentSettings.sport.name isEqualToString:@"Football"])
        _gameplayTextField.inputView = _gameplayContainer.inputView;
    else if ([currentSettings.sport.name isEqualToString:@"Lacrosse"])
        _gameplayTextField.inputView = _scorelogContainer.inputView;
    
    _gameplayContainer.hidden = YES;
    _scorelogContainer.hidden = YES;
    
    GameSchedule *game = [currentSettings findGame:self.video.schedule];
    
    if (self.video.gamelog.length > 0) {
        _gameplayTextField.text = [[game findGamelog:self.video.gamelog] logentrytext];
    } else if (self.video.lacross_scoring_id.length > 0) {
        _gameplayTextField.text = [game.lacross_game findScoreLog:self.video.lacross_scoring_id];
    } else {
        _gameplayTextField.text = @"";
    }
}

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue {
    if (gamelogController.gamelog) {
        self.video.gamelog = gamelogController.gamelog.gamelogid;
        _gameplayTextField.text = gamelogController.gamelog.logentrytext;
    } else {
        self.video.gamelog = @"";
        _gameplayTextField.text = @"";
    }
    _gameplayContainer.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _gameplayTextField) {
        [textField resignFirstResponder];
        
        if (self.video.game) {
            if ([currentSettings.sport.name isEqualToString:@"Football"]) {
                _gameplayContainer.hidden = NO;
                gamelogController.game = self.video.game;
                gamelogController.gamelog = nil;
                [gamelogController viewWillAppear:YES];
            } else if ([currentSettings.sport.name isEqualToString:@"Lacrosse"]) {
                _scorelogContainer.hidden = NO;
                scorelogController.game = self.video.game;
                scorelogController.lacrosse_score = nil;
                [scorelogController viewWillAppear:YES];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Select a game before tagging video by play"
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)scoreLogSelected:(UIStoryboardSegue *)segue {
    if (scorelogController.lacrosse_score) {
        self.video.lacross_scoring_id = scorelogController.lacrosse_score.lacross_scoring_id;
        _gameplayTextField.text = [scorelogController.lacrosse_score getScoreLog];
    } else {
        self.video.lacross_scoring_id = @"";
        _gameplayTextField.text = @"";
    }
    
    _scorelogContainer.hidden = YES;
}

@end
