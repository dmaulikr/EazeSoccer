//
//  gomobisportsLoginViewController.m
//  smpwlions
//
//  Created by Gil on 3/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "LoginViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "sportzConstants.h"
#import "KeychainWrapper.h"
#import "sportzteamsRegisterLoginViewController.h"
#import "ProgramInfoViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface LoginViewController () <UIAlertViewDelegate>

@end


@implementation LoginViewController {
    NSDictionary *token;
    NSMutableData *theData;
    int responseStatusCode;
}

@synthesize email;
@synthesize password;

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
    self.view.backgroundColor = [UIColor clearColor];
    _emailLabel.layer.cornerRadius = 4;
    _passwordLabel.layer.cornerRadius = 4;
    email.keyboardType = UIKeyboardTypeEmailAddress;
//    self.title = [NSString stringWithFormat:@"Login"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ((currentSettings.teams.count == 0) && (currentSettings.user.email.length > 0))
        [self performSegueWithIdentifier:@"AlreadyLoggedInSegue" sender:self];
    else if ([currentSettings.user.email length] > 0) {     // User still logged in, present teams view
        [self performSegueWithIdentifier:@"AlreadyLoggedInSegue" sender:self];        
    } else if ([KeychainWrapper searchKeychainCopyMatchingIdentifier:GOMOBIEMAIL] != nil) {  // Use keychain email and password
        [self login:[KeychainWrapper keychainStringFromMatchingIdentifier:GOMOBIEMAIL]
              Password:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED]];
    }
    else {        // clear the email and password so user can log in
        [email setText:@""];
        [password setText:@""];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClicked:(id)sender {
    if (([[email text] length] > 0) && ([[password text] length] > 0)) {
        [self login:[email text] Password:[password text]];
    } else {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email or Password cannot be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorView show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        UITextField *siteStateText = (UITextField *)[self.view viewWithTag:2];
        [siteStateText becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) login:(NSString *)myemail Password:(NSString *)mypassword {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *sport = [mainBundle objectForInfoDictionaryKey:@"sportzteams"];
    sportzServerInit *serverInit = [sportzServerInit alloc];
    NSURL *url = [NSURL URLWithString:[serverInit getLoginRequest]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:myemail, @"email",mypassword, @"password", sport, @"sport", nil];
    
    NSError *jsonSerializationError = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:userDict, @"user", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:nil error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
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
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download could not complete - please make sure you're connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    token = [NSJSONSerialization JSONObjectWithData:theData options:nil error:nil];
    
    if (responseStatusCode == 200) {
        NSUInteger passHash = [password hash];
        if ([password.text length] > 0) {
            if ([KeychainWrapper createKeychainValue:[password text] forIdentifier:PIN_SAVED]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"** password saved successfully to Keychain!!");
            }
        }
        NSDictionary *userdata = [token objectForKey:@"user"];
        NSLog(@"%@", userdata);
        if([userdata count] > 0) {
            currentSettings.user.email = [userdata objectForKey:@"email"];
            if ([KeychainWrapper createKeychainValue:currentSettings.user.email forIdentifier:GOMOBIEMAIL]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GOMOBIEMAIL];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"** email saved successfully to Keychain!!");           
            }
            
            currentSettings.user.authtoken = [token objectForKey:@"authentication_token"];
            NSURL *url = [NSURL URLWithString:[sportzServerInit getUser:[userdata objectForKey:@"_id"] Token:currentSettings.user.authtoken]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            NSURLResponse* response;
            NSError *error = nil;
            NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
            responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            
            if (responseStatusCode == 200) {
                currentSettings.user.email = [userdata objectForKey:@"email"];
                currentSettings.user.admin = [NSNumber numberWithInteger:[[userdata objectForKey:@"admin"] integerValue]];
                currentSettings.user.userid = [userdata objectForKey:@"id"];
                currentSettings.user.username = [userdata objectForKey:@"name"];
                currentSettings.user.avatarprocessing = [[userdata objectForKey:@"avatarprocessing"] boolValue];
                
                if ((NSNull *)[userdata objectForKey:@"avatarthumburl"] != [NSNull null])
                    currentSettings.user.userthumb = [userdata objectForKey:@"avatarthumburl"];
                else
                    currentSettings.user.userthumb = @"";
                
                if ((NSNull *)[userdata objectForKey:@"avatartinyurl"] != [NSNull null])
                    currentSettings.user.tiny = [userdata objectForKey:@"avatartinyurl"];
                else
                    currentSettings.user.tiny = @"";
                
                currentSettings.user.isactive = [NSNumber numberWithInteger:[[userdata objectForKey:@"is_active"] integerValue]];
                currentSettings.user.bio_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"bio_alert"] integerValue]];
                currentSettings.user.blog_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"blog_alert"] integerValue]];
                currentSettings.user.media_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"media_alert"] integerValue]];
                currentSettings.user.stat_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"stat_alert"] integerValue]];
                currentSettings.user.score_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"score_alert"] integerValue]];
                currentSettings.user.teammanagerid = [userdata objectForKey:@"teamid"];
                currentSettings.user.awssecretkey = [userdata objectForKey:@"awskey"];
                currentSettings.user.awskeyid = [userdata objectForKey:@"awskeyid"];
                currentSettings.user.tier = [userdata objectForKey:@"tier"];
                
                if ((NSNull *)[userdata objectForKey:@"default_site"] != [NSNull null]) 
                    currentSettings.sport.id = [userdata objectForKey:@"default_site"];
                else
                    currentSettings.sport.id = @"";
                
                NSBundle *mainBundle = [NSBundle mainBundle];
                
 //               if ([currentSettings.user.admin intValue] > 0) {
                    
                    if (![currentSettings initS3Bucket]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Storage Access Issue. Please restart app!"
                                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert setAlertViewStyle:UIAlertViewStyleDefault];
                        [alert show];
                    }
                    
                    if (currentSettings.sport.id.length > 0) {
                        [currentSettings retrieveSport];
                        
                        if ((![currentSettings.sport.name isEqualToString:[mainBundle objectForInfoDictionaryKey:@"sportzteams"]])
                        && ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Sport does not match login"
                                                 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alert setAlertViewStyle:UIAlertViewStyleDefault];
                            [alert show];
                        } else if ((![currentSettings.sport.name isEqualToString:[mainBundle objectForInfoDictionaryKey:@"sportzteams"]]) &&
                                   ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) &&
                                   (currentSettings.user.admin)) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login"
                                                 message:@"Admin user cannot be used to view other sports"
                                                 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alert setAlertViewStyle:UIAlertViewStyleDefault];
                            [alert show];
                        } else  {
                            [self performSegueWithIdentifier:@"AlreadyLoggedInSegue" sender:self];
                        }
                    } else if (([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"]) &&
                               ([currentSettings.user.admin intValue] > 0)) {
                        [self performSegueWithIdentifier:@"CreateSportSegue" sender:self];
                    } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must be an administrator to use this application"
                                                                  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        [alert setAlertViewStyle:UIAlertViewStyleDefault];
                        [alert show];
                    }
//                } else {
//                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User"
                                                                message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                               delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }

        } else {
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:PIN_SAVED];
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:GOMOBIEMAIL];
            currentSettings.user.email = @"";
            currentSettings.user.authtoken = @"";
            currentSettings.user.username = @"";
            currentSettings.user.userid = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Please activate your account using the email sent when you registered"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else  {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:[token objectForKey:@"message"]
                                                  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        
        if (responseStatusCode == 401) {
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:GOMOBIEMAIL];
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:PIN_SAVED];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Register?"]) {
        [self performSegueWithIdentifier: @"CreateLoginSegue" sender: self];
    }
}

- (IBAction)registerButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"RegisterUserSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RegisterUserSegue"]) {
        sportzteamsRegisterLoginViewController *destController = segue.destinationViewController;
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        if ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
            destController.admin = NO;
        else
            destController.admin = YES;
        
        destController.sport = nil;
    } else if ([segue.identifier isEqualToString:@"CreateSportSegue"]) {
        ProgramInfoViewController *destController = segue.destinationViewController;
        destController.sport = nil;
    }
}
@end
