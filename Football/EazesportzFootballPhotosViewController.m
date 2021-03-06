//
//  EazesportzFootballPhotosViewController.m
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballPhotosViewController.h"
#import "EazesportzGameLogViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballPhotosViewController ()

@end

@implementation EazesportzFootballPhotosViewController {
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
        NSURL *url = [NSURL URLWithString:[sportzServerInit getGameLogPhotos:gamelog.gamelogid Team:currentSettings.team.teamid
                     Token:currentSettings.user.authtoken]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.activityIndicator startAnimating];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else {
        [self getPhotos];
    }
    _gamelogContainer.hidden = YES;
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Photo Search Criteria"
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
