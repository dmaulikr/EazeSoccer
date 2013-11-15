//
//  FindSiteViewController.m
//  Eazebasketball
//
//  Created by Gil on 9/28/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FindSiteViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzteamsRegisterLoginViewController.h"
#import "SelectStateViewController.h"
#import "SelectSiteTableViewController.h"

@interface FindSiteViewController ()

@end

@implementation FindSiteViewController {
    NSDictionary *stateDictionary;
    NSArray *serverData;
    int responseStatusCode;
    NSMutableData *theData;
    
    BOOL registerSite;
    Sport *sport;
    
    SelectStateViewController *selectStateController;
}

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
    _zipcodeTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _stateTextField.inputView = selectStateController.inputView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _stateTextField.text = @"";
    _zipcodeTextfield.text = @"";
    _sitenameTextField.text = @"";
    _zipcodeTextfield.text = @"";
    _stateListContainer.hidden = YES;
}

- (IBAction)submitButtonClicked:(id)sender {
    if ((_zipcodeTextfield.text.length > 0) || (_cityTextField.text.length > 0) || (_sitenameTextField.text.length > 0) ||
        (_stateTextField.text.length > 0)) {
        [self performSegueWithIdentifier:@"SelectSiteSegue" sender:self];
     } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter search criteria!"
                                                       delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)selectStateFindSite:(UIStoryboardSegue *)segue {
    _stateListContainer.hidden = YES;
    
    if (selectStateController.state) {
        _stateTextField.text = selectStateController.state;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _stateTextField) {
        _stateListContainer.hidden = NO;
        selectStateController.state = nil;
        _stateTextField.text = @"";
        [selectStateController viewWillAppear:YES];
        [_stateTextField resignFirstResponder];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectStateSegue"]) {
        selectStateController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"SelectSiteSegue"]) {
        SelectSiteTableViewController *selectSiteController = segue.destinationViewController;
        selectSiteController.state = selectStateController.stateabreviation;
        selectSiteController.zipcode = _zipcodeTextfield.text;
        selectSiteController.city = _cityTextField.text;
        selectSiteController.sitename = _sitenameTextField.text;
    } else if ([segue.identifier isEqualToString:@"RegisterSiteLoginSegue"]) {
        sportzteamsRegisterLoginViewController *destController = segue.destinationViewController;
        destController.sport = sport;
    }
}

@end
