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

#import <QuartzCore/QuartzCore.h>

@interface FindSiteViewController ()

@end

@implementation FindSiteViewController {
    NSDictionary *stateDictionary;
    NSArray *serverData;
    int responseStatusCode;
    NSMutableData *theData;
    
    NSMutableArray *sportsname, *sportsvalue;
    
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
    _sportTextField.inputView = _sportPicker.inputView;
    _siteselectView.layer.cornerRadius = 6;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _stateTextField.text = @"";
    _zipcodeTextfield.text = @"";
    _sitenameTextField.text = @"";
    _zipcodeTextfield.text = @"";
    _stateListContainer.hidden = YES;
    
    _sportPicker.hidden = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                                                           @"/home.json"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    if ([(NSHTTPURLResponse*)response statusCode] == 200) {
        NSDictionary *thelist = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        sportsname = [[NSMutableArray alloc] init];
        sportsvalue = [[NSMutableArray alloc] init];
        NSArray *thesports = [thelist objectForKey:@"sports_list"];
        for (int i = 0; i < [thesports count]; i++) {
            NSArray *sportlist = [thesports objectAtIndex:i];
            [sportsname addObject:[sportlist objectAtIndex:0]];
            [sportsvalue addObject:[sportlist objectAtIndex:1]];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Retrieving Sports List" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
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
    } else if (textField == _sportTextField) {
        [_sportTextField resignFirstResponder];
        _sportPicker.hidden = NO;
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
        selectSiteController.sportname = _sportTextField.text;
    } else if ([segue.identifier isEqualToString:@"RegisterSiteLoginSegue"]) {
        sportzteamsRegisterLoginViewController *destController = segue.destinationViewController;
        destController.sport = sport;
    }
}

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    return sportsname.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [sportsname objectAtIndex:row];;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _sportTextField.text = [sportsvalue objectAtIndex:row];
    _sportPicker.hidden = YES;
}

@end
