//
//  EditUserViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/10/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EditUserViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "KeychainWrapper.h"
#import "sportzConstants.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditUserViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,
                                      AmazonServiceRequestDelegate>

@end

@implementation EditUserViewController {
    User *user;
    NSMutableDictionary *userdata;
    int responseStatusCode;
    NSMutableData *theData;
    
    NSString *imagepath;
    BOOL newmedia, imageselected;
}

@synthesize userid;
@synthesize theuser;
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
    
    _deleteAvatarButton.layer.cornerRadius = 4;
    _activeLabel.layer.cornerRadius = 4;
    _resetPassword.layer.cornerRadius = 4;
    
    _activeSwitch.enabled = YES;
    
    _activityIndicator.hidesWhenStopped = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((theuser == nil) && (userid == nil)) {
        user = currentSettings.user;
    } else if (userid) {
        _resetPassword.hidden = YES;
        _resetPassword.enabled = NO;
        
        NSURL *url = [NSURL URLWithString:[sportzServerInit getUser:userid Token:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        if (responseStatusCode == 200) {
            user = [[User alloc] initWithDictionary:userdata];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User"
                                                            message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        user = theuser;
    }
    
    _emailTextField.text = user.email;
    _usernameTextField.text = user.username;
    
    if (!user.admin) {
        if ([user.isactive boolValue])
            _activeSwitch.selected = YES;
        else
            _activeSwitch.selected = NO;
        
    } else {
        _activeLabel.hidden = YES;
        _activeSwitch.hidden = YES;
        _activeSwitch.enabled = NO;
    }
    
    if (user.avatarprocessing) {
        _userimage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
    } else if (user.userthumb.length == 0)
        _userimage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    else {
        NSURL * imageURL = [NSURL URLWithString:user.userthumb];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        _userimage.image = [UIImage imageWithData:imageData];
    }
}

- (IBAction)deleteAvatarButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:[sportzServerInit deleteAvatar:user.userid Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    int aresponseStatusCode = [(NSHTTPURLResponse*)response statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *auserdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    NSLog(@"%@", auserdata);
    
    if (aresponseStatusCode == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"User image removed!"
                                                        delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error removing user image"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    NSURL *aurl;
    
    if (currentSettings.isSiteOwner)
        aurl = [NSURL URLWithString:[sportzServerInit updateUser:currentSettings.user.userid Token:currentSettings.user.authtoken]];
    else
        aurl = [NSURL URLWithString:[sportzServerInit updateUser:user.userid Token:currentSettings.user.authtoken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    
    BOOL activeuser = NO;
    
    if (!currentSettings.isSiteOwner)
        activeuser = _activeSwitch.isSelected;
    else
        activeuser = YES;
    
    NSMutableDictionary *userDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: _emailTextField.text, @"email",
                                      _usernameTextField.text, @"name", [NSString stringWithFormat:@"%d", activeuser], @"is_active", nil];
    
    if (currentSettings.isSiteOwner) {
        [userDict setObject:currentSettings.user.email forKey:@"email"];
        [userDict setObject:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED] forKey:@"password"];
        [userDict setObject:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED] forKey:@"current_password"];
        [userDict setObject:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED] forKey:@"password_confirmation"];
    }
    
/*    if (imageselected) {
        UIImage *photoImage = _userimage.image;
        NSData *imageData = UIImageJPEGRepresentation(photoImage, 1.0);
        NSString *imageDataEncodedString = [imageData base64EncodedString];
        [userDict setObject:imageDataEncodedString forKey:@"image_data"];
        [userDict setObject:@"image/jpg" forKey:@"content_type"];
//        NSString *name = [_emailTextField.text stringByAppendingFormat:@"%@%@%@", @"_", _usernameTextField.text, @".jpg"];
        [userDict setObject:[NSString stringWithFormat:@"%@%@", _usernameTextField.text, @".jpg"] forKey:@"original_filename"];
        imageselected = NO;
    } */
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:userDict, @"user", nil];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:jsonData];
    
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
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
    userdata = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        NSLog(@"%@", userdata);
        user = [[User alloc] initWithDictionary:[userdata objectForKey:@"user"]];
        user.userid = [[userdata objectForKey:@"user"] objectForKey:@"_id"];
         
        if ([user.userid isEqualToString:currentSettings.user.userid]) {
            currentSettings.user = user;
            currentSettings.user.authtoken = [userdata objectForKey:@"authentication_token"];
        }
        
        if (imageselected) {
            [self uploadImage:user];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"User Update Successful!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Updating User"
                                                        message:[userdata objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
 }

-(void)textFieldDidEndEditing:(UITextField *)textField {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
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
        
        _userimage.image = [currentSettings normalizedImage:image scaledToSize:512];
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

- (IBAction)resetPasswordButtonClicked:(id)sender {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    urlString = [urlString stringByAppendingFormat:@"%@", @"/users/password/new"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
}

- (BOOL)uploadImage:(User *)auser {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    // Upload image data.  Remember to set the content type.
    imagepath = [NSString stringWithFormat:@"%@%@%@%@", @"uploads/usersphotos/", auser.userid, @"/",
                 user.username];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imagepath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";

    UIImage *image = _userimage.image;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
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
    
    NSURL *url = [NSURL URLWithString:[sportzServerInit uploadUserAvatar:user.userid Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@", @"uploads/usersphotos/", user.userid, @"/", user.username];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", user.username, @"filename", nil];
    
    //    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:athDict, @"athlete", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:0 error:&error];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPMethod:@"PUT"];
    [urlrequest setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&error];
    responseStatusCode = [(NSHTTPURLResponse*)urlresponse statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *athdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        if ([user.userid isEqualToString:currentSettings.user.userid]) {
            NSDictionary *useravatarData = [athdata objectForKey:@"user"];
            user.userthumb = [useravatarData objectForKey:@"avatarthumburl"];
            user.tiny = [useravatarData objectForKey:@"avatartinyurl"];
            currentSettings.user = user;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"User Update Successful!"
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Avatar Upload Error" delegate:self
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
