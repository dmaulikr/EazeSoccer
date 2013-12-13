//
//  BlogEntryViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/10/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "BlogEntryViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "EditPlayerViewController.h"
#import "EditCoachViewController.h"
//#import "GameSummaryViewController.h"
#import "EditUserViewController.h"
#import "PlayerSelectionViewController.h"
#import "CoachSelectionViewController.h"
#import "EditGameViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface BlogEntryViewController () <UIAlertViewDelegate>

@end

@implementation BlogEntryViewController {
    PlayerSelectionViewController *playerSelectionController;
    CoachSelectionViewController *coachSelectionController;
}

@synthesize blog;
@synthesize gameSelectionController;

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
    
    _blogentryTextView.layer.cornerRadius = 4;
    _userButton.layer.cornerRadius = 4;
    _commentTextView.layer.cornerRadius = 4;
    _deleteButton.layer.cornerRadius = 4;
//    _deleteButton.backgroundColor = [UIColor redColor];
    _commentTextView.text = @"";
    _tagCoachButton.layer.cornerRadius = 6;
    _tagGameButton.layer.cornerRadius = 6;
    _tagPlayerButton.layer.cornerRadius = 6;
    
    _gameTextField.inputView = gameSelectionController.inputView;
    _playerTextField.inputView = playerSelectionController.inputView;
    _coachTextField.inputView = coachSelectionController.inputView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerContainer.hidden = YES;
    _gameContainer.hidden = YES;
    _coachContainer.hidden = YES;
    
    if (blog) {
        _blogentryTextView.text = blog.entry;
        _blogentryTextView.editable = NO;
        _blogTitleText.text = blog.blogtitle;
        [_userButton setTitle:[NSString stringWithFormat:@"%@%@", @"Blogger: ", blog.username] forState:UIControlStateNormal];
        
        if (blog.athlete.length > 0) {
            _tagPlayerButton.enabled = YES;
            _playerTextField.text = [[currentSettings findAthlete:blog.athlete] logname];
        } else {
            _tagPlayerButton.enabled = NO;
        }
        
        if (blog.coach.length > 0) {
            _tagCoachButton.enabled = YES;
            _coachTextField.text = [[currentSettings findCoach:blog.coach] fullname];
        } else {
            _tagCoachButton.enabled = NO;
        }
        
        if (blog.gameschedule.length > 0) {
            _tagGameButton.enabled = YES;
            _gameTextField.text = [[currentSettings findGame:blog.gameschedule] game_name];
        } else {
            _tagGameButton.enabled = NO;
        }
        
        if (blog.tinyavatar.length == 0) {
            _bloggerImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else
            _bloggerImage.image = blog.tinyimage;

    } else {
        _commentTextView.hidden = YES;
        _commentLabel.hidden = YES;
        _commentTextView.editable = NO;
        _blogentryTextView.text = @"";
        _blogTitleText.text = @"";
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
        _tagCoachButton.enabled = NO;
        _tagPlayerButton.enabled = NO;
        _tagGameButton.enabled = NO;
        blog = [[Blog alloc] init];
        blog.username = currentSettings.user.username;
        [_userButton setTitle:[NSString stringWithFormat:@"%@%@", @"Blogger: ", blog.username] forState:UIControlStateNormal];
        _userButton.enabled = NO;
        
        if (currentSettings.user.tiny.length == 0) {
            _bloggerImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else {
            NSURL * imageURL = [NSURL URLWithString:currentSettings.user.tiny];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            _bloggerImage.image = [UIImage imageWithData:imageData];
            blog.tinyavatar = currentSettings.user.tiny;
            blog.avatar = currentSettings.user.userthumb;
            blog.tinyimage = _bloggerImage.image;
            imageURL = [NSURL URLWithString:currentSettings.user.userthumb];
            imageData = [NSData dataWithContentsOfURL:imageURL];
            blog.thumbimage = [UIImage imageWithData:imageData];
        }
    }
}

- (IBAction)commentButtonClicked:(id)sender {
    if (_commentTextView.text.length > 0) {
        NSMutableDictionary *blogDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: _commentTextView.text, @"entry",
                                   [NSString stringWithFormat:@"%@%@", @"RE: ",blog.blogtitle], @"title",
                                   currentSettings.user.userid, @"user_id", currentSettings.team.teamid, @"team_id", nil];
        [self saveBlog:blogDict];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Cannot post a blank comment"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    NSMutableDictionary *blogDict;
    
    if (_blogentryTextView.editable) {
    
        if ((_blogentryTextView.text.length > 0) && (_blogTitleText.text.length > 0)) {
            blogDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: _blogentryTextView.text, @"entry",
                                   blog.blogtitle, @"title", currentSettings.user.userid, @"user_id", currentSettings.team.teamid, @"team_id", nil];
            [self saveBlog:blogDict];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Cannot post a blog without a title or entry!"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    
    } else if (_commentTextView.text.length > 0) {
        blogDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: _commentTextView.text, @"entry",
                                          [NSString stringWithFormat:@"%@%@", @"RE: ",blog.blogtitle], @"title",
                                          currentSettings.user.userid, @"user_id", currentSettings.team.teamid, @"team_id", nil];
     [self saveBlog:blogDict];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Cannot post a blog without a comment!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        EditPlayerViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings findAthlete:blog.athlete];
    } else if ([segue.identifier isEqualToString:@"GameInfoSegue"]) {
        EditGameViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:blog.gameschedule];
    } else if ([segue.identifier isEqualToString:@"CoachInfoSegue"]) {
        EditCoachViewController *destController = segue.destinationViewController;
        destController.coach = [currentSettings findCoach:blog.coach];
    } else if ([segue.identifier isEqualToString:@"UserInfoSegue"]) {
        EditUserViewController *destController = segue.destinationViewController;
        destController.userid = blog.user;
    } else if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectionController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameSelectionController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"CoachSelectSegue"]) {
        coachSelectionController = segue.destinationViewController;
    }
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Delete Blog Entry?"
                                                   delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _blogTitleText)
        _blogTitleText.text = @"";
    else if (textField == _gameTextField) {
        _gameContainer.hidden = NO;
        _gameTextField.text = @"";
        _tagGameButton.enabled = NO;
        gameSelectionController.thegame = nil;
        [gameSelectionController viewWillAppear:YES];
        [_gameTextField resignFirstResponder];
    } else if (textField == _playerTextField) {
        _playerContainer.hidden = NO;
        _playerTextField.text = @"";
        _tagPlayerButton.enabled = NO;
        playerSelectionController.player = nil;
        [playerSelectionController viewWillAppear:YES];
        [_playerTextField resignFirstResponder];
    } else if (textField == _coachTextField) {
        _coachContainer.hidden = NO;
        _coachTextField.text = @"";
        _tagCoachButton.enabled = NO;
        coachSelectionController.coach = nil;
        [coachSelectionController viewWillAppear:YES];
        [_coachTextField resignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    blog.blogtitle = _blogTitleText.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == _blogentryTextView)
        blog.entry = _blogentryTextView.text;
    else if (textView == _commentTextView)
        blog.entry = _commentTextView.text;
}

- (void)saveBlog:(NSMutableDictionary *)blogdata {
    NSURL *aurl = [NSURL URLWithString:[sportzServerInit newBlog:currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    
    if (blog.athlete.length > 0)
        [blogdata setValue:blog.athlete forKey:@"athlete_id"];
    
    if (blog.gameschedule.length > 0)
        [blogdata setValue:blog.gameschedule forKey:@"gameschedule_id"];
    
    if (blog.coach.length > 0)
        [blogdata setValue:blog.coach forKey:@"coach_id"];
    
    if (blog.gamelog.length > 0)
        [blogdata setValue:blog.gamelog forKey:@"gamelog_id"];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:blogdata, @"blog", nil];
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
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([httpResponse statusCode] == 200) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating blog data"
                                                        message:[serverData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    
}

- (IBAction)gameSelected:(UIStoryboardSegue *)segue {
    GameSchedule *game = gameSelectionController.thegame;
    
    if (game) {
        blog.gameschedule = game.id;
        _gameTextField.text = [[currentSettings findGame:blog.gameschedule] game_name];
        _tagGameButton.enabled = YES;
        [_tagGameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        _gameTextField.text = @"";
        blog.gameschedule = @"";
        _tagGameButton.enabled = NO;
    }
    _gameContainer.hidden = YES;
}

- (IBAction)coachSelected:(UIStoryboardSegue *)segue {
    Coach *coach = coachSelectionController.coach;
    
    if (coach) {
        blog.coach = coach.coachid;
        _coachTextField.text = [[currentSettings findCoach:blog.coach] fullname];
        _tagCoachButton.enabled = YES;
        [_tagCoachButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        blog.coach = @"";
        _tagCoachButton.enabled = NO;
        _coachTextField.text = @"";
    }
    _coachContainer.hidden = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if (![blog initDeleteBlog]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error deleting blog" message:[blog httperror]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    Athlete *player = playerSelectionController.player;
    
    if (player != nil) {
        blog.athlete = player.athleteid;
        _playerTextField.text = [[currentSettings findAthlete:blog.athlete] logname];
        _tagPlayerButton.enabled = YES;
        [_tagPlayerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        _playerTextField.text = @"";
        blog.athlete = @"";
        _tagPlayerButton.enabled = NO;
    }
    _playerContainer.hidden = YES;
}


@end
