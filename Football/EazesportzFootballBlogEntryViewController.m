//
//  EazesportzFootballBlogEntryViewController.m
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballBlogEntryViewController.h"
#import "EazesportzGameLogViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballBlogEntryViewController ()

@end

@implementation EazesportzFootballBlogEntryViewController {
    EazesportzGameLogViewController *gamelogController;
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
    _gameplayTextField.inputView = _gamelogContainer.inputView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _gamelogContainer.hidden = YES;
    
    if (self.blog.gamelog.length > 0) {
        [_gameplayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _gameplayButton.enabled = YES;
        _gameplayTextField.text = [[[currentSettings findGame:self.blog.gameschedule] findGamelog:self.blog.gamelog] logentrytext];
    } else {
        _gameplayButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _gameplayTextField) {
        [textField resignFirstResponder];
        if (self.gameSelectionController.thegame) {
            _gamelogContainer.hidden = NO;
            gamelogController.game = self.gameSelectionController.thegame;
            gamelogController.gamelog = nil;
            [gamelogController viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Select a game before tagging by play"
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
    }
}

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue {
    if (gamelogController.gamelog) {
        self.blog.gamelog = gamelogController.gamelog.gamelogid;
        _gameplayTextField.text = gamelogController.gamelog.logentrytext;
        _gameplayButton.enabled = YES;
        [_gameplayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        self.blog.gamelog = nil;
        _gameplayTextField.text = @"";
    }
    _gamelogContainer.hidden = YES;
}

@end
