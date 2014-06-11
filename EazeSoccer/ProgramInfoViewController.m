//
//  ProgramInfoViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/9/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "ProgramInfoViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzRetrieveTeams.h"
#import "EazesportzLogin.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ProgramInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,
                                        UIAlertViewDelegate, AmazonServiceRequestDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation ProgramInfoViewController {
    BOOL newmedia, imageselected, newsport;
    
    NSMutableDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;
    
    NSMutableArray *countryarray;
    NSArray *sportlist;
    NSString *country;
    BOOL selectSport;
    
    EazesportzRetrieveTeams *getTeams;
}

@synthesize sport;
@synthesize sportid;
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
        self.view.backgroundColor = [UIColor whiteColor];
    
    _cameraRollButton.layer.cornerRadius = 4;
    _deleteButton.layer.cornerRadius = 4;
    _activityIndicator.hidesWhenStopped = YES;
    _yearTextField.keyboardType = UIKeyboardTypeNumberPad;
    _zipcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _sportTextField.inputView = _pickerView.inputView;
    _countryTextField.inputView = _pickerView.inputView;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    NSArray *temparray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    countryarray = [[NSMutableArray alloc] init];
    [countryarray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"United States", @"name", @"US", @"code", nil]];
    [countryarray addObjectsFromArray:temparray];
    
    sportlist = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"GameTrackerSports"] allKeys];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [_scrollView addGestureRecognizer:gestureRecognizer];
}

-(void) hideKeyBoard:(id)sender {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    newmedia = NO;
    imageselected = NO;
    _pickerView.hidden = YES;
    selectSport = NO;
    
    
    if (currentSettings.isSiteOwner) {
        sport = [currentSettings retrieveSport:(currentSettings.sport.id)];
        _sitenameTextField.text = sport.sitename;
        _mascotTextField.text = sport.mascot;
        _yearTextField.text = sport.year;
        _zipcodeTextField.text = sport.zip;
        _countryTextField.text = sport.country;
        _sportTextField.text = sport.name;
        _sportTextField.enabled = NO;
        newsport = NO;
        _logoImage.image = [currentSettings.sport getImage:@"thumb"];
        
        if (!currentSettings.user.setupforads)
            [self displayAdWarning];
        
    } else if (sportid.length > 0) {
        sport = [currentSettings retrieveSport:(sportid)];
        _sitenameTextField.text = sport.sitename;
        _mascotTextField.text = sport.mascot;
        _yearTextField.text = sport.year;
        _zipcodeTextField.text = sport.zip;
        _countryTextField.text = sport.country;
        _sportTextField.text = sport.name;
        _logoImage.image = [sport getImage:@"thumb"];
        _sportTextField.enabled = NO;
        newsport = NO;
    } else {
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
        _sportTextField.enabled = YES;
        newsport = YES;
        sport = [[Sport alloc] init];
    }
    
    [_userVideosSwitch setOn:sport.enable_user_video];
    [_userPicsSwitch setOn:sport.enable_user_pics];
    [_reviewMediaSwitch setOn:sport.review_media];
}

- (void)displayAdWarning {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                message:@"Your site is not set up to collect ad revenue.\n Visit the website to set up your site to sell and collect ad revenue"
                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Visit Website", nil];
    [alert show];
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

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _logoImage.image = image;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed" message: @"Failed to save image" delegate: self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButtonClicked:(id)sender {
    NSURL *aurl;
    
    if (newsport)
        aurl = [NSURL URLWithString:[sportzServerInit addSport:currentSettings.user.authtoken]];
    else
        aurl = [NSURL URLWithString:[sportzServerInit getSport:currentSettings.user.authtoken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180];
    NSError *jsonSerializationError = nil;
    
    NSMutableDictionary *sportDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_sitenameTextField text], @"sitename",
                                     [_mascotTextField text], @"mascot", _yearTextField.text, @"year", _zipcodeTextField.text, @"zip",
                                      currentSettings.user.email, @"contactemail", @"Fall", @"season", _countryTextField.text, @"country",
                                      _sportTextField.text, @"name", [[NSNumber numberWithBool:sport.enable_user_pics] stringValue], @"enable_user_pics",
                                      [[NSNumber numberWithBool:sport.enable_user_video] stringValue], @"enable_user_video",
                                      [[NSNumber numberWithBool:sport.review_media] stringValue], @"review_media", nil];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:sportDict, @"sport", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (jsonSerializationError) {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (newsport)
        [request setHTTPMethod:@"POST"];
    else
        [request setHTTPMethod:@"PUT"];
    
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Confirm Delete"
                          message: @"All data associated with Sport will be lost! All Stats, Teams, Rosters, etc."
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Cofirm", nil];
    [alert show];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _countryTextField) {
        _pickerView.hidden = NO;
        selectSport = NO;
        [textField resignFirstResponder];
        [_pickerView reloadAllComponents];
    } else if (textField == _sportTextField) {
        _pickerView.hidden = NO;
        selectSport = YES;
        [textField resignFirstResponder];
        [_pickerView reloadAllComponents];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
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
        currentSettings.sport = [[Sport alloc] initWithDictionary:[serverData objectForKey:@"sport"]];
        
        if (currentSettings.sport.id.length == 0) {
            currentSettings.sport.id = [[serverData objectForKey:@"sport"] objectForKey:@"_id"];
        }
        
        if (imageselected) {
            [self uploadImage:currentSettings.sport];
        } else {
            [self saveCompleted];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Updating Sport" message:[serverData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)saveCompleted {
    currentSettings.user = [[[EazesportzLogin alloc] init] getUserSynchronous:currentSettings.user.userid];
    
    [currentSettings setUpSport:currentSettings.user.adminsite];
    
    if (newsport) {
        [self performSegueWithIdentifier:@"WelcomeSegue" sender:self];
    } else {
        UITabBarController *tabBarController = self.tabBarController;
        
        UIView * fromView = tabBarController.selectedViewController.view;
        UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
        
        if (fromView != toView) {
            // Transition using a page curl.
            [UIView transitionFromView:fromView toView:toView duration:0.5
                               options:(4 > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                            completion:^(BOOL finished) {
                                if (finished) {
                                    [self.navigationController popToRootViewControllerAnimated:NO];
                                    
                                    for (UIViewController *viewController in tabBarController.viewControllers) {
                                        if ([viewController isKindOfClass:[UINavigationController class]])
                                            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
                                    }
                                    
                                    tabBarController.selectedIndex = 0;
                                }
                            }];
        } else
            [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Confirm"]) {
        NSURL *url = [NSURL URLWithString:[sportzServerInit getSport:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSDictionary *jsonDict = [[NSDictionary alloc] init];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"DELETE"];
        [request setHTTPBody:jsonData];
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
        NSDictionary *teamDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        if (responseStatusCode == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Sport Delete Successful!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            currentSettings.sport = nil;
            _sitenameTextField.text = @"";
            _mascotTextField.text = @"";
            _yearTextField.text = @"";
            _zipcodeTextField.text = @"";
            _logoImage.image = nil;
            [self viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Sport" message:[teamDict objectForKey:@"error"]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([title isEqualToString:@"Visit Website"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentSettings.sport.adurl]];
        NSLog(@"adulr = %@", currentSettings.sport.adurl);
    }
}

- (BOOL)uploadImage:(Sport *)asport {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    // Upload image data.  Remember to set the content type.
    NSString *imagepath = [NSString stringWithFormat:@"%@%@%@", @"uploads/sportphotos/", asport.id, @"_logo"];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imagepath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";
    
    UIImage *image = _logoImage.image;
    NSData *imageData = UIImageJPEGRepresentation([currentSettings normalizedImage:image scaledToSize:125], 1.0);
    por.data = imageData;
    por.delegate = self;
    
    // Put the image data into the specified s3 bucket and object.
    [[currentSettings getS3] putObject:por];
    return YES;
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [_activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSURL *url = [NSURL URLWithString:[sportzServerInit updatelogo:currentSettings.user.authtoken]];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@", @"uploads/sportphotos/", currentSettings.sport.id, @"_logo"];
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", [NSString stringWithFormat:@"%@%@", currentSettings.sport.name, @"_logo"], @"filename", nil];
    
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
        [self saveCompleted];
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

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if (selectSport)
        return sportlist.count;
    else
        return countryarray.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (selectSport ) {
        return [sportlist objectAtIndex:row];
    } else {
        NSDictionary *subDict = [countryarray objectAtIndex:row];
        return [subDict objectForKey:@"name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (selectSport) {
        _sportTextField.text = [sportlist objectAtIndex:row];
    } else {
        NSDictionary *subDict = [countryarray objectAtIndex:row];
        _countryTextField.text = [subDict objectForKey:@"name"];
        country = [subDict objectForKey:@"name"];
    }
    _pickerView.hidden = YES;
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

- (IBAction)saveBarButtonClicked:(id)sender {
    [self submitButtonClicked:sender];
}

- (IBAction)userPicsSwitchSelected:(id)sender {
    if ([_userPicsSwitch isOn]) {
        sport.enable_user_pics = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Setting this will allow your fans to upload photos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else
        sport.enable_user_pics = NO;
}

- (IBAction)userVideosSwitchSelected:(id)sender {
    if ([_userVideosSwitch isOn]) {
        sport.enable_user_video = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Setting this will allow your fans to upload videos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else
        sport.enable_user_video = NO;
}

- (IBAction)reviewMediaSwitchSelected:(id)sender {
    if ([_reviewMediaSwitch isOn]) {
        sport.review_media = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Media Review On" message:@"You will have to review and approve user photos and videos before they are posted for general viewing." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        sport.review_media = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Media Review Off" message:@"User photos and videos will be posted immediately." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

@end
