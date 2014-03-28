//
//  sportzteamsRegisterLoginViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzteamsRegisterLoginViewController.h"
#import "sportzServerInit.h"

#import <QuartzCore/QuartzCore.h>

@interface sportzteamsRegisterLoginViewController () <UIAlertViewDelegate>

@end

@implementation sportzteamsRegisterLoginViewController {
    NSDictionary *serverData;
    NSMutableData *theData;
    NSMutableArray *logindata;
    int responseStatusCode;    
}

@synthesize sport;
@synthesize admin;

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
    _siteLabel.numberOfLines = 0;
    [_siteLabel setText:sport.sitename];
    _registerView.layer.cornerRadius = 6;
    _emailText.keyboardType = UIKeyboardTypeEmailAddress;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn:");
    if (textField.tag == 0) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:1];
        [siteStateText becomeFirstResponder];
    } else if (textField.tag == 1) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:2];
        [siteStateText becomeFirstResponder];
    } else if (textField.tag == 2) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:3];
        [siteStateText becomeFirstResponder];        
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)createLoginButtonClicked:(id)sender {
    if (([[_nameText text] length] == 0) || ([[_emailText text] length] == 0) || ([[_passwordText text] length] == 0) ||
        ([[_confirmText text] length] == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                             message:[NSString stringWithFormat:@"All fields must be completed!"]
                             delegate:self cancelButtonTitle:@"Dismiss"
                             otherButtonTitles:nil, nil];        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    if (_passwordText.text.length < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"Password length must be at least eight characters!"]
                                                       delegate:self cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    if ([[_passwordText text] isEqualToString:[_confirmText text]]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURL *url = [NSURL URLWithString:[sportzServerInit registerUser]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSDictionary *loginData;
        
        NSArray* cfBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        NSDictionary* cfBundleURLTypes0 = [cfBundleURLTypes objectAtIndex:0];
        NSArray *schemearray = [cfBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
        
        if (admin)
            loginData = [[NSDictionary alloc] initWithObjectsAndKeys:[_emailText text], @"email",[_passwordText text], @"password",
                         [_nameText text], @"name", [NSString stringWithFormat:@"%d", admin], @"admin",
                         [schemearray objectAtIndex:0], @"mobile", nil];
        else
            loginData = [[NSDictionary alloc] initWithObjectsAndKeys:[_emailText text], @"email",[_passwordText text], @"password",
                        [_nameText text], @"name", sport.id, @"site", [schemearray objectAtIndex:0], @"mobile", nil];
        
        NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
        [jsonDict setValue:loginData forKey:@"user"];
        
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
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [[NSURLConnection alloc] initWithRequest:request  delegate:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"Passwords do not match!"]
                                                       delegate:self cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
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
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@", @"Welcome ", _nameText.text]
                          message:[NSString stringWithFormat:@"Email sent for you to comfirm registration."]
                          delegate:self cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else if ((responseStatusCode == 400) || (responseStatusCode == 409)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login"
                             message:[serverData objectForKey:@"message"]
                             delegate:self cancelButtonTitle:@"Try Again"
                             otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[serverData objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if([title isEqualToString:@"Ok"]) {
        if ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
            [self.navigationController popToRootViewControllerAnimated:YES];
        else
            [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)learnmoreButtonClicked:(id)sender {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlString = [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
}

@end
