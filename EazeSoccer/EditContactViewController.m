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
    self.view.backgroundColor = [UIColor clearColor];
    
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _faxTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _deleteButton.layer.cornerRadius = 4;
    
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
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Confirm", nil];
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
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:nil error:&jsonSerializationError];
    
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
        contact.title = [contactData objectForKey:@"title"];
        contact.name = [contactData objectForKey:@"name"];
        contact.phone = [contactData objectForKey:@"phone"];
        contact.mobile = [contactData objectForKey:@"mobile"];
        contact.fax = [contactData objectForKey:@"fax"];
        contact.email = [contactData objectForKey:@"email"];
        
        if (newcontact)
            newcontact = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Contact Updated!"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating contact"
                                                        message:[contactData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        NSURL *url = [NSURL URLWithString:[sportzServerInit getContact:contact.contactid Token:currentSettings.user.authtoken]];
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
        int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
        NSDictionary *confirmDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        if (responseStatusCode == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Contact Delete Successful!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            contact = nil;
            _contacttitleTextField.text = @"";
            _emailTextField.text = @"";
            _contactnameTextField.text = @"";
            _mobileTextField.text = @"";
            _faxTextField.text = @"";
            _phoneTextField.text = @"";
            [self viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Contact"
                                                            message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

@end
