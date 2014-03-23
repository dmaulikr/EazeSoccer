//
//  EazesportzFootballVideosViewController.m
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballVideosViewController.h"
#import "EazesportzGameLogViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballVideosViewController ()

@end

@implementation EazesportzFootballVideosViewController {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _gamelogContainer.hidden = YES;
}

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue {
    if (gamelogController.gamelog) {
        self.gamelog = gamelogController.gamelog;
    }
    
    _gamelogContainer.hidden = YES;
    [self viewWillAppear:YES];
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"  message:@"Select Video Search Criteria"
                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"Play", @"User", @"All", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Play"]) {
        if (self.game) {
            _gamelogContainer.hidden = NO;
            gamelogController.game = self.game;
            gamelogController.gamelog = nil;
            [gamelogController viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Select a game before searching by play"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"GamelogSelectSegue"]) {
        gamelogController = segue.destinationViewController;
    }
}

@end
