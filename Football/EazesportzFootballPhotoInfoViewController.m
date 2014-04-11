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

@interface EazesportzFootballPhotoInfoViewController ()

@end

@implementation EazesportzFootballPhotoInfoViewController {
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
    
    if (![currentSettings.sport.name isEqualToString:@"Football"]) {
        _gameplayTextField.hidden = YES;
        _gameplayTextField.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _gamelogContainer.hidden = YES;
    
    if (self.photo.gamelog) {
        _gameplayTextField.text = [[[currentSettings findGame:self.photo.schedule] findGamelog:self.photo.gamelog] logentrytext];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _gameplayTextField) {
        [textField resignFirstResponder];
        if (self.photo.game) {
            _gamelogContainer.hidden = NO;
            gamelogController.game = self.photo.game;
            gamelogController.gamelog = nil;
            [gamelogController viewWillAppear:YES];
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
    }
}

@end
