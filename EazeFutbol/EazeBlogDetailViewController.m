//
//  sportzteamsBlogDetailViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/25/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "EazeBlogDetailViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "PlayerInfoViewController.h"
#import "CoachesInfoViewController.h"
#import "EazeBasketballGameSummaryViewController.h"
#import "EazeFootballGameSummaryViewController.h"

@interface EazeBlogDetailViewController () <UIAlertViewDelegate>

@end

@implementation EazeBlogDetailViewController {
    NSDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;
}

@synthesize blog;

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
    _blogtitle.layer.cornerRadius = 4;
    _blogEntry.layer.cornerRadius = 4;
    _playerButton.layer.cornerRadius = 4;
    _gameButton.layer.cornerRadius = 4;
    _coachButton.layer.cornerRadius = 4;
    _bloggerName.layer.cornerRadius = 4;
    _commentTextView.layer.cornerRadius = 4;
    _blogEntry.layer.borderWidth = 1.0f;
    _commentTextView.layer.borderWidth = 1.0f;
    _blogEntry.layer.borderColor = [[UIColor blackColor] CGColor];
    _commentTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_scrollView addGestureRecognizer:singleTap];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:_scrollView];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_blogtitle setText:blog.blogtitle];
    [_blogEntry setText:blog.entry];
    _bloggerName.text = blog.username;
    _playerButton.enabled = NO;
    _coachButton.enabled = NO;
    _gameButton.enabled = NO;
    _commentTextView.text = @"";
    
    if ((blog.tinyavatar.length == 0) || (blog.avatar == nil)) {
        [_bloggerImage setImage:[UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"man.png"], 1)]];
    } else {
        NSURL * imageURL = [NSURL URLWithString:blog.avatar];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        [_bloggerImage setImage:[UIImage imageWithData:imageData]];
    }
    
    if ([blog.athlete length] > 0) {
        _playerButton.enabled = YES;
        [_playerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_playerButton setTitle:[[currentSettings findAthlete:blog.athlete] logname] forState:UIControlStateNormal];
    } else {
        _playerButton.enabled = NO;
        [_playerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_playerButton setTitle:@"None" forState:UIControlStateNormal];
        _playerButton.hidden = YES;
    }
    
    if ([blog.coach length] > 0) {
        _coachButton.enabled = YES;
        [_coachButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_coachButton setTitle:[[currentSettings findCoach:blog.coach] fullname] forState:UIControlStateNormal];
    } else {
        [_coachButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_coachButton setTitle:@"None" forState:UIControlStateNormal];
        _coachButton.enabled = NO;
        _coachButton.hidden = YES;
    }
    
    if ([blog.gameschedule length] > 0) {
        _gameButton.enabled = YES;
        [_gameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_gameButton setTitle:[[currentSettings findGame:blog.gameschedule] opponent] forState:UIControlStateNormal];
    } else {
        [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_gameButton setTitle:[[currentSettings findGame:blog.gameschedule] opponent] forState:UIControlStateNormal];
        _gameButton.enabled = NO;
        _gameButton.hidden = YES;
    }
    
    if (currentSettings.user.userid.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You must login to create a blog entry."
                                                       delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Login", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    
    if (currentSettings.sport.hideAds)
        _bannerView.hidden = YES;
}

- (void)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == _commentTextView)
        [textView setText:@""];
}

-(void)hideKeyboard{
    [_blogEntry resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)commentButton:(id)sender {
    if ([[_commentTextView text] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:[NSString stringWithFormat:@"Blank comments not allowed!"]
                                                  delegate:self cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        blog.entry = [_commentTextView text];
        NSURL *url = [NSURL URLWithString:[sportzServerInit newBlog:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *blogData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:blog.blogtitle, @"title", blog.entry, @"entry",
                                        blog.user, @"user_id", blog.teamid, @"team_id", nil];
        
        if (blog.gameschedule.length > 0)
            [blogData setValue:blog.gameschedule forKey:@"gameschedule_id"];
        
        if (blog.athlete.length > 0)
            [blogData setValue:blog.athlete forKey:@"athlete_id"];
        
        if (blog.coach.length > 0)
            [blogData setValue:blog.coach forKey:@"coach_id"];
        
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
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Error - please make sure you're connected to either 3G or WI-FI"
                                                       delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                  message:[NSString stringWithFormat:@"Blog Comment Added!"]
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings findAthlete:blog.athlete];
    } else if ([segue.identifier isEqualToString:@"CoachInfoSegue"]) {
        CoachesInfoViewController *destController = segue.destinationViewController;
        destController.coach = [currentSettings findCoach:blog.coach];
    } else if ([segue.identifier isEqualToString:@"SoccerGameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:blog.gameschedule];
    } else if ([segue.identifier isEqualToString:@"BasketballGameInfoSegue"]) {
        EazeBasketballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:blog.gameschedule];
    } else if ([segue.identifier isEqualToString:@"FootballGameInfoSegue"]) {
        EazeFootballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:blog.gameschedule];
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

- (IBAction)gameButtonClicked:(id)sender {
    if ([currentSettings.sport.name isEqualToString:@"Football"])
        [self performSegueWithIdentifier:@"FootballGameInfoSegue" sender:self];
    else if ([currentSettings.sport.name isEqualToString:@"Basketball"])
        [self performSegueWithIdentifier:@"BasketballGameInfoSegue" sender:self];
    else if ([currentSettings.sport.name isEqualToString:@"Soccer"])
        [self performSegueWithIdentifier:@"SoccerGameInfoSegue" sender:self];
}
@end
