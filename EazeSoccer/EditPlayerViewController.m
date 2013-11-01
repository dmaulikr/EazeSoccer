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
//#import "PlayerStatsCollectionViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditPlayerViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate, AmazonServiceRequestDelegate>

@end

@implementation EditPlayerViewController {
    UIPickerView *positionpicker, *heightpicker, *weightpicker;
    
    NSArray *positionkeys;
    NSMutableArray *positionvalues;
    NSMutableArray *height, *inches;
    
    BOOL newmedia, imageselected;
    NSString *imagepath;
    
    NSString *heighttext;
    
    int responseStatusCode;
    NSMutableDictionary *serverData;
    NSMutableData *theData;
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
    self.view.backgroundColor = [UIColor clearColor];
    
    _bioTextView.layer.cornerRadius = 4;
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _weightTextField.keyboardType = UIKeyboardTypeNumberPad;
    _seasonTextField.keyboardType = UIKeyboardTypeNumberPad;
    imageselected = NO;
    
    positionpicker = [[UIPickerView alloc] init];
    positionpicker.dataSource = self;
    positionpicker.delegate = self;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.50];
    [UIView setAnimationDelegate:self];
    positionpicker.showsSelectionIndicator = YES;
    positionpicker.frame = CGRectMake(200, 200, positionpicker.frame.size.width, positionpicker.frame.size.height);
    _positionTextField.inputView = positionpicker;
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 320, 44)]; //should code with variables to support view resizing
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self action:@selector(dismissActionSheet:)];
    [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
    _positionTextField.inputAccessoryView = myToolbar;
        
    heightpicker = [[UIPickerView alloc] init];
    heightpicker.dataSource = self;
    heightpicker.delegate = self;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.50];
    [UIView setAnimationDelegate:self];
    heightpicker.showsSelectionIndicator = YES;
    heightpicker.frame = CGRectMake(200, 200, heightpicker.frame.size.width, heightpicker.frame.size.height);
    _heightTextField.inputView = heightpicker;
    myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 320, 44)]; //should code with variables to support view resizing
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                               target:self action:@selector(dismissActionSheet:)];
    [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
    _heightTextField.inputAccessoryView = myToolbar;

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath =[bundle pathForResource:@"Positions" ofType:@"plist"];
    NSDictionary *offpositions = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    positionkeys = [offpositions allKeys];
    positionvalues = [[NSMutableArray alloc] init];
    for (int i = 0; i < [positionkeys count]; i++)
        [positionvalues addObject:[offpositions objectForKey:[positionkeys objectAtIndex:i]]];
        
    height = [[NSMutableArray alloc] initWithObjects:@"3", @"4", @"5", @"6", @"7", @"8", nil];
    inches = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];

/*    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_scrollView addGestureRecognizer:singleTap];
    
    _activityIndicator.hidesWhenStopped = YES;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:_scrollView];
    [self.view endEditing:YES]; */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    heighttext = @"";
    
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
        
        _playerImage.image = [player getImage:@"thumb"];

        _positionTextField.text = player.position;
        
        if (player.hasphotos) {
            [_photosButton setTitle:@"Photos" forState:UIControlStateNormal];
//            _photosButton.backgroundColor = [UIColor greenColor];
        } else {
//            _photosButton.backgroundColor = [UIColor redColor];
            [_photosButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _photosButton.enabled = NO;
        }
        
        if (player.hasvideos) {
            [_videosButton setTitle:@"Videos" forState:UIControlStateNormal];
//            _videosButton.backgroundColor = [UIColor greenColor];
        } else {
//            _videosButton.backgroundColor = [UIColor redColor];
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
//        _photosButton.backgroundColor = [UIColor redColor];
//        _videosButton.backgroundColor = [UIColor redColor];
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
    NSURL *aurl;
    
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
        if (player != nil)
            aurl = [NSURL URLWithString:[sportzServerInit getAthlete:[player athleteid] Token:currentSettings.user.authtoken]];
        else
            aurl = [NSURL URLWithString:[sportzServerInit newAthlete:currentSettings.user.authtoken]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180];
        NSError *jsonSerializationError = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [_activityIndicator startAnimating];
        
        NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_numberTextField text], @"number",
                                        [_lastnameTextField text], @"lastname", [_middlenameTextField text], @"middlename",
                                        [_firstnameTextField text], @"firstname", [_heightTextField text], @"height",
                                        [_weightTextField text], @"weight", [_seasonTextField text], @"season",
                                        [_gradeageclassTextField text], @"year",
                                        _positionTextField.text, @"position", currentSettings.team.teamid, @"team_id",
                                         [_bioTextView text], @"bio", nil];
        
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:athDict, @"athlete", nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
        
        if (jsonSerializationError) {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        if (player != nil)
            [request setHTTPMethod:@"PUT"];
        else
            [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:jsonData];
        
        //Capturing server response
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
    [_activityIndicator stopAnimating];
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    if (responseStatusCode == 200) {
        NSDictionary *items = [serverData objectForKey:@"athlete"];
        player = [[Athlete alloc] initWithDictionary:items];
        player.athleteid = [items objectForKey:@"_id"];
        [currentSettings retrievePlayers];
        
        if (imageselected) {
            [self uploadImage:player];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Ahtlete Update Successful!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Updating Athlete"
                                                        message:[serverData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == heightpicker)
        return 2;
    else
        return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if (pickerView == positionpicker) {
        return [positionvalues count];
    } else if (pickerView == heightpicker) {
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
    if (pickerView == positionpicker) {
        return [positionkeys objectAtIndex:row];
    } else if (pickerView == heightpicker) {
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
    if (pickerView == positionpicker) {
        if (![[positionvalues objectAtIndex:row] isEqualToString:@"None"])
            _positionTextField.text = [positionvalues objectAtIndex:row];
        else
            _positionTextField.text = @"";
    } else if (pickerView == heightpicker) {
        switch (component) {
            case 0:
                heighttext = [height objectAtIndex:row];
                break;
                
            case 1:
                _heightTextField.text = [NSString stringWithFormat:@"%@%@%@", heighttext, @"-", [inches objectAtIndex:row]];
                break;
        }
     }
}

- (void)dismissActionSheet:(id)sender {
    [_positionTextField resignFirstResponder];
    [_heightTextField resignFirstResponder];
    if (_heightTextField.text.length == 0)
        _heightTextField.text = player.height;
    if (_weightTextField.text.length == 0)
        _weightTextField.text = [player.weight stringValue];
}

- (IBAction)camerarollButtonClicked:(id)sender {
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
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _playerImage.image = image;
/*        CGSize imageviewsize;
        
        if (_playerImage.image.size.width > _playerImage.image.size.height) {
            imageviewsize = CGSizeMake(100.0, 75.0);
            _playerImage.frame = CGRectMake(_playerImage.frame.origin.x, _playerImage.frame.origin.y, imageviewsize.width, imageviewsize.height);
        } else {
            imageviewsize = CGSizeMake(75.0, 100.0);
            _playerImage.frame = CGRectMake(_playerImage.frame.origin.x, _playerImage.frame.origin.y, imageviewsize.width,
                                           imageviewsize.height);
        } */
        if (newmedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
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
        (textField == _numberTextField) || (textField == _weightTextField))
        textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((textField == _numberTextField) && (_numberTextField.text.length == 0))
        _numberTextField.text = @"0";
    else if ((textField == _weightTextField) && (_weightTextField.text.length == 0))
        _weightTextField.text = @"0";
}

- (IBAction)warningDeleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"All Athlete data will be lost. Click Confirm to Proceed"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
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
    } else if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
//        PlayerStatsCollectionViewController *destController = segue.destinationViewController;
//        destController.player = player;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if ([currentSettings deletePlayer:player]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
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
    
    UIImage *image = _playerImage.image;
    UIImage *originalImage = _playerImage.image;
    CGAffineTransform transform = _playerImage.transform;
    
    if (CGAffineTransformEqualToTransform(transform, CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2))) {
        image = [UIImage imageWithCGImage:originalImage.CGImage scale:originalImage.scale orientation:UIImageOrientationRight];
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformRotate(CGAffineTransformIdentity, M_PI))) {
        image = [UIImage imageWithCGImage:originalImage.CGImage scale:originalImage.scale orientation:UIImageOrientationDown];
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2 * 3))) {
        image = [UIImage imageWithCGImage:originalImage.CGImage scale:originalImage.scale orientation:UIImageOrientationLeft];
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * 2))) {
        image = originalImage; // UIImageOrientationUp
    }
    
    _playerImage.image = image;

    NSData *imageData = UIImageJPEGRepresentation(_playerImage.image, 1.0);
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Ahtlete Update Successful!"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
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
@end
