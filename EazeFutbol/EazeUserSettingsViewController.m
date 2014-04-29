//
//  sportzteamsUserSettingsViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 5/13/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "EazeUserSettingsViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzDisplayAdBannerViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EazeUserSettingsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AmazonServiceRequestDelegate>

@end

@implementation EazeUserSettingsViewController {
    NSDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;
    
    NSString * imagepath;
    
    BOOL newmedia, imageselected;
    User *user;
    
    EazesportzDisplayAdBannerViewController *adBannerController;
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
//    self.view.backgroundColor = [UIColor clearColor];
    
    _bioLabel.layer.cornerRadius = 6;
    _blogLabel.layer.cornerRadius = 6;
    _statsLabel.layer.cornerRadius = 6;
    _scoreLabel.layer.cornerRadius = 6;
    _mediaLabel.layer.cornerRadius = 6;
    _alertLabel.layer.cornerRadius = 6;
    _camerarollButton.layer.cornerRadius = 6;
    _camerabutton.layer.cornerRadius = 6;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_scrollView addGestureRecognizer:singleTap];
    
    _activityIndicator.hidesWhenStopped = YES;
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
    
    if (currentSettings.user.avatarprocessing) {
        NSURL *url = [NSURL URLWithString:[sportzServerInit getUser:currentSettings.user.userid Token:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        if (responseStatusCode == 200) {
            currentSettings.user = [[User alloc] initWithDictionary:userdata];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                           delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }

    [_usernameTextField setText:currentSettings.user.username];
    NSURL *imageURL;
    UIImage *image;
    if ([currentSettings.user.userthumb length] > 0) {
        imageURL = [NSURL URLWithString:currentSettings.user.userthumb];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        image = [UIImage imageWithData:imageData];
    } else if (currentSettings.user.avatarprocessing) {
        image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
    } else {
        image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    [_userImage setImage:image];
    
    if ([currentSettings.user.bio_alert integerValue] == 1)
        [_bioSwitch setOn:YES];
    else
        [_bioSwitch setOn:NO];
    
    if ([currentSettings.user.blog_alert integerValue] == 1)
        [_blogSwitch setOn:YES];
    else
        [_blogSwitch setOn:NO];
    
    if ([currentSettings.user.stat_alert integerValue] == 1)
        [_statsSwitch setOn:YES];
    else
        [_statsSwitch setOn:NO];
    
    if ([currentSettings.user.score_alert integerValue] == 1)
        [_scoreSwitch setOn:YES];
    else
        [_scoreSwitch setOn:NO];
    
    if ([currentSettings.user.media_alert integerValue] == 1)
        [_mediaSwitch setOn:YES];
    else
        [_mediaSwitch setOn:NO];
 
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController displayAd];
    } else {
        _adBannerContainer.hidden = YES;
    }
}

- (void)retrieveUser:(NSString *)auserid {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getUser:auserid Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        user = [[User alloc] initWithDictionary:userdata];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:[sportzServerInit updateUser:currentSettings.user.userid Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *userData = [[NSDictionary alloc] initWithObjectsAndKeys:[_usernameTextField text], @"username",
                              [NSNumber numberWithBool:[_bioSwitch isOn]], @"bio_alert", [NSNumber numberWithBool:[_blogSwitch isOn]],
                              @"blog_alert", [NSNumber numberWithBool:[_statsSwitch isOn]], @"stat_alert",
                              [NSNumber numberWithBool:[_scoreSwitch isOn]], @"score_alert", [NSNumber numberWithBool:[_mediaSwitch isOn]],
                              @"media_alert", nil];
    NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
    [jsonDict setValue:userData forKey:@"user"];
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
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:jsonData];
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
        NSLog(@"%@", serverData);
        currentSettings.user.username = [_usernameTextField text];
        NSDictionary *auser = [serverData objectForKey:@"user"];
        currentSettings.user.authtoken = [serverData objectForKey:@"authentication_token"];
        
        if ([_bioSwitch isOn])
            currentSettings.user.bio_alert = [NSNumber numberWithInteger:1];
        else
            currentSettings.user.bio_alert = [NSNumber numberWithInteger:0];
        
        if ([_blogSwitch isOn])
            currentSettings.user.blog_alert = [NSNumber numberWithInteger:1];
        else
            currentSettings.user.blog_alert = [NSNumber numberWithInteger:0];
        
        if ([_mediaSwitch isOn])
            currentSettings.user.media_alert = [NSNumber numberWithInteger:1];
        else
            currentSettings.user.media_alert = [NSNumber numberWithInteger:0];
        
        if ([_statsSwitch isOn])
            currentSettings.user.stat_alert = [NSNumber numberWithInteger:1];
        else
            currentSettings.user.stat_alert = [NSNumber numberWithInteger:0];
        
        if ([_scoreSwitch isOn])
            currentSettings.user.score_alert = [NSNumber numberWithInteger:1];
        else
            currentSettings.user.score_alert = [NSNumber numberWithInteger:0];
        
        if (imageselected) {
            [self uploadImage:currentSettings.user];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:[NSString stringWithFormat:@"User Attributes Updated!"]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            [self viewWillAppear:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _bannerView.hidden = YES;
}

- (IBAction)cameraRollButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newmedia = NO;
    }
}

- (IBAction)cameraButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
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

-(void)imagePickerController:(UIImagePickerController *)picke didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _userImage.image = [currentSettings normalizedImage:image scaledToSize:125];
        
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

- (BOOL)uploadImage:(User *)user {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    // Upload image data.  Remember to set the content type.
    imagepath = [NSString stringWithFormat:@"%@%@%@%@", @"uploads/userphotos/", user.userid, @"/", user.username];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imagepath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";
    NSData *imageData = UIImageJPEGRepresentation(_userImage.image, 1.0);
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
    
    NSURL *url = [NSURL URLWithString:[sportzServerInit uploadUserAvatar:currentSettings.user.userid Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@", @"uploads/userphotos/", currentSettings.user.userid, @"/",
                      currentSettings.user.username];
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", currentSettings.user.username, @"filename", nil];
    
//    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:athDict, @"user", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:athDict options:0 error:&error];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPMethod:@"PUT"];
    [urlrequest setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&error];
    responseStatusCode = [(NSHTTPURLResponse*)urlresponse statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        NSDictionary *useravatardata = [userdata objectForKey:@"user"];
        
        currentSettings.user.avatarprocessing = [[useravatardata objectForKey:@"avatarprocessing"] boolValue];
        if ((NSNull *)[useravatardata objectForKey:@"avatarthumburl"] != [NSNull null])
            currentSettings.user.userthumb = [useravatardata objectForKey:@"avatarthumburl"];
        else
            currentSettings.user.userthumb = @"";
        
        if ((NSNull *)[useravatardata objectForKey:@"avatartinyurl"] != [NSNull null])
            currentSettings.user.tiny = [useravatardata objectForKey:@"avatartinyurl"];
        else
            currentSettings.user.tiny = @"";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"User Update Successful!"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[userdata objectForKey:@"error"]
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adBannerController = segue.destinationViewController;
    }
}

@end
