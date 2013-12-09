//
//  EditBasketballGameViewController.m
//  Basketball Console
//
//  Created by Gilbert Zaldivar on 9/13/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "EditGameViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "FindEazesportzSiteViewController.h"
#import "TeamSelectViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditGameViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,
                                    UIAlertViewDelegate, AmazonServiceRequestDelegate>

@end

@implementation EditGameViewController {
    NSDate *pickerDate;
    
    BOOL oppImage, newmedia;
    FindEazesportzSiteViewController *findSiteController;
    TeamSelectViewController *teamSelectController;
}

@synthesize game;
@synthesize popover;

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
    _activityIndicator.hidesWhenStopped = YES;
    
    _selectDateButton.layer.cornerRadius = 6;
    _selectDateButton.backgroundColor = [UIColor greenColor];
    _homeScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _homeLabel.hidden = YES;
    _visitorLabel.hidden = YES;
    _homeScoreTextField.hidden = YES;
    _visitorScoreTextField.hidden = YES;
    _homeScoreTextField.enabled = NO;
    _visitorScoreTextField.enabled = NO;
    _selectDateButton.hidden = YES;
    _selectDateButton.enabled = NO;
    _datePicker.hidden = YES;
    _datePicker.enabled = NO;
    _findsiteContainer.hidden = YES;
    _findTeamContainer.hidden = YES;
    
    if (game) {
        _opponentTextField.text = game.opponent;
        _mascotTextField.text = game.opponent_mascot;
        
        if ([game.homeaway isEqualToString:@"Home"]) {
            [_homeawaySwitch setOn:YES];
//            _homeawayTextField.text = game.homeaway;
        } else {
            [_homeawaySwitch setOn:NO];
        }
        
        _locationTextField.text = game.location;
        _eventTextField.text = game.event;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *gamedate = [dateFormat dateFromString:game.startdate];
        [dateFormat setDateFormat:@"MM-dd-yyyy"];
        
        _gameDateTextField.text = [dateFormat stringFromDate:gamedate];
        
        _gameTimeTextField.text = game.starttime;
        _homeScoreTextField.text = _homescoreLabel.text = [[game homescore] stringValue];
        _visitorScoreTextField.text = _visitorscoreLabel.text = [[game opponentscore] stringValue];
        
        NSString *datestring = [game.startdate stringByAppendingString:@" "];
        datestring = [datestring stringByAppendingString:game.starttime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mma"];
        pickerDate = [formatter dateFromString:datestring];
        
        if (game.leaguegame) {
            [_leagueSwitch setOn:YES];
        } else {
            [_leagueSwitch setOn:NO];
        }
        
        if (game.opponentpic.length > 0) {
            [_opponentImageButton setImage:[game opponentImage] forState:UIControlStateNormal];
            
            if (game.eazesportzOpponent)
                _opponentImageButton.enabled = NO;
        }
    } else {
        _homescoreLabel.text = @"0";
        _visitorscoreLabel.text = @"0";
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
        _visitorScoreTextField.text = @"0";
        _homeScoreTextField.text = @"0";
        _opponentTextField.text = @"";
        _mascotTextField.text = @"";
        _opponentImageButton.enabled = YES;
        [_leagueSwitch setOn:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender {
    sender.text = @"";
    if ((sender == _gameDateTextField) || (sender == _gameTimeTextField)) {
        _datePicker.hidden = NO;
        _datePicker.enabled = YES;
        _selectDateButton.hidden = NO;
        _selectDateButton.enabled = YES;
        [sender resignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _homeScoreTextField) {
        if (_homeScoreTextField.text.length == 0)
            _homeScoreTextField.text = @"0";
        else
            _homescoreLabel.text = _homeScoreTextField.text;
    } else if (textField == _visitorScoreTextField) {
        if (_visitorScoreTextField.text.length == 0)
            _visitorScoreTextField.text = @"0";
        else
            _visitorscoreLabel.text = _visitorScoreTextField.text;
    }
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _homeScoreTextField) || (textField == _visitorScoreTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        if (myStringMatchesRegEx)
            return YES;
        else
            return NO;
    } else
        return YES;
}

- (IBAction)selectDateButtonClicked:(id)sender {
    //    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    pickerDate = [_datePicker date];
    //    NSString *selectionString = [[NSString alloc] initWithFormat:@"%@", [pickerDate descriptionWithLocale:usLocale]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy hh:mm:ss a"];
    NSArray *datetime = [[formatter stringFromDate:pickerDate] componentsSeparatedByString:@" "];
    _gameDateTextField.text = [datetime objectAtIndex:0];
    _gameTimeTextField.text = [datetime objectAtIndex:1];
    _gameTimeTextField.text = [_gameTimeTextField.text stringByAppendingString:[datetime objectAtIndex:2]];
    _datePicker.hidden = YES;
    _datePicker.enabled = NO;
    _selectDateButton.hidden = YES;
    _selectDateButton.enabled = NO;
    [_gameTimeTextField resignFirstResponder];
    [_gameDateTextField resignFirstResponder];
}

- (IBAction)scorelogButtonClicked:(id)sender {
}

- (IBAction)submitButtonClicked:(id)sender {
    if ((_opponentTextField.text.length > 0) && (_locationTextField.text.length > 0) &&
        (_gameDateTextField.text.length > 0) && (_gameTimeTextField.text.length > 0)) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSArray *datetime = [[formatter stringFromDate:pickerDate] componentsSeparatedByString:@" "];
//        NSArray *time = [[datetime objectAtIndex:1] componentsSeparatedByString:@":"];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setDateFormat:@"HH:mm"];
        NSString *timedata = [formatter stringFromDate:pickerDate];

        if (!game)
            game = [[GameSchedule alloc] init];
        
        game.startdate = datetime[0];
        game.starttime = timedata;
        game.opponent = _opponentTextField.text;
        game.opponent_mascot = _mascotTextField.text;
        game.location = _locationTextField.text;
        game.event = _eventTextField.text;
        
        if ([_homeawaySwitch isOn])
            game.homeaway = @"Home";
        else
            game.homeaway = @"Away";
        
//        game.homeaway = _homeawayTextField.text;
        game.homescore = [NSNumber numberWithInt:[_homeScoreTextField.text intValue]];
        game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
        game.leaguegame = [_leagueSwitch isOn];
        
        if (teamSelectController.team ) {
             game.opponentpic = teamSelectController.team.team_logo;
        }
        
        if ([game saveGameschedule]) {
            if (oppImage) {
                [self uploadImage:game];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Creating Game Data"
                                                            message:[game httperror]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                              message:@"Game entry must include Opponent, Location, Start Date and Start Time"
                              delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (BOOL)uploadImage:(GameSchedule *)agame {
    oppImage = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    NSString *photopath = [NSString stringWithFormat:@"%@%@%@%@", @"uploads/gameschedulelogo/",
                           agame.id, @"/", agame.opponent_mascot];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:photopath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";
    
    UIImage *image = _opponentImageButton.imageView.image;
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
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/",
                                       game.id, @"/updatelogo.json?auth_token=", currentSettings.user.authtoken]];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@", @"uploads/gameschedulelogo/", game.id, @"/", game.opponent_mascot];
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", game.opponent_mascot, @"filename", nil];
    
    //    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:athDict, @"athlete", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:athDict options:0 error:&error];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPMethod:@"PUT"];
    [urlrequest setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&error];
    int responseStatusCode = [(NSHTTPURLResponse*)urlresponse statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *gamedata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[gamedata objectForKey:@"error"]
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

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You are about delete the game. All data will be lost!"
                                                   delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)scoreButtonClicked:(id)sender {
    _visitorLabel.hidden = NO;
    _visitorScoreTextField.hidden = NO;
    _visitorScoreTextField.enabled = YES;
    _homeLabel.hidden = NO;
    _homeScoreTextField.hidden = NO;
    _homeScoreTextField.enabled = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if (![game initDeleteGame]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)searchEazesportzButtonClicked:(id)sender {
    _findsiteContainer.hidden = NO;
    [findSiteController viewWillAppear:YES];
}

- (IBAction)findsiteSelected:(UIStoryboardSegue *)segue {
    _findsiteContainer.hidden = YES;
    
    if (findSiteController.sport) {
        _findTeamContainer.hidden = NO;
        teamSelectController.sport = findSiteController.sport;
        [teamSelectController viewWillAppear:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FindSiteSelectSegue"]) {
        findSiteController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TeamSelectSegue"]) {
        teamSelectController = segue.destinationViewController;
    }
}

- (IBAction)findteamSelected:(UIStoryboardSegue *)segue {
    _findTeamContainer.hidden = YES;
    
    if (teamSelectController.team) {
        _opponentTextField.text = teamSelectController.team.title;
        _mascotTextField.text = teamSelectController.team.mascot;
        
        if (([teamSelectController.team.team_logo isEqualToString:@"/team_logos/thumb/missing.png"]) ||
            (teamSelectController.team.team_logo.length == 0)) {
            [_opponentImageButton setImage:[findSiteController.sport getImage:@"thumb"] forState:UIControlStateNormal];
        } else if ((teamSelectController.team.teamimage.CIImage == nil) && (teamSelectController.team.teamimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:teamSelectController.team.team_logo];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            [_opponentImageButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)opponentImageButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        UIPopoverController *apopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        apopover.delegate = self;
        
        // set contentsize
        [apopover setPopoverContentSize:CGSizeMake(220,300)];
        
        [apopover presentPopoverFromRect:CGRectMake(700,1000,10,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.popover = apopover;
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        NSData *imgData=UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
        UIImage *image = [[UIImage alloc] initWithData:imgData];
        
        if (newmedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        
        _opponentImageButton.imageView.image = [currentSettings normalizedImage:image scaledToSize:125];
        oppImage = YES;
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

@end

