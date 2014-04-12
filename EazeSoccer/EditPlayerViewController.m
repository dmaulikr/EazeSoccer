//
//  EditPlayerViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EditPlayerViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "sportzCurrentSettings.h"
#import "PhotosViewController.h"
#import "VideosViewController.h"
#import "EazeSoccerStatsViewController.h"
#import "EazeBasketballStatsViewController.h"
#import "EazesportzRetrievePlayers.h"

#import "EazesportzFootballPlayerStatsViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditPlayerViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate, AmazonServiceRequestDelegate>

@end

@implementation EditPlayerViewController {
    NSArray *positionkeys;
    NSMutableArray *positionvalues;
    NSMutableArray *height, *inches;
    
    BOOL newmedia, imageselected;
    NSString *imagepath;
    
    NSString *heighttext;
    
    int responseStatusCode;
    NSMutableDictionary *serverData;
    NSMutableData *theData;
    
    BOOL stats;
}

@synthesize player;
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
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
        self.view.backgroundColor = [UIColor clearColor];
    else
        self.view.backgroundColor = [UIColor whiteColor];
    
    _activityIndicator.hidesWhenStopped = YES;

    _bioTextView.layer.cornerRadius = 4;
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _weightTextField.keyboardType = UIKeyboardTypeNumberPad;
    _seasonTextField.keyboardType = UIKeyboardTypeNumberPad;
    imageselected = NO;
    _heightTextField.inputView = _heightPicker.inputView;
    
    height = [[NSMutableArray alloc] initWithObjects:@"3", @"4", @"5", @"6", @"7", @"8", nil];
    inches = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.statsButton, self.doneButton, nil];
    
    self.navigationController.toolbarHidden = YES;
    
//    [_heightPicker setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidDisappear:(BOOL)animated {
    // do not forget to unsubscribe the observer, or you may experience crashes towards a deallocated observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePlayer:) name:@"AthleteDeletedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savedPlayer:) name:@"AthleteSavedNotification" object:nil];

    heighttext = @"";
    _positionPicker.hidden = YES;
    _heightPicker.hidden = YES;
    [_addPositionControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    _soccerStatsContainer.hidden = YES;
    _doneButton.enabled = NO;
    
    if (player) {
        [_numberTextField setText:[[player number] stringValue]];
        [_lastnameTextField setText:[player lastname]];
        [_firstnameTextField setText:[player firstname]];
        [_middlenameTextField setText:[player middlename]];
        
        if (player.height.length == 0)
            _heightTextField.text = @"0-0";
        else
            _heightTextField.text = player.height;
        
        if ([player.weight intValue] == 0)
            _weightTextField.text = @"0";
        else
            [_weightTextField setText:[[player weight] stringValue]];
        
        _gradeageclassTextField.text = player.year;
        _seasonTextField.text = player.season;
        _bioTextView.text = player.bio;
        
        _playerImage.image = [currentSettings getRosterThumbImage:player];

        _positionTextField.text = player.position;
        
        if (player.hasphotos) {
            [_photosButton setTitle:@"Photos" forState:UIControlStateNormal];
        } else {
            [_photosButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _photosButton.enabled = NO;
        }
        
        if (player.hasvideos) {
            [_videosButton setTitle:@"Videos" forState:UIControlStateNormal];
        } else {
            [_videosButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _videosButton.enabled = NO;
        }
    } else {
        _numberTextField.text = @"";
        _lastnameTextField.text = @"";
        _firstnameTextField.text = @"";
        _middlenameTextField.text = @"";
        _heightTextField.text = @"0-0";
        _weightTextField.text = @"0";
        _gradeageclassTextField.text = @"";
        _bioTextView.text = @"";
        _seasonTextField.text = @"";
        _warningDeleteButton.hidden = YES;
        _warningDeleteButton.enabled = NO;
        _statsButton.enabled = NO;
        _playerImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        [_videosButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_photosButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)displayDataEntryAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:message
                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    if (_numberTextField.text.length == 0)
        [self displayDataEntryAlert:@"Athlete must have a jersey number!"];
    else if (_lastnameTextField.text.length == 0)
        [self displayDataEntryAlert:@"Athlete must have a last name!"];
    else if (_firstnameTextField.text.length == 0)
        [self displayDataEntryAlert:@"Athlete must have a first name!"];
    else if (_seasonTextField.text.length == 0)
        [self displayDataEntryAlert:@"Season cannot be blank"];
    else if (_gradeageclassTextField.text.length == 0)
        [self displayDataEntryAlert:@"Grade/Class cannot be blank"];
    else {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        
        if (!player)
            player = [[Athlete alloc] init];
        
        player.number = [f numberFromString:_numberTextField.text];
        player.lastname = _lastnameTextField.text;
        player.middlename = _middlenameTextField.text;
        player.firstname = _firstnameTextField.text;
        player.height = _heightTextField.text;
        player.weight = [f numberFromString:_weightTextField.text];
        player.season = _seasonTextField.text;
        player.year = _gradeageclassTextField.text;
        player.position = _positionTextField.text;
        player.bio = _bioTextView.text;
        [player saveAthlete];
    }
}

- (void)savedPlayer:(NSNotification *)notification {
    if (imageselected)
        [self uploadImage:player];
    else
        [self playerSaved];
}

- (void)playerSaved {
    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Ahtlete Update Successful!"
                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _heightPicker)
        return 2;
    else
        return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if (pickerView == _positionPicker) {
        return [positionvalues count];
    } else if (pickerView == _heightPicker) {
        switch (component) {
            case 0:
                return [height count];
                break;
                
            default:
                return [inches count];
                break;
        }
    }
    return 0;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _positionPicker) {
        return [positionkeys objectAtIndex:row];
    } else if (pickerView == _heightPicker) {
        switch (component) {
            case 0:
                return [height objectAtIndex:row];
                break;
                
            default:
                return [inches objectAtIndex:row];
                break;
        }
     }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _positionPicker) {
        if (![[positionvalues objectAtIndex:row] isEqualToString:@"None"]) {
            
            if (_addPositionControl.selectedSegmentIndex == 0) {
                if (_positionTextField.text.length > 0) {
                    _positionTextField.text = [_positionTextField.text stringByAppendingFormat:@"%@%@", @"/", [positionvalues objectAtIndex:row]];
                } else {
                    _positionTextField.text = [positionvalues objectAtIndex:row];
                }
            } else {
                if (_positionTextField.text.length > 0) {
                    NSArray *positions = [_positionTextField.text componentsSeparatedByString:@"/"];
                     _positionTextField.text = @"";
                   
                    if (positions.count > 1) {
                        for (int i = 0; i < positions.count; i++) {
                            NSString *aposition = [positions objectAtIndex:i];
                            if (![aposition isEqualToString:[positionvalues objectAtIndex:row]]) {
                                if (i > 0)
                                    _positionTextField.text = [_positionTextField.text stringByAppendingString:@"/"];
                                
                                _positionTextField.text = [_positionTextField.text stringByAppendingString:[positions objectAtIndex:i]];
                            }
                        }
                    }
                }
            }
        } else {
            _positionTextField.text = @"";
        }
        
        [_addPositionControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
        _positionPicker.hidden = YES;
    } else if (pickerView == _heightPicker) {
        switch (component) {
            case 0:
                heighttext = [height objectAtIndex:row];
                break;
                
            case 1:
                _heightTextField.text = [NSString stringWithFormat:@"%@%@%@", heighttext, @"-", [inches objectAtIndex:row]];
                _heightPicker.hidden = YES;
                break;
        }
     }
}

- (IBAction)camerarollButtonClicked:(id)sender {
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
        
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
            _playerImage.image = [currentSettings normalizedImage:image scaledToSize:512];
        else
            _playerImage.image = [currentSettings normalizedImage:image scaledToSize:125];
        
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ((textField == _seasonTextField) || (textField == _gradeageclassTextField) ||
        (textField == _numberTextField) || (textField == _weightTextField)) {
        textField.text = @"";
    } else if (textField == _positionTextField) {
        [_positionTextField resignFirstResponder];
    } else if (textField == _heightTextField) {
        if (_heightPicker.hidden)
            _heightPicker.hidden = NO;
        else
            _heightPicker.hidden = YES;
            
        [_heightTextField resignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((textField == _numberTextField) && (_numberTextField.text.length == 0))
        _numberTextField.text = @"0";
    else if ((textField == _weightTextField) && (_weightTextField.text.length == 0))
        _weightTextField.text = @"0";
    else if (textField == _positionTextField)
        _positionPicker.hidden = YES;
}

- (IBAction)warningDeleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"All Athlete data will be lost. Click Confirm to Proceed"
                                                   delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)videosButtonClicked:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerPhotosSegue"]) {
        PhotosViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"PlayerVideosSegue"]) {
        VideosViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        EazeSoccerStatsViewController *destController = segue.destinationViewController;
        destController.athlete = player;
    } else if ([segue.identifier isEqualToString:@"BasketballStatsPlayerSegue"]) {
        EazeBasketballStatsViewController *destController = segue.destinationViewController;
        destController.athlete = player;
    } else if ([segue.identifier isEqualToString:@"FootballPlayerStatsSegue"]) {
        EazesportzFootballPlayerStatsViewController *destController = segue.destinationViewController;
        destController.player = player;
    }
}

- (void)deletePlayer:(NSNotification *)notification {
    if ([[[notification userInfo] valueForKey:@"Result"] isEqualToString:@"Success"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[player httperror]
                                                       delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Confirm"]) {
        [player deleteAthlete];
    } else if ([title isEqualToString:@"Offense"]) {
        positionkeys = [currentSettings.sport.footballOffensePositions allKeys];
        positionvalues = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [positionkeys count]; i++)
            [positionvalues addObject:[currentSettings.sport.footballOffensePositions objectForKey:[positionkeys objectAtIndex:i]]];
        
        [self.positionPicker reloadAllComponents];
        self.positionPicker.hidden = NO;
    } else if ([title isEqualToString:@"Defense"]) {
        positionkeys = [currentSettings.sport.footballDefensePositions allKeys];
        positionvalues = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [positionkeys count]; i++)
            [positionvalues addObject:[currentSettings.sport.footballDefensePositions objectForKey:[positionkeys objectAtIndex:i]]];
        
        [self.positionPicker reloadAllComponents];
        self.positionPicker.hidden = NO;
    } else if ([title isEqualToString:@"Special Teams"]) {
        positionkeys = [currentSettings.sport.footballSpecialTeamsPositions allKeys];
        positionvalues = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [positionkeys count]; i++)
            [positionvalues addObject:[currentSettings.sport.footballSpecialTeamsPositions objectForKey:[positionkeys objectAtIndex:i]]];
        
        [self.positionPicker reloadAllComponents];
        self.positionPicker.hidden = NO;
    } else if ([title isEqualToString:@"Info"]) {
        [self performSegueWithIdentifier:@"UpgradeInfoSegue" sender:self];
    }

}

- (BOOL)uploadImage:(Athlete *)athlete {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    // Upload image data.  Remember to set the content type.
//    imagepath = [NSString stringWithFormat:@"%@%@%@", [[currentSettings getBucket] name], @"/uploads/athletephotos/", athlete.athleteid];
    NSString *photopath = [NSString stringWithFormat:@"%@%@%@%@%@", @"uploads/athletephotos/",
                           athlete.athleteid, @"/", athlete.lastname, athlete.firstname];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:photopath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";
    
//    UIImage *image = [currentSettings normalizedImage:_playerImage.image scaledToSize:512];
    NSData *imageData = UIImageJPEGRepresentation(_playerImage.image, 1.0);
    
    NSLog(@"%d", imageData.length);
    
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
    
    NSURL *url = [NSURL URLWithString:[sportzServerInit updateAthletePhoto:player.athleteid Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@%@", @"uploads/athletephotos/", player.athleteid, @"/", player.lastname,
                      player.firstname];
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", [NSString stringWithFormat:@"%@%@", player.lastname, player.firstname], @"filename", nil];
    
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
        [self playerSaved];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _weightTextField) || (textField == _numberTextField)) {
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

- (IBAction)addPositionControl:(id)sender {
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select" message:@"Select Position"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Offense", @"Defense", @"Special Teams", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        positionkeys = [currentSettings.sport.playerPositions allKeys];
        positionvalues = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [positionkeys count]; i++)
            [positionvalues addObject:[currentSettings.sport.playerPositions objectForKey:[positionkeys objectAtIndex:i]]];
        
        [_positionPicker reloadAllComponents];
        _positionPicker.hidden = NO;
    }
}

- (IBAction)doneButtonClicked:(id)sender {
    _soccerStatsContainer.hidden = YES;
    _doneButton.enabled = NO;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.statsButton, self.doneButton, nil];
}

- (IBAction)saveButtonClicked:(id)sender {
//    [statsController saveButtonClicked:self];
}

- (IBAction)statButtonClicked:(id)sender {
    if ([currentSettings.sport isPackageEnabled]) {
        if ([currentSettings.sport.name isEqualToString:@"Soccer"])
            [self performSegueWithIdentifier:@"PlayerStatsSegue" sender:self];
        else if ([currentSettings.sport.name isEqualToString:@"Basketball"])
            [self performSegueWithIdentifier:@"BasketballStatsPlayerSegue" sender:self];
        else if ([currentSettings.sport.name isEqualToString:@"Football"])
            [self performSegueWithIdentifier:@"FootballPlayerStatsSegue" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Required"
                                                        message:[NSString stringWithFormat:@"%@%@", @"Stat support not available for ", player.logname]
                                                       delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Info", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
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
