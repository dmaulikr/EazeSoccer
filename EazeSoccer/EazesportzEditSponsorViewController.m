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
                                                   UIAlertViewDelegate, AmazonServiceRequestDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation EazesportzEditSponsorViewController {
    NSDictionary *stateDictionary;
    BOOL newmedia, bannermedia, bannerimageselected, sponsorimageselected, statePicker, adInventoryPicker, countryPick, bannerimgselected;
    NSMutableArray *countryarray;
    NSArray *stateList;
    NSString *country, *stateabreviation;
    
    Sportadinv *adinventory;
}

@synthesize sponsor;
@synthesize popover;

@synthesize storekitProduct;
@synthesize adproduct;
@synthesize player;

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
    
    _streetNumber.keyboardType = UIKeyboardTypeNumberPad;
    _zipcode.keyboardType = UIKeyboardTypeNumberPad;
    _sponsorEmail.keyboardType = UIKeyboardTypeEmailAddress;
    _sponsorurl.keyboardType = UIKeyboardTypeURL;
    _phone.keyboardType = UIKeyboardTypeNamePhonePad;
    _faxnumber.keyboardType = UIKeyboardTypeNamePhonePad;
    _mobile.keyboardType = UIKeyboardTypeNamePhonePad;
    
    _countryTextField.inputView = _countryPicker.inputView;
    _adInventoryTextField.inputView = _countryPicker.inputView;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    NSArray *temparray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    countryarray = [[NSMutableArray alloc] init];
    [countryarray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"United States", @"name", @"US", @"code", nil]];
    [countryarray addObjectsFromArray:temparray];
    plistPath = [[NSBundle mainBundle] pathForResource:@"USStateAbbreviations" ofType:@"plist"];
    stateDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * keys = [stateDictionary allKeys];
    stateList = [keys sortedArrayUsingSelector:@selector(compare:)];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sponsorDeleted:) name:@"SponsorDeletedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sponsorSaved:) name:@"SponsorSavedNotification" object:nil];
    
    _countryPicker.hidden = YES;
    statePicker = NO;
    countryPick = YES;
    adInventoryPicker = NO;
    
    if (sponsor) {
        if ([currentSettings isSiteOwner]) {
            if (![sponsor.user_id isEqualToString:currentSettings.user.userid]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You are editing ad purchased by a fan!" delegate:nil
                                                      cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }
            
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
            if (sponsor.thumbimage) {
                _sponsorImage.image = [currentSettings normalizedImage:sponsor.thumbimage scaledToSize:125];
            } else {
                _sponsorImage.image = [currentSettings normalizedImage:[UIImage imageNamed:@"photo_not_available.png"] scaledToSize:125];
            }
        } else {
            if (sponsor.mediumimage) {
                _sponsorImage.image = [currentSettings normalizedImage:sponsor.mediumimage scaledToSize:200];
            } else {
                _sponsorImage.image = [currentSettings normalizedImage:[UIImage imageNamed:@"photo_not_available.png"] scaledToSize:200];
            }
        }
        
        if (sponsor.athlete_id.length > 0) {
            player = [currentSettings findAthlete:sponsor.athlete_id];
            _sponsorImage.hidden = YES;
            _sponsorCameraButton.hidden = YES;
            _sponsorCameraButton.enabled = NO;
            _sponsorCameraRollButton.hidden = YES;
            _sponsorCameraRollButton.enabled = NO;
            _adInventoryTextField.hidden = YES;
            _adInventoryTextField.enabled = NO;
        } else {
            _sponsorCameraRollButton.hidden = NO;
            _sponsorCameraRollButton.enabled = YES;
            _sponsorCameraButton.hidden = NO;
            _sponsorCameraButton.enabled = YES;
        }
                
        _bannerImage.image = [sponsor getPortraitBanner];
        
        if ((_bannerImage.image.CIImage == nil) && (_bannerImage.image.CGImage == nil) && (!bannermedia)) {
            _bannerlogoImage.image = [currentSettings.team getImage:@"tiny"];
            _bannerlogoTitleLabel.text = [NSString stringWithFormat:@"%@ Proud Sponsor", currentSettings.team.mascot];
            _bannerlogoMessageLabel.text = [NSString stringWithFormat:@"%@", sponsor.name];
       } else {
            _bannerlogoImage.hidden = YES;
            _bannerlogoMessageLabel.hidden = YES;
            _bannerlogoTitleLabel.hidden = YES;
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
        _adInventoryTextField.text = [[currentSettings.inventorylist findAdInventory:sponsor.sportadinv_id] adnameprice];
        _adInventoryTextField.enabled = NO;
        _checkImageButton.enabled = YES;
        _checkImageButton.hidden = NO;
        
        if (sponsor.athlete_id.length > 0) {
            _playerTextField.text = [[currentSettings findAthlete:sponsor.athlete_id] numberLogname];
            _playerTextField.hidden = NO;
            _playerTextField.enabled = NO;
        } else {
            _playerTextField.hidden = YES;
            _playerTextField.enabled = NO;
        }
    } else {
        _checkImageButton.enabled = NO;
        _checkImageButton.hidden = YES;
        _adInventoryTextField.enabled = YES;
        
        if ([currentSettings isSiteOwner]) {
            _playerTextField.hidden = YES;
            _playerTextField.enabled = NO;
            _sponsorCameraButton.hidden = NO;
            _sponsorCameraButton.enabled = YES;
            _sponsorCameraRollButton.hidden = NO;
            _sponsorCameraRollButton.enabled = YES;
            
            if ((_sponsorImage.image.CIImage == nil) && (_sponsorImage.image.CGImage == nil))
                _sponsorImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];

            if ((_bannerImage.image.CIImage == nil) && (_bannerImage.image.CGImage == nil) && (!bannermedia))  {
                _bannerlogoImage.image = [currentSettings.team getImage:@"tiny"];
                _bannerlogoTitleLabel.text = [NSString stringWithFormat:@"%@ Proud Sponsor", currentSettings.team.mascot];
                _bannerlogoMessageLabel.text = @"Sponsor's message appears here!";
            } else if (bannermedia) {
                _bannerlogoImage.hidden = YES;
                _bannerlogoMessageLabel.hidden = YES;
                _bannerlogoTitleLabel.hidden = YES;
            }

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome"
                                message:[NSString stringWithFormat:@"As an administrator you can edit and create new ad sponsors for the %@. General advertisers will have to use the web site to purchase ad inventory you created. Fans and advertisers will be able to purchase ad inventory that is offered by the GameTracker app.\n Use this to add sponsors that you have collected revenue from outside of GameTracker.",
                                         currentSettings.team.mascot] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        } else if ((storekitProduct) && (adproduct)) {
            _adInventoryTextField.hidden = YES;
            _adInventoryTextField.enabled = NO;
            
            if (adproduct.playerad) {
                _playerTextField.text = player.numberLogname;
                _playerTextField.hidden = NO;
                _playerTextField.enabled = NO;
                
                _sponsorImage.hidden = YES;
                _sponsorCameraButton.hidden = YES;
                _sponsorCameraButton.enabled = NO;
                _sponsorCameraRollButton.hidden = YES;
                _sponsorCameraRollButton.enabled = NO;
            } else {
                _playerTextField.hidden = YES;
                _playerTextField.enabled = NO;
                _sponsorCameraButton.hidden = NO;
                _sponsorCameraButton.enabled = YES;
                _sponsorCameraRollButton.hidden = NO;
                _sponsorCameraRollButton.enabled = YES;
                
                if ((_sponsorImage.image.CIImage == nil) && (_sponsorImage.image.CGImage == nil))
                    _sponsorImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
            }
                        
            if ((_bannerImage.image.CIImage == nil) && (_bannerImage.image.CGImage == nil) && (!bannermedia))  {
                _bannerlogoImage.image = [currentSettings.team getImage:@"tiny"];
                _bannerlogoTitleLabel.text = [NSString stringWithFormat:@"%@ Proud Sponsor", currentSettings.team.mascot];
                _bannerlogoMessageLabel.text = @"Sponsor's message appears here!";
                UIAlertView *alert;
                
                if (adproduct.playerad) {
                    alert = [[UIAlertView alloc] initWithTitle:@"Player Ad"
                                message:@"Enter your sponsor information. Player ads only require sponsor name or message. Contact informatio is not required." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                } else {
                    alert = [[UIAlertView alloc] initWithTitle:@"Team Ad"
                                        message:@"Enter your sponsor information. Make sure to enter contact information so we can map your business!"
                                                      delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                }
                
                [alert show];
            } else if (bannermedia) {
                _bannerlogoImage.hidden = YES;
                _bannerlogoMessageLabel.hidden = YES;
                _bannerlogoTitleLabel.hidden = YES;
            }
        }
    }
}

- (IBAction)cameraRollButtonClicked:(id)sender {
    if (sender == _bannerCameraRollButton)
        bannermedia = YES;
    else
        bannermedia = NO;
    
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
        }
        
        newmedia = NO;
    }
}

- (IBAction)cameraButtonClicked:(id)sender {
    if (sender == _bannerCameraButton)
        bannermedia = YES;
    else
        bannermedia = NO;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"]) {
            newmedia = YES;
            UIPopoverController *apopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            apopover.delegate = self;
            
            // set contentsize
            [apopover setPopoverContentSize:CGSizeMake(220,300)];
            
            [apopover presentPopoverFromRect:CGRectMake(700,1000,10,10) inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popover = apopover;
        } else {
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
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
        NSLog(@"%lu", (unsigned long)[imgData length]);
        UIImage *image = [[UIImage alloc] initWithData:imgData];
        
        if (newmedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        
        if (bannermedia) {
            _bannerImage.image = image;
            bannerimageselected = YES;
            _bannerlogoMessageLabel.hidden = YES;
            _bannerlogoTitleLabel.hidden = YES;
            _bannerlogoImage.hidden = YES;
        } else {
            _sponsorImage.image = image;
            sponsorimageselected = YES;
        }
        
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
    bannermedia = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButtonClicked:(id)sender {
    CGImageRef cgref = [_sponsorImage.image CGImage];
    CIImage *cim = [_sponsorImage.image CIImage];

    if (_sponsorName.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sponsor must have a name or message!"
                                                delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (sponsor) {
        if ((cgref == NULL) && (cim == nil) && (!player)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sponsor must have an image!"
                                                           delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            return;
        }
        
        if ((_sponsorurl.text.length == 0) && (!player)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sponsor must have a url for your fans to click!"
                                                           delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            return;
        }
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
    
    if (adinventory.sportadinvid.length > 0)
        sponsor.sportadinv_id = adinventory.sportadinvid;
    else if (adproduct.ios_client_ad_id.length > 0)
        sponsor.ios_client_ad = adproduct.ios_client_ad_id;
    
    if (player) {
        sponsor.athlete_id = player.athleteid;
        sponsor.playerad = YES;
    } else {
        sponsor.athlete_id = @"";
        sponsor.playerad = NO;
    }
    
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
    } else if ([title isEqualToString:@"Select"]) {
        [self performSegueWithIdentifier:@"SelectSitesSegue" sender:self];
    }
}

- (void)sponsorSaved:(NSNotification *)notification {
    if ([[[notification userInfo] valueForKey:@"Result"] isEqualToString:@"Success"]) {
        if (sponsorimageselected) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [_activityIndicator startAnimating];
            // Upload image data.  Remember to set the content type.
            //    imagepath = [NSString stringWithFormat:@"%@%@%@", [[currentSettings getBucket] name], @"/uploads/sponsorsphotos/", athlete.athleteid];
            NSString *photopath = [NSString stringWithFormat:@"%@%@%@%@_sponsorimage", @"uploads/sponsorsphotos/",
                                   sponsor.sponsorid, @"/", sponsor.name];
            S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:photopath inBucket:[[currentSettings getBucket] name]];
            por.contentType = @"image/jpeg";
            
            //    UIImage *image = [currentSettings normalizedImage:_playerImage.image scaledToSize:512];
            NSData *imageData = UIImageJPEGRepresentation(_sponsorImage.image, 1.0);
            
            NSLog(@"%d", imageData.length);
            
            por.data = imageData;
            por.delegate = self;
            
            // Put the image data into the specified s3 bucket and object.
            [[currentSettings getS3] putObject:por];
        } else if (bannerimageselected) {
            [self uploadBannerImage];
        } else {
            if (adproduct)
                currentSettings.purchaseController.sponsor = sponsor;
            
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/sponsors/", sponsor.sponsorid, @"/updatephoto.json?auth_token=",
                                       currentSettings.user.authtoken]];;
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* urlresponse;
    NSError *error = nil;
    NSMutableDictionary *athDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"image/jpeg",  @"filetype", nil];
    
    if (sponsorimageselected) {
        [athDict setValue:@"sponsorimage" forKey:@"sponsorimage"];
        [athDict setValue:[NSString stringWithFormat:@"%@%@%@%@_sponsorimage", @"uploads/sponsorsphotos/", sponsor.sponsorid, @"/", sponsor.name]
                   forKey:@"filepath"];
        [athDict setValue:[NSString stringWithFormat:@"%@_sponsorimage", sponsor.name] forKey:@"filename"];
        sponsorimageselected = NO;
    } else if (bannerimageselected) {
        [athDict setValue:@"sponsorbanner" forKey:@"sponsorimage"];
        [athDict setValue:[NSString stringWithFormat:@"%@%@%@%@_sponsorbanner", @"uploads/sponsorsphotos/", sponsor.sponsorid, @"/", sponsor.name]
                   forKey:@"filepath"];
        [athDict setValue:[NSString stringWithFormat:@"%@_sponsorbanner", sponsor.name] forKey:@"filename"];
        bannerimageselected = NO;
    }
    
    //    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:athDict, @"athlete", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:athDict options:0 error:&error];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPMethod:@"PUT"];
    [urlrequest setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&error];
    int responseStatusCode = [(NSHTTPURLResponse*)urlresponse statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *athdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        if (bannerimageselected)
            [self uploadBannerImage];
        else {
            if (adproduct)
                currentSettings.purchaseController.sponsor = sponsor;
            
            [self.navigationController popViewControllerAnimated:YES];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _countryTextField) {
        _countryPicker.hidden = NO;
        countryPick = YES;
        statePicker = NO;
        _adInventoryTextField = NO;
        [textField resignFirstResponder];
        [_countryPicker reloadAllComponents];
    } else if (textField == _state) {
        _countryPicker.hidden = NO;
        statePicker = YES;
        countryPick = NO;
        adInventoryPicker = NO;
        [textField resignFirstResponder];
        [_countryPicker reloadAllComponents];
    } else if (textField == _adInventoryTextField) {
        _countryPicker.hidden = NO;
        adInventoryPicker = YES;
        statePicker = NO;
        countryPick = NO;
        [textField resignFirstResponder];
        [_countryPicker reloadAllComponents];
    }
}

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if (statePicker)
        return stateList.count;
    else if (adInventoryPicker)
        return currentSettings.inventorylist.inventorylist.count;
    else
        return countryarray.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (statePicker) {
        return [stateList objectAtIndex:row];
    } else if (adInventoryPicker) {
        Sportadinv *adinv = [currentSettings.inventorylist.inventorylist objectAtIndex:row];
        return [NSString stringWithFormat:@"%@ - $%.02f", adinv.adlevelname, adinv.price];
    } else {
        NSDictionary *subDict = [countryarray objectAtIndex:row];
        return [subDict objectForKey:@"name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (statePicker) {
        _state.text = [stateDictionary objectForKey:[stateList objectAtIndex:row]];
    } else if (adInventoryPicker) {
        Sportadinv *adinv = [currentSettings.inventorylist.inventorylist objectAtIndex:row];
        _adInventoryTextField.text = [NSString stringWithFormat:@"%@ - $%.02f", adinv.adlevelname, adinv.price];
        adinventory = [currentSettings.inventorylist.inventorylist objectAtIndex:row];
    } else {
        NSDictionary *subDict = [countryarray objectAtIndex:row];
        _countryTextField.text = [subDict objectForKey:@"name"];
        country = [subDict objectForKey:@"name"];
    }
    
    _countryPicker.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (adproduct) {
        currentSettings.purchaseController.sponsor = sponsor;
    }
}

- (void)uploadBannerImage {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_activityIndicator startAnimating];
    // Upload image data.  Remember to set the content type.
    //    imagepath = [NSString stringWithFormat:@"%@%@%@", [[currentSettings getBucket] name], @"/uploads/sponsorsphotos/", athlete.athleteid];
    NSString *photopath = [NSString stringWithFormat:@"%@%@%@%@_sponsorbanner", @"uploads/sponsorsphotos/",
                           sponsor.sponsorid, @"/", sponsor.name];
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:photopath inBucket:[[currentSettings getBucket] name]];
    por.contentType = @"image/jpeg";
    
    //    UIImage *image = [currentSettings normalizedImage:_playerImage.image scaledToSize:512];
    NSData *imageData = UIImageJPEGRepresentation(_bannerImage.image, 1.0);
    
    NSLog(@"%d", imageData.length);
    
    por.data = imageData;
    por.delegate = self;
    
    // Put the image data into the specified s3 bucket and object.
    [[currentSettings getS3] putObject:por];
}

@end
