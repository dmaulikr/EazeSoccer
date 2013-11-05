//
//  NewsFeedEditViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "NewsFeedEditViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "PlayerSelectionViewController.h"
#import "CoachSelectionViewController.h"
#import "GameScheduleViewController.h"
#import "Athlete.h"
#import "Coach.h"
#import "EditCoachViewController.h"
#import "EditPlayerViewController.h"
#import "EditGameViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface NewsFeedEditViewController () <UIAlertViewDelegate>

@end

@implementation NewsFeedEditViewController {
    PlayerSelectionViewController *playerController;
    CoachSelectionViewController *coachController;
    GameScheduleViewController *gameController;
    
    BOOL newNewsFeed;
}

@synthesize newsitem;

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
    self.view.backgroundColor = [UIColor clearColor];
    
    _playerTextField.inputView = playerController.inputView;
    _coachTextField.inputView = coachController.inputView;
    _gameTextField.inputView = gameController.inputView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _playerSelectionContainer.hidden = YES;
    _coachSelectionContainer.hidden = YES;
    _gameSelectionContainer.hidden = YES;
    
    UIImage *image;
    
    if (newsitem) {
        newNewsFeed = NO;
        _newsTitleTextField.text = newsitem.title;
        _teamLabel.text = [[currentSettings findTeam:newsitem.team] team_name];
        
        if (newsitem.game.length > 0) {
            _gameTextField.text = [[currentSettings findGame:newsitem.game] game_name];
            _gameButton.enabled = YES;
        } else {
            _gameButton.enabled = NO;
        }
        
        if (newsitem.athlete.length > 0) {
            _playerTextField.text = [[currentSettings findAthlete:newsitem.athlete] full_name];
            _playerButton.enabled = YES;
        } else {
            _playerButton.enabled = NO;
        }
        
        if (newsitem.coach.length > 0) {
            _coachTextField.text = [[currentSettings findCoach:newsitem.coach] fullname];
            _coachButton.enabled = YES;
        } else {
            _coachButton.enabled = NO;
        }
        
        _newsTextView.text = newsitem.news;
        
        // Add image
                
        if (newsitem.athlete.length > 0) {
            image = [[currentSettings findAthlete:newsitem.athlete] getImage:@"thumb"];
        } else if (newsitem.coach.length > 0) {
            image = [[currentSettings findCoach:newsitem.coach] getImage:@"thumb"];
        } else if ([currentSettings.sport.sport_logo isEqualToString:@"sport_logo/large/missing.png"]) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"teambutton.png"], 1)];
        } else if (newsitem.team.length > 0) {
            image = [[currentSettings findTeam:newsitem.team] getImage:@"thumb"];
        } else {
            NSURL * imageURL = [NSURL URLWithString:currentSettings.sport.sport_logo];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
        }
    } else {
        newNewsFeed = YES;
        newsitem = [[Newsfeed alloc] init];
        _newsTextView.text = @"";
        _deleteButton.enabled = NO;
        _deleteButton.hidden = YES;
        _playerButton.enabled = NO;
        _gameButton.enabled = NO;
        _coachButton.enabled = NO;
        _teamLabel.text = currentSettings.team.team_name;
        newsitem.team = currentSettings.team.teamid;
    
        if ([currentSettings.sport.sport_logo isEqualToString:@"sport_logo/large/missing.png"]) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"teambutton.png"], 1)];
        } else {
            NSURL * imageURL = [NSURL URLWithString:currentSettings.sport.sport_logo];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
        }
    }
    _newsFeedImageView.image = image;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"CoachSelectSegue"]) {
        coachController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        EditPlayerViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings findAthlete:newsitem.athlete];
    } else if ([segue.identifier isEqualToString:@"CoachInfoSegue"]) {
        EditCoachViewController *destController = segue.destinationViewController;
        destController.coach = [currentSettings findCoach:newsitem.coach];
    } else if ([segue.identifier isEqualToString:@"GameInfoSegue"]) {
        EditGameViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:newsitem.game];
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    NSURL *aurl;
    NSMutableDictionary *newsDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: _newsTitleTextField.text, @"title",
                                      _newsTextView.text, @"news", currentSettings.team.teamid, @"team_id", nil];
                               
    if (newsitem.athlete.length > 0)
        [newsDict setValue:newsitem.athlete forKey:@"athlete_id"];
    
    if (newsitem.game.length > 0)
        [newsDict setValue:newsitem.game forKey:@"gameschedule_id"];
    
    if (newsitem.coach.length > 0)
        [newsDict setValue:newsitem.coach forKey: @"coach_id"];
    
    if (newNewsFeed)
        aurl = [NSURL URLWithString:[sportzServerInit newNewsFeed:currentSettings.user.authtoken]];
    else
        aurl = [NSURL URLWithString:[sportzServerInit updateNewsFeed:newsitem.newsid Token:currentSettings.user.authtoken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:newsDict, @"newsfeed", nil];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (newNewsFeed) {
        [request setHTTPMethod:@"POST"];
    } else {
        [request setHTTPMethod:@"PUT"];
    }
    
    [request setHTTPBody:jsonData];

    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([httpResponse statusCode] == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update sucessful!"
                                                        message:@"News Item updated"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating news data"
                                                        message:[serverData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete News Item"
                                                    message:@"All data will be lost"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)playerButtonClicked:(id)sender {
    if (newsitem.athlete.length > 0)
        [self performSegueWithIdentifier:@"PlayerInfoSegue" sender:self];
}

- (IBAction)gameButtonClicked:(id)sender {
    if (newsitem.game.length > 0)
        [self performSegueWithIdentifier:@"GameInfoSegue" sender:self];
}

- (IBAction)coachButtonClicked:(id)sender {
    if (newsitem.coach.length > 0)
        [self performSegueWithIdentifier:@"CoachInfoSegue" sender:self];
}

- (IBAction)newsfeedPlayerSelected:(UIStoryboardSegue *)segue {
    if (playerController.player) {
        _playerTextField.text = playerController.player.name;
        newsitem.athlete = playerController.player.athleteid;
        _playerButton.enabled = YES;
    }
    _playerSelectionContainer.hidden = YES;
}

- (IBAction)newsfeedCoachSelected:(UIStoryboardSegue *)segue {
    if (coachController.coach) {
        _coachTextField.text = coachController.coach.fullname;
        newsitem.coach = coachController.coach.coachid;
        _coachButton.enabled = YES;
    }
    _coachSelectionContainer.hidden = YES;
}

- (IBAction)newsfeedGameSelected:(UIStoryboardSegue *)segue {
    if (gameController.thegame) {
        _gameTextField.text = gameController.thegame.game_name;
        newsitem.game = gameController.thegame.id;
        _gameButton.enabled = YES;
    }
    _gameSelectionContainer.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _playerTextField) {
        [textField resignFirstResponder];
        _playerSelectionContainer.hidden = NO;
        playerController.player = nil;
        _playerButton.enabled = NO;
        newsitem.athlete = nil;
        _playerTextField.text = @"";
        [playerController viewWillAppear:YES];
    } else if (textField == _coachTextField) {
        [textField resignFirstResponder];
        _coachSelectionContainer.hidden = NO;
        coachController.coach = nil;
        _coachButton.enabled = NO;
        newsitem.coach = nil;
        _coachTextField.text = @"";
        [coachController viewWillAppear:YES];
    } else if (textField == _gameTextField) {
        [textField resignFirstResponder];
        _gameSelectionContainer.hidden = NO;
        gameController.thegame = nil;
        _gameButton.enabled = NO;
        newsitem.game = nil;
        _gameTextField.text = @"";
        [gameController viewWillAppear:YES];
    } else if (newNewsFeed) {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _playerTextField)
        _playerSelectionContainer.hidden = YES;
    else if (textField == _coachTextField)
        _coachSelectionContainer.hidden = YES;
    else if (textField == _gameTextField)
        _gameSelectionContainer.hidden = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (newNewsFeed)
        textView.text = @"";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        NSURL *aurl = [NSURL URLWithString:[sportzServerInit deleteNewsFeed:newsitem.newsid Token:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
        
        NSDictionary *jsonDict = [[NSDictionary alloc] init];
        NSError *jsonSerializationError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"DELETE"];
        [request setHTTPBody:jsonData];
        
        //Capturing server response
        NSURLResponse* response;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
        NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
        NSLog(@"%@", serverData);
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([httpResponse statusCode] == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error deleting News Item"
                                                            message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

@end
