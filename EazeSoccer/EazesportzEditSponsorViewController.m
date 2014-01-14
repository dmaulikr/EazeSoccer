//
//  EazesportzEditSponsorViewController.m
//  EazeSportz
//
//  Created by Gil on 1/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzEditSponsorViewController.h"
#import "EazesportzAppDelegate.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface EazesportzEditSponsorViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,
                                                   UIAlertViewDelegate, AmazonServiceRequestDelegate>

@end

@implementation EazesportzEditSponsorViewController {
    BOOL newmedia, imageselected;
}

@synthesize sponsor;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sponsorDeleted:) name:@"SponsorDeletedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sponsorSaved:) name:@"SponsorSavedNotification" object:nil];
    
    _streetNumber.keyboardType = UIKeyboardTypeNumberPad;
    _zipcode.keyboardType = UIKeyboardTypeNumberPad;
    _sponsorEmail.keyboardType = UIKeyboardTypeEmailAddress;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    // do not forget to unsubscribe the observer, or you may experience crashes towards a deallocated observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (sponsor) {
        if (sponsor.thumb.length > 0) {
            NSURL * imageURL = [NSURL URLWithString:sponsor.thumb];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            _sponsorImage.image = [UIImage imageWithData:imageData];
        } else {
            _sponsorImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        }
        _sponsorName.text = sponsor.name;
        _streetNumber.text = [sponsor.addrnum stringValue];
        _streetName.text = sponsor.street;
        _city.text = sponsor.city;
        _state.text = sponsor.state;
        _zipcode.text = sponsor.zip;
        _phone.text = sponsor.phone;
        _mobile.text = sponsor.mobile;
        _faxnumber.text = sponsor.fax;
        _sponsorEmail.text = sponsor.email;
        _sponsorurl.text = sponsor.adurl;
        
        if ([sponsor.sponsorlevel isEqualToString:@"Platinum"])
            _sponsorLevel.selectedSegmentIndex = 1;
        else if ([sponsor.sponsorlevel isEqualToString:@"Gold"])
            _sponsorLevel.selectedSegmentIndex = 2;
        
    } else {
        _sponsorImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
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
        NSData *imgData=UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
        NSLog(@"%d", [imgData length]);
        UIImage *image = [[UIImage alloc] initWithData:imgData];
        
        if (newmedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        
        _sponsorImage.image = image;
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
    CGImageRef cgref = [_sponsorImage.image CGImage];
    CIImage *cim = [_sponsorImage.image CIImage];

    if (_sponsorName.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sponsor must have a name!"
                                                delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if ((cgref == NULL) && (cim == nil)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sponsor must have an image!"
                                                       delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (_sponsorurl.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sponsor must have a url for your fans to click!"
                                                       delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (!sponsor) {
        sponsor = [[Sponsor alloc] init];
    }
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    sponsor.name = _sponsorName.text;
    sponsor.addrnum = [f numberFromString:_streetNumber.text];
    sponsor.street = _streetName.text;
    sponsor.city = _city.text;
    sponsor.state = _state.text;
    sponsor.zip = _zipcode.text;
    sponsor.phone = _phone.text;
    sponsor.mobile = _mobile.text;
    sponsor.fax = _faxnumber.text;
    sponsor.adurl = _sponsorurl.text;
    sponsor.email = _sponsorEmail.text;
    
    if (_sponsorLevel.selectedSegmentIndex == 0)
        sponsor.sponsorlevel = @"Platinum";
    else if (_sponsorLevel.selectedSegmentIndex == 1)
        sponsor.sponsorlevel = @"Gold";
    else
        sponsor.sponsorlevel = @"Platinum";
    
    [sponsor saveSponsor];
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Delete Sponsor?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Delete"]) {
        [_activityIndicator startAnimating];
        [sponsor deleteSponsor];
    }
}

- (void)sponsorSaved:(NSNotification *)notification {
    if ([[[notification userInfo] valueForKey:@"Result"] isEqualToString:@"Success"]) {
        if (imageselected) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [_activityIndicator startAnimating];
            // Upload image data.  Remember to set the content type.
            //    imagepath = [NSString stringWithFormat:@"%@%@%@", [[currentSettings getBucket] name], @"/uploads/sponsorsphotos/", athlete.athleteid];
            NSString *photopath = [NSString stringWithFormat:@"%@%@%@%@%@", @"uploads/sponsorsphotos/",
                                   sponsor.sponsorid, @"/", sponsor.name, sponsor.street];
            S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:photopath inBucket:[[currentSettings getBucket] name]];
            por.contentType = @"image/jpeg";
            
            //    UIImage *image = [currentSettings normalizedImage:_playerImage.image scaledToSize:512];
            NSData *imageData = UIImageJPEGRepresentation(_sponsorImage.image, 1.0);
            
            NSLog(@"%d", imageData.length);
            
            por.data = imageData;
            por.delegate = self;
            
            // Put the image data into the specified s3 bucket and object.
            [[currentSettings getS3] putObject:por];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:sponsor.httperror
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)sponsorDeleted:(NSNotification *)notification {
    if ([[[notification userInfo] valueForKey:@"Result"] isEqualToString:@"Success"]) {
        [_activityIndicator stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:sponsor.httperror
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [_activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], @"/sports/",
                                       currentSettings.sport.id, @"/sponsors/", sponsor.sponsorid, @"/updatephoto.json?auth_token=", currentSettings.user.authtoken]];;
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@%@%@%@%@", @"uploads/sponsorsphotos/", sponsor.sponsorid, @"/", sponsor.name,
                      sponsor.street];
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: path, @"filepath", @"image/jpeg",
                                    @"filetype", [NSString stringWithFormat:@"%@%@", sponsor.name, sponsor.street], @"filename", nil];
    
    //    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:athDict, @"athlete", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:athDict options:0 error:&error];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPMethod:@"PUT"];
    [urlrequest setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&error];
    int responseStatusCode = [(NSHTTPURLResponse*)urlresponse statusCode];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _zipcode) || (textField == _streetNumber)) {
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
