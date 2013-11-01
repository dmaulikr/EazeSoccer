//
//  EditTeamViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/8/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EditTeamViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditTeamViewController () <UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, AmazonServiceRequestDelegate>

@end

@implementation EditTeamViewController {
    BOOL newmedia, imageselected, newteam;
    
    NSMutableData *theData;
    int responseStatusCode;
    NSMutableDictionary *serverData;
}

@synthesize team;
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
//    _deleteButton.backgroundColor = [UIColor redColor];
    _teamlogoLabel.layer.cornerRadius = 4;
    
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
    
    imageselected = NO;
    
    if (team) {
        _teamnameTextField.text = team.title;
        _mascotTextField.text = team.mascot;
        newteam = NO;
    } else {
        team = [[Team alloc] init];
        newteam = YES;
    }
    
    if (team.hasImage) {
        _teamImage.image = [team getImage:@"thumb"];
        _teamlogoLabel.hidden = YES;
    } else {
        _teamImage.image = [currentSettings.sport getImage:@"thumb"];
        _teamlogoLabel.text = @"Using Sport Logo - Change below";
    }
}

- (IBAction)camerarollButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Team Logo"
                          message: @"Logo will only be used for team! It will not replace the sport logo."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
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
        
        _teamImage.image = image;
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

- (IBAction)submitButtonClicked:(id)sender {
    NSURL *aurl;
    
    if (newteam)
        aurl = [NSURL URLWithString:[sportzServerInit addTeam:currentSettings.user.authtoken]];
    else
        aurl = [NSURL URLWithString:[sportzServerInit updateTeam:team.teamid Token:currentSettings.user.authtoken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180];
    NSError *jsonSerializationError = nil;
    
    NSMutableDictionary *teamDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_teamnameTextField text], @"title",
                                    [_mascotTextField text], @"mascot", nil];
    
/*    if (imageselected) {
        UIImage *photoImage = _teamImage.image;
        NSData *imageData = UIImageJPEGRepresentation(photoImage, 1.0);
        NSString *imageDataEncodedString = [imageData base64EncodedString];
        [teamDict setObject:imageDataEncodedString forKey:@"image_data"];
        [teamDict setObject:@"image/jpg" forKey:@"content_type"];
        NSString *name = [_teamnameTextField.text stringByAppendingFormat:@"%@%@%@", @"_", _mascotTextField.text, @".jpg"];
        [teamDict setObject:name forKey:@"original_filename"];
        imageselected = NO;
    }
*/
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:teamDict, @"team", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:nil error:&jsonSerializationError];
    
    if (jsonSerializationError) {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (!newteam)
        [request setHTTPMethod:@"PUT"];
    else
        [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Confirm Delete"
                          message: @"All data associated with team will be lost!"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Confirm", nil];
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
        NSDictionary *theteam = [serverData objectForKey:@"team"];
        team.teamid = [theteam objectForKey:@"_id"];
        team.team_logo = [theteam objectForKey:@"team_logo"];
        team.mascot = [theteam objectForKey:@"mascot"];
        team.team_name = [theteam objectForKey:@"title"];
        currentSettings.team = nil;
        
        if (imageselected)
            [self uploadImage:team];
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Team Update Successful!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Updating Team"
                                                        message:[serverData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        NSURL *url = [NSURL URLWithString:[sportzServerInit updateTeam:team.teamid Token:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSDictionary *jsonDict = [[NSDictionary alloc] init];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:nil error:&error];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"DELETE"];
        [request setHTTPBody:jsonData];
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
        NSArray *teamDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        if (responseStatusCode == 200) {
            team = nil;
            _teamnameTextField.text = @"";
            _mascotTextField.text = @"";
            _teamImage.image = nil;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Team"
                                                            message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (BOOL)uploadImage:(Team *)ateam {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    // Upload image data.  Remember to set the content type.
    NSString *imagepath = [NSString stringWithFormat:@"%@%@%@", @"uploads/teamphotos/", ateam.teamid, @"_logo"];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imagepath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";
    
    UIImage *image = _teamImage.image;
    UIImage *originalImage = _teamImage.image;
    CGAffineTransform transform = _teamImage.transform;
    
    if (CGAffineTransformEqualToTransform(transform, CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2))) {
        image = [UIImage imageWithCGImage:originalImage.CGImage scale:originalImage.scale orientation:UIImageOrientationRight];
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformRotate(CGAffineTransformIdentity, M_PI))) {
        image = [UIImage imageWithCGImage:originalImage.CGImage scale:originalImage.scale orientation:UIImageOrientationDown];
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2 * 3))) {
        image = [UIImage imageWithCGImage:originalImage.CGImage scale:originalImage.scale orientation:UIImageOrientationLeft];
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * 2))) {
        image = originalImage; // UIImageOrientationUp
    }
    
    _teamImage.image = image;
    
    NSData *imageData = UIImageJPEGRepresentation(_teamImage.image, 1.0);
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
    
    NSURL *url = [NSURL URLWithString:[sportzServerInit updateTeamLogo:team.teamid Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@", @"uploads/teamphotos/", team.teamid, @"_logo"];
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", [NSString stringWithFormat:@"%@%@", path, @"_logo"], @"filename", nil];
    
    //    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:athDict, @"athlete", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:athDict options:nil error:&error];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPMethod:@"PUT"];
    [urlrequest setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&error];
    responseStatusCode = [(NSHTTPURLResponse*)urlresponse statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *athdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        [currentSettings retrieveTeams];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Team Update Successful!"
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Team Logo Upload Error" delegate:self
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
    [_activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
