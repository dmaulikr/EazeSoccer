//
//  EazeLoginViewController.m
//  EazeSportz
//
//  Created by Gil on 1/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeLoginViewController.h"
#import "EazesportzAppDelegate.h"
#import "KeychainWrapper.h"
#import "sportzConstants.h"
#import "EazesportzLogin.h"
#import "EazesportzRetrieveSport.h"
#import "sportzteamsRegisterLoginViewController.h"
#import "EazesportzRetrieveAlerts.h"

#import <QuartzCore/QuartzCore.h>

@interface EazeLoginViewController ()

@end

@implementation EazeLoginViewController

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
    
    _loginMessageLabel.layer.cornerRadius = 6;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:@"LoginNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _loginMessageLabel.numberOfLines = 0;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([KeychainWrapper searchKeychainCopyMatchingIdentifier:GOMOBIEMAIL] != nil) {  // Use keychain email and password
        [self login:[KeychainWrapper keychainStringFromMatchingIdentifier:GOMOBIEMAIL]
           Password:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED]];
    }
    else {        // clear the email and password so user can log in
        _emailTextField.text = @"";
        _passwordTextField.text = @"";
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    // do not forget to unsubscribe the observer, or you may experience crashes towards a deallocated observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        if (currentSettings.team.teamid.length > 0) {
            [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid
                                                            Token:currentSettings.user.authtoken];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) login:(NSString *)myemail Password:(NSString *)mypassword {
    [[[EazesportzLogin alloc] init] Login:myemail Password:mypassword Site:currentSettings.sport.id];
}

- (IBAction)loginButtonClicked:(id)sender {
    if ((_emailTextField.text.length > 0) && (_passwordTextField.text.length > 0))
        [self login:_emailTextField.text Password:_passwordTextField.text];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login"
                                                        message:@"Email and Password fields must be not be blank!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)registerButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"RegisterLoginSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RegisterLoginSegue"]) {
        sportzteamsRegisterLoginViewController *destController = segue.destinationViewController;
        destController.sport = currentSettings.sport;
        destController.admin = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
