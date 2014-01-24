//
//  sportzteamsNewBlogViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 5/1/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "NewBlogViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "EazeBlogDetailViewController.h"
#import "EazePlayerSelectViewController.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "EazeGameScheduleViewController.h"
#import "PlayerInfoViewController.h"
#import "EazeCoachSelectionViewController.h"
#import "CoachesInfoViewController.h"
#import "EazeBasketballGameSummaryViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface NewBlogViewController () <UIAlertViewDelegate>

@end

@implementation NewBlogViewController {
    UIActionSheet *actionSheet;
    GameSchedule *game;
    Athlete *player;
    Coach *coach;
    Blog *newblog;
    BOOL selectplay;

    NSDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;
    
    PlayerSelectionViewController *playerController;
    GameScheduleViewController *gameController;
    CoachSelectionViewController *coachController;
}

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
    _entryTextView.layer.cornerRadius = 4;
    _titleTextEtnry.layer.cornerRadius = 4;
    _playerTextField.inputView = playerController.inputView;
    _gameTextField.inputView = gameController.inputView;
    _coachTextField.inputView = coachController.inputView;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_scrollView addGestureRecognizer:singleTap];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:_scrollView];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _entryTextView.text = @"";
    
    if (currentSettings.user.userid.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You must login to create a blog entry."
                                                       delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Login", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
    
        if (playerController) {
            if (playerController.player) {
                player = playerController.player;
                _playerButton.enabled = YES;
                _playerTextField.text = player.logname;
                [_playerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            } else {
                _playerButton.enabled = NO;
                _playerTextField.text = @"";
                [_playerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        } else {
            _playerButton.enabled = NO;
            _playerTextField.text = @"";
            [_playerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        if (gameController) {
            if (gameController.thegame) {
                game = gameController.thegame;
                _gameTextField.text = [NSString stringWithFormat:@"%@%@", @"vs ", game.opponent];
                _gameButton.enabled = YES;
                [_gameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            } else {
                _gameTextField.text = @"";
                _gameButton.enabled = NO;
                [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        } else {
            _gameTextField.text = @"";
            _gameButton.enabled = NO;
            [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        if (coachController) {
            if (coachController.coach) {
                coach = coachController.coach;
                _coachTextField.text = coach.fullname;
                _coachButton.enabled = YES;
                [_coachButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            } else {
                _coachTextField.text = @"";
                _coachButton.enabled = NO;
                [_coachButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        } else {
            _coachTextField.text = @"";
            _coachButton.enabled = NO;
            [_coachButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        newblog = [[Blog alloc] init];
        newblog.teamid = currentSettings.team.teamid;
        newblog.user = currentSettings.user.userid;
        newblog.avatar = currentSettings.user.userUrl;
        
        selectplay = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:1];
        [siteStateText becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _playerTextField) {
        playerController.player = nil;
        _playerTextField.text = @"";
        [self performSegueWithIdentifier:@"PlayerSelectSegue" sender:self];
    } else if (textField == _gameTextField) {
        gameController.thegame = nil;
        _gameTextField.text = @"";
        [self performSegueWithIdentifier:@"GameSelectSegue" sender:self];
    } else if (textField == _coachTextField) {
        coachController.coach = nil;
        _coachTextField.text = @"";
        [self performSegueWithIdentifier:@"CoachSelectSegue" sender:self];
    }
    [textField resignFirstResponder];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
}

- (IBAction)postBlogButtonClicked:(id)sender {
    if (([[_titleTextEtnry text] length] == 0) || ([[_entryTextView text] length] == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:[NSString stringWithFormat:@"Blog must have title and some and a blog!"]
                                                  delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        newblog.blogtitle = [_titleTextEtnry text];
        newblog.entry = [_entryTextView text];
        NSURL *url = [NSURL URLWithString:[sportzServerInit newBlog:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *blogData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_titleTextEtnry text],
                                         @"title",[_entryTextView text], @"entry", newblog.user, @"user_id", newblog.teamid,
                                         @"team_id", nil];
        
        if (game) {
            newblog.gameschedule = game.id;
            [blogData setValue:newblog.gameschedule forKey:@"gameschedule_id"];
        }
        
        if (player) {
            newblog.athlete = player.athleteid;
            [blogData setValue:newblog.athlete forKey:@"athlete_id"];
        }
        
        if (coach) {
            newblog.coach = coach.coachid;
            [blogData setValue:newblog.coach forKey:@"coach_id"];
        }
        
        NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
        [jsonDict setValue:blogData forKey:@"blog"];
        
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
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [[NSURLConnection alloc] initWithRequest:request  delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download cound not complete - please make sure you're connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        NSDictionary *resultblog = [[NSDictionary alloc]init];
        resultblog = [serverData objectForKey:@"blog"];
        newblog.blogid = [resultblog objectForKey:@"_id"];
        newblog.user = [resultblog objectForKey:@"user_id"];
        newblog.username = currentSettings.user.username;
        
        if ((NSNull *)[resultblog objectForKey:@"athlete_id"] != [NSNull null]) 
            newblog.athlete = [resultblog objectForKey:@"athlete_id"];
        else
            newblog.athlete = @"";
        
        if ((NSNull *)[resultblog objectForKey:@"coach_id"] != [NSNull null])
            newblog.coach = [resultblog objectForKey:@"coach_id"];
        else
            newblog.coach = @"";
        
        newblog.teamid = [resultblog objectForKey:@"team_id"];

        if ((NSNull *)[resultblog objectForKey:@"gameschedule_id"] != [NSNull null])
            newblog.gameschedule = [resultblog objectForKey:@"gameschedule_id"];
        else
            newblog.gameschedule = @"";
        
        if ((NSNull *)[resultblog objectForKey:@"gamelog_id"] != [NSNull null])
            newblog.gamelog = [resultblog objectForKey:@"gamelog_id"];
        else
            newblog.gamelog = @"";
        
        newblog.updatedat = [resultblog objectForKey:@"updated_at"];
        newblog.external_url = [resultblog objectForKey:@"external_url"];
        newblog.entry = [resultblog objectForKey:@"entry"];
        
        if ((NSNull *)[resultblog objectForKey:@"avatar"] != [NSNull null])
            newblog.avatar = [resultblog objectForKey:@"avatar"];
        else
            newblog.avatar = @"";
        
        if ((NSNull *)[resultblog objectForKey:@"tinyavatar"] != [NSNull null])
            newblog.tinyavatar = [resultblog objectForKey:@"tinyavatar"];
        else
            newblog.tinyavatar = @"";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                  message:[NSString stringWithFormat:@"New Blog Created!"]
                                                  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                  delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Ok"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([title isEqualToString:@"Login"]) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    } else if ([title isEqualToString:@"Back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"CoachSelectSegue"]) {
        coachController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"GameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
 //   } else if ([segue.identifier isEqualToString:@"GameDetailSegue"]) {
//        gomobisportsGameDetailViewController *destController = segue.destinationViewController;
//        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"CoachInfoSegue"]) {
        CoachesInfoViewController *destController = segue.destinationViewController;
        destController.coach = coach;
    } else if ([segue.identifier isEqualToString:@"BasketballGameInfoSegue"]) {
        EazeBasketballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

@end
