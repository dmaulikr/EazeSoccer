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
#import "EazesportzRetrieveSport.h"
#import "EazesportzLogin.h"

#import <QuartzCore/QuartzCore.h>

@interface LoginViewController () <UIAlertViewDelegate>

@end


@implementation LoginViewController {
    NSDictionary *token;
    NSMutableData *theData;
    int responseStatusCode;
    
    NSMutableURLRequest *originalRequest;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:@"LoginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSportData:) name:@"SportChangedNotification" object:nil];
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

- (void)viewDidDisappear:(BOOL)animated {
    // do not forget to unsubscribe the observer, or you may experience crashes towards a deallocated observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)loginResult:(NSNotification *)notification {
    NSDictionary *result = [notification userInfo];
    if (![[result valueForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[result valueForKey:@"Result"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        if (![currentSettings initS3Bucket]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Storage Access Issue. Please restart app!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        if ((currentSettings.user.default_site.length > 0) && (currentSettings.user.admin)) {
            [[[EazesportzRetrieveSport alloc] init] retrieveSport:currentSettings.user.default_site Token:currentSettings.user.authtoken];
        } else if (currentSettings.user.admin) {
            [self performSegueWithIdentifier:@"CreateSportSegue" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must be an administrator to use this application"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void) login:(NSString *)myemail Password:(NSString *)mypassword {
    [[[EazesportzLogin alloc] init] Login:myemail Password:mypassword];
}

- (void)gotSportData:(NSNotification *)notification {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
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
