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
#import "EazesportzRetrieveVideos.h"
#import "EazeWebViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface NewsFeedEditViewController () <UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate, AmazonServiceRequestDelegate>

@end

@implementation NewsFeedEditViewController {
    PlayerSelectionViewController *playerController;
    CoachSelectionViewController *coachController;
    GameScheduleViewController *gameController;
    
    BOOL newNewsFeed, imageselected, newmedia;
    long responseStatusCode;
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
    _activityIndicator.hidesWhenStopped = YES;
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
        self.view.backgroundColor = [UIColor clearColor];
    else
        self.view.backgroundColor = [UIColor whiteColor];
    
    _playerTextField.inputView = playerController.inputView;
    _coachTextField.inputView = coachController.inputView;
    _gameTextField.inputView = gameController.inputView;
    _newsTextView.layer.borderWidth = 1.0f;
    _newsTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.saveBarButton, self.deleteBarButton, nil];
    self.navigationController.toolbarHidden = YES;
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
        _externalUrlTextField.text = newsitem.external_url;
        
        if (newsitem.external_url.length > 0) {
            _testUrlButton.hidden = NO;
            _testUrlButton.enabled = YES;
        } else {
            _testUrlButton.hidden = YES;
            _testUrlButton.enabled = NO;
        }
        
        // Add image
                
        if (newsitem.videoclip_id.length > 0) {
            [_newsFeedImageView setImage:[currentSettings normalizedImage:newsitem.videoPoster scaledToSize:125]];
        } else if (newsitem.tinyurl.length > 0) {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:newsitem.thumburl]];
                
                //this will set the image when loading is finished
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_newsFeedImageView setImage:[UIImage imageWithData:image]];
                });
            });
        } else if (newsitem.athlete.length > 0) {
            [_newsFeedImageView setImage:[currentSettings normalizedImage:[currentSettings getRosterThumbImage:[currentSettings findAthlete:newsitem.athlete]] scaledToSize:125]];
        } else if (newsitem.game.length > 0) {
           [_newsFeedImageView setImage:[currentSettings normalizedImage:[currentSettings getOpponentImage:
                                                                          [currentSettings findGame:newsitem.game]] scaledToSize:125]];
        } else if (newsitem.coach.length > 0) {
            [_newsFeedImageView setImage:[[currentSettings findCoach:newsitem.coach] thumbimage]];
        } else {
            [_newsFeedImageView setImage:[currentSettings.team getImage:@"thumb"]];
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
        _newsFeedImageView.image = [currentSettings.team getImage:@"thumb"];
        _deleteBarButton.enabled = NO;
        _testUrlButton.hidden = YES;
        _testUrlButton.enabled = NO;
    }
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
    } else if ([segue.identifier isEqualToString:@"NewsExternalUrlSegue"]) {
        EazeWebViewController *destController = segue.destinationViewController;
        destController.external_url = [NSURL URLWithString:newsitem.external_url];
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    newsitem.title = _newsTitleTextField.text;
    newsitem.news = _newsTextView.text;
    
    if ([newsitem saveNewsFeed]) {
        [self newsitemSaved];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating news data" message:[newsitem httperror]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete News Item"
                                                    message:@"All data will be lost"
                                                   delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
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
    [self playerSelected:segue];
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    if (playerController.player) {
        _playerTextField.text = playerController.player.name;
        newsitem.athlete = playerController.player.athleteid;
        _playerButton.enabled = YES;
    }
    _playerSelectionContainer.hidden = YES;
}

- (IBAction)coachSelected:(UIStoryboardSegue *)segue {
    if (coachController.coach) {
        _coachTextField.text = coachController.coach.fullname;
        newsitem.coach = coachController.coach.coachid;
        _coachButton.enabled = YES;
    }
    _coachSelectionContainer.hidden = YES;
}

- (IBAction)newsfeedGameSelected:(UIStoryboardSegue *)segue {
    [self gameSelected:segue];
}

- (IBAction)gameSelected:(UIStoryboardSegue *)segue {
    if (gameController.thegame) {
        _gameTextField.text = [gameController.thegame vsOpponent];
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
        if (![newsitem initDeleteNewsFeed]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error deleting News Item" message:[newsitem httperror]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (IBAction)saveBarButtonClicked:(id)sender {
    [self submitButtonClicked:sender];
}

- (IBAction)deleteBarButtonClicked:(id)sender {
    [self deleteButtonClicked:sender];
}

- (IBAction)cameraRollButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"]) {
            imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
            UIPopoverController *apopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            apopover.delegate = self;
            
            // set contentsize
            [apopover setPopoverContentSize:CGSizeMake(220,300)];
            
            [apopover presentPopoverFromRect:CGRectMake(700,1000,10,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popover = apopover;
        } else {
            [self presentViewController:imagePicker animated:YES completion:nil];
            newmedia = NO;
        }
    }
}

- (IBAction)cameraButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newmedia = YES;
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        NSData *imgData=UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
        NSLog(@"%d", [imgData length]);
        UIImage *image = [[UIImage alloc] initWithData:imgData];
        
        if (newmedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        
        _newsFeedImageView.image = [currentSettings normalizedImage:image scaledToSize:512];
        
        imageselected = YES;
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(void)image:(UIImage *)imag finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)uploadImage:(Coach *)acoach {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    // Upload image data.  Remember to set the content type.
    NSString *imagepath = [NSString stringWithFormat:@"%@%@%@%@%@", @"uploads/coachesphotos/", acoach.coachid, @"/",
                           acoach.lastname, acoach.firstname];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imagepath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";
    
    UIImage *image = _newsFeedImageView.image;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    por.data = imageData;
    int imagesize = imageData.length;
    por.delegate = self;
    
    // Put the image data into the specified s3 bucket and object.
    [[currentSettings getS3] putObject:por];
    return YES;
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [_activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sports/%@/newsfeeds/%@/updatephoto.json?auth_token=%@",
                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id,
                                       newsitem.newsid, currentSettings.user.authtoken]];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@", @"uploads/newsfeedsphotos/", newsitem.newsid, @"/",
                      [NSString stringWithFormat:@"%@_%@", newsitem.newsid, currentSettings.sport.id]];
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", [NSString stringWithFormat:@"%@_%@", newsitem.newsid, currentSettings.sport.id], @"filename", nil];
    
    //    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:athDict, @"athlete", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:athDict options:0 error:&error];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPMethod:@"PUT"];
    [urlrequest setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&error];
    responseStatusCode = [(NSHTTPURLResponse*)urlresponse statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *athdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        [self newsitemSaved];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[athdata objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo Upload Error" delegate:self
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
    [_activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)newsitemSaved {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"News Item Saved!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    _deleteBarButton.enabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)testUrlButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"NewsExternalUrlSegue" sender:self];
}

@end
