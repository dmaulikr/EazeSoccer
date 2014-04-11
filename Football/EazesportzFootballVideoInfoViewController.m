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

@interface EazesportzFootballVideoInfoViewController ()

@end

@implementation EazesportzFootballVideoInfoViewController {
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
    _gameplayTextField.inputView = _gameplayContainer.inputView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _gameplayContainer.hidden = YES;
    
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        if (self.video.gamelog) {
            _gameplayTextField.text = [[[currentSettings findGame:self.video.schedule] findGamelog:self.video.gamelog] logentrytext];
        } else {
            _gameplayTextField.text = @"";
        }
    } else {
        _gameplayTextField.enabled = NO;
        _gameplayTextField.hidden = YES;
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
            _gameplayContainer.hidden = NO;
            gamelogController.game = self.video.game;
            gamelogController.gamelog = nil;
            [gamelogController viewWillAppear:YES];
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

@end
