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

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ProgramInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,
                                        UIAlertViewDelegate, AmazonServiceRequestDelegate>

@end

@implementation ProgramInfoViewController {
    BOOL newmedia, imageselected, newsport;
    
    NSMutableDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;
}

@synthesize sport;
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
    _cameraRollButton.layer.cornerRadius = 4;
    _deleteButton.layer.cornerRadius = 4;
//    _deleteButton.backgroundColor = [UIColor redColor];
    _activityIndicator.hidesWhenStopped = YES;
    _yearTextField.keyboardType = UIKeyboardTypeNumberPad;
    _zipcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    newmedia = NO;
    imageselected = NO;
    
    if (currentSettings.sport.id.length == 0) {
        self.navigationItem.hidesBackButton = YES;
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
        newsport = YES;
        sport = [[Sport alloc] init];
    } else {
        [currentSettings retrieveSport];
        sport = currentSettings.sport;
        _sitenameTextField.text = sport.sitename;
        _mascotTextField.text = sport.mascot;
        _yearTextField.text = sport.year;
        _zipcodeTextField.text = sport.zip;
        newsport = NO;
    }
    
    _logoImage.image = [currentSettings.sport getImage:@"thumb"];
}

- (IBAction)cameraRollButtonClicked:(id)sender {
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
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: self
                              cancelButtonTitle:@"OK"
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
                                      currentSettings.user.email, @"contactemail", @"Fall", @"season", @"Basketball", @"name", nil];
    
/*    if (imageselected) {
        UIImage *photoImage = _logoImage.image;
        NSData *imageData = UIImageJPEGRepresentation(photoImage, 1.0);
        NSString *imageDataEncodedString = [imageData base64EncodedString];
        [sportDict setObject:imageDataEncodedString forKey:@"image_data"];
        [sportDict setObject:@"image/jpg" forKey:@"content_type"];
        NSString *name = [_sitenameTextField.text stringByAppendingFormat:@"%@%@%@", @"_", _mascotTextField.text, @".jpg"];
        [sportDict setObject:name forKey:@"original_filename"];
        imageselected = NO;
    } */
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:sportDict, @"sport", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:nil error:&jsonSerializationError];
    
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
    textField.text = @"";
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
        NSDictionary *sportdata = [serverData objectForKey:@"sport"];
        sport.id = [sportdata objectForKey:@"_id"];
        sport.sitename = [sportdata objectForKey:@"sitename"];
        sport.mascot = [sportdata objectForKey:@"mascot"];
        sport.year = [sportdata objectForKey:@"year"];
        sport.zip = [sportdata objectForKey:@"zip"];
        sport.sport_logo = [sportdata objectForKey:@"sport_logo"];
        sport.sport_logo_thumb = [sportdata objectForKey:@"sport_logo_thumb"];
        sport.sport_logo_medium = [sportdata objectForKey:@"sport_logo_medium"];
        sport.sport_logo_tiny = [sportdata objectForKey:@"sport_logo_tiny"];
        sport.banner = [sportdata objectForKey:@"banner_url"];
        sport.name = [sportdata objectForKey:@"name"];
        sport.season = [sportdata objectForKey:@"season"];
        sport.has_stats = [NSNumber numberWithBool:[[sportdata objectForKey:@"has_stats"] boolValue]];
        sport.alert_interval = [sportdata objectForKey:@"alert_interval"];
        sport.gamelog_interval = [sportdata objectForKey:@"gamelog_interval"];
        sport.newsfeed_interval = [sportdata objectForKey:@"newsfeed_interval"];
        sport.beta = [[sportdata objectForKey:@"beta"] boolValue];
        sport.approved = [[sportdata objectForKey:@"approved"] boolValue];
        
        currentSettings.sport = sport;
        
        if (imageselected) {
            [self uploadImage:currentSettings.sport];
        } else {        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Sport Update Successful!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Updating Sport"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
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
    NSData *imageData = UIImageJPEGRepresentation([currentSettings normalizedImage:image], 1.0);
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

        if (newsport) {
            self.navigationItem.hidesBackButton = NO;
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Sport Logo Update Being Processed!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            [self viewWillAppear:YES];
        }
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

@end
