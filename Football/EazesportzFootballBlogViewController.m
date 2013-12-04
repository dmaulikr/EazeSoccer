//
//  EazesportzFootballBlogViewController.m
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballBlogViewController.h"
#import "EazesportzGameLogViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballBlogViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzFootballBlogViewController {
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
        [self getBlogs:nil];
    }
    _gamelogContainer.hidden = YES;
}

- (IBAction)searchBurronClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Search Criteria"
                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"Play", @"User", @"Coach", @"All", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"GamelogSelectSegue"]) {
        gamelogController = segue.destinationViewController;
    }
}

- (void)getBlogs:(NSString *)fromdate {
    if (gamelogController.gamelog) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURL *url = [NSURL URLWithString:[sportzServerInit getBigPlayBlogs:gamelogController.gamelog.gamelogid updatedAt:fromdate
                                                                      Token:currentSettings.user.authtoken]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.activityIndicator startAnimating];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else {
        [super getBlogs:fromdate];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Play"]) {
        if (self.gameController.thegame) {
            self.game = nil;
            self.team = nil;
            _gamelogContainer.hidden = NO;
            gamelogController.game = self.gameController.thegame;
            [gamelogController viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Select a game before searching by play"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        gamelog = nil;
        [super alertView:alertView clickedButtonAtIndex:(NSInteger)buttonIndex];
    }
}

@end
