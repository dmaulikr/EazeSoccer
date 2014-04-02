//
//  EditCoachViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/17/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EditCoachViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditCoachViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,
                                       UIAlertViewDelegate, AmazonServiceRequestDelegate>

@end

@implementation EditCoachViewController {
    BOOL imageselected, newmedia;
    NSMutableDictionary *coachData;
    int responseStatusCode;
    NSMutableData *theData;
}

@synthesize coach;
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
    
    _bioTextView.layer.cornerRadius = 4;
    _deleteButton.layer.cornerRadius = 4;
    _activityIndicator.hidesWhenStopped = YES;
    _yearsOnStaffTextField.keyboardType = UIKeyboardTypeNumberPad;
    _bioTextView.layer.borderWidth = 1.0f;
    _bioTextView.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    UIImage *image;
    
    if (coach) {
        _coachFirstNameTextField.text = coach.firstname;
        _coachLastNameTextField.text = coach.lastname;
        _coachMiddleNameTextField.text = coach.middlename;
        _bioTextView.text = coach.bio;
        _yearsOnStaffTextField.text = [NSString stringWithFormat:@"%d", coach.years.intValue];
        _responsibilityTextField.text = coach.speciality;
        image = [coach getImage:@"thumb"];
    } else {
        _deleteButton.enabled = NO;
        _deleteButton.hidden = YES;
        _bioTextView.text = @"";
        _yearsOnStaffTextField.text = [NSString stringWithFormat:@"%d", 0];
        image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    
    imageselected = NO;
    _coachImage.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonClicked:(id)sender {
    if ((_coachFirstNameTextField.text.length > 0) && (_coachLastNameTextField.text.length > 0) &&
        (_responsibilityTextField.text.length > 0)) {
        NSURL *aurl;
        
        if (coach != nil)
            aurl = [NSURL URLWithString:[sportzServerInit getCoach:[coach coachid] Token:currentSettings.user.authtoken]];
        else
            aurl = [NSURL URLWithString:[sportzServerInit newCoach:currentSettings.user.authtoken]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180];
        NSError *jsonSerializationError = nil;
        
        NSMutableDictionary *coachdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_coachLastNameTextField text], @"lastname",
                                        [_coachFirstNameTextField text], @"firstname", [_coachMiddleNameTextField text], @"middlename",
                                        [_yearsOnStaffTextField text], @"years_on_staff", [_bioTextView text], @"bio",
                                        [_responsibilityTextField text], @"speciality", currentSettings.team.teamid, @"team_id", nil];
        
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:coachdata, @"coach", nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
        
        if (jsonSerializationError) {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        if (coach != nil)
            [request setHTTPMethod:@"PUT"];
        else
            [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:jsonData];
        
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [_activityIndicator startAnimating];
        [[NSURLConnection alloc] initWithRequest:request  delegate:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                             message:@"Last Name, First Name and Responsiblity must be completed!" delegate:self
                             cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
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
    
    if (responseStatusCode == 200) {
        coachData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
        NSDictionary *coachdict = [coachData objectForKey:@"coach"];
        
        coach = [[Coach alloc] initWithDictionary:coachdict];
        coach.coachid = [coachdict objectForKey:@"_id"];
        
        if (imageselected) {
            [self uploadImage:coach];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Updating Coach"
                                                        message:[coachData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
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

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Coach?"
                                            message:@"All data for coach will be lost!"
                                            delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
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
        
        _coachImage.image = [currentSettings normalizedImage:image scaledToSize:512];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:2];
        [siteStateText becomeFirstResponder];
    } else if (textField.tag == 2) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:3];
        [siteStateText becomeFirstResponder];
    } else if (textField.tag == 3) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:4];
        [siteStateText becomeFirstResponder];
    } else if (textField.tag == 4) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:5];
        [siteStateText becomeFirstResponder];
    } else if (textField.tag == 5) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:6];
        [siteStateText becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
/*    if (textField.text.length == 0) {
        if (textField == _coachLastNameTextField)
            textField.text = @"Last Name";
        else if (textField == _coachFirstNameTextField)
            textField.text = @"First Name";
        else if (textField == _responsibilityTextField)
            textField.text = @"Responsibity";
        else if (textField == _coachMiddleNameTextField)
            textField.text = @"Middle Name";
    } */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
         if (![coach initDeleteCoach]) {
             [self.navigationController popViewControllerAnimated:YES];
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[coach httperror]
                                                            delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
             [alert setAlertViewStyle:UIAlertViewStyleDefault];
             [alert show];
         }
    }
}

- (BOOL)uploadImage:(Coach *)acoach {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    // Upload image data.  Remember to set the content type.
    NSString *imagepath = [NSString stringWithFormat:@"%@%@%@%@%@", @"uploads/coachesphotos/", acoach.coachid, @"/",
                           acoach.lastname, acoach.firstname];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imagepath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";
    
    UIImage *image = _coachImage.image;
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
    
    NSURL *url = [NSURL URLWithString:[sportzServerInit updateCoachPhoto:coach.coachid Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@", @"uploads/coachesphotos/", coach.coachid, @"/",
                      [NSString stringWithFormat:@"%@%@", coach.lastname, coach.firstname]];
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", [NSString stringWithFormat:@"%@%@", coach.lastname, coach.firstname], @"filename", nil];
    
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
        [self.navigationController popViewControllerAnimated:YES];
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
