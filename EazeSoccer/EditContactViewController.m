//
//  EditContactViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EditContactViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"

#import <QuartzCore/QuartzCore.h>

@interface EditContactViewController () <UIAlertViewDelegate>

@end

@implementation EditContactViewController {
    BOOL newcontact;
}

@synthesize contact;

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
    else
        self.view.backgroundColor = [UIColor whiteColor];
    
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _faxTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _deleteButton.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (contact) {
        _contacttitleTextField.text = contact.title;
        _contactnameTextField.text = contact.name;
        _phoneTextField.text = contact.phone;
        _mobileTextField.text = contact.mobile;
        _faxTextField.text = contact.fax;
        _emailTextField.text = contact.email;
        newcontact = NO;
    } else {
        contact = [[Contact alloc] init];
        newcontact = YES;
    }
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Confirm Delete"
                          message: @"Click Confirm Delete Button to Delete Contact?"
                          delegate: self
                          cancelButtonTitle:@"Confirm"
                          otherButtonTitles:@"Cancel", nil];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    NSURL *aurl;
    
    if (newcontact)
        aurl = [NSURL URLWithString:[sportzServerInit getContacts:currentSettings.user.authtoken]];
    else
        aurl = [NSURL URLWithString:[sportzServerInit getContact:contact.contactid Token:currentSettings.user.authtoken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180];
    NSError *jsonSerializationError = nil;
    
    NSMutableDictionary *teamDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_contacttitleTextField text], @"title",
                                     [_contactnameTextField text], @"name", _phoneTextField.text, @"phone", _mobileTextField.text, @"mobile",
                                     _faxTextField.text , @"fax", _emailTextField.text, @"email", nil];
        
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:teamDict, @"contact", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (jsonSerializationError) {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (newcontact)
        [request setHTTPMethod:@"POST"];
    else
        [request setHTTPMethod:@"PUT"];
    
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *contactData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    if ([httpResponse statusCode] == 200) {
        contact = [[Contact alloc] initWithDirectory:contactData];
        contact.contactid = [contactData objectForKey:@"_id"];
        
        if (newcontact)
            newcontact = NO;
        
        [self.navigationController popViewControllerAnimated:YES];
     } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating contact"
                                                        message:[contactData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        
        if (![contact initDeleteContact]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Contact" message:[contact httperror]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
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
