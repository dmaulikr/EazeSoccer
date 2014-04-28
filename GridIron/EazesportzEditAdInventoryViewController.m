//
//  EazesportzEditAdInventoryViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/26/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzEditAdInventoryViewController.h"
#import "EazesportzAppDelegate.h"
#import "PlayerSelectionViewController.h"

@interface EazesportzEditAdInventoryViewController ()

@end

@implementation EazesportzEditAdInventoryViewController {
    PlayerSelectionViewController *playerController;
}

@synthesize adInventory;

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
    _priceTextField.keyboardType = UIKeyboardTypeNumberPad;

    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.saveBarButton, self.deleteBarButton, nil];
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _adlevelnameTextField.text = adInventory.adlevelname;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    _expirationTextField.text = [dateFormat stringFromDate:adInventory.expiration];
    _priceTextField.text = [NSString stringWithFormat:@"$%.02f", adInventory.price];
    [_forsaleSwitch setOn:adInventory.forsale];
    _expirationDatePicker.hidden = YES;
    _expirationDatePicker.enabled = NO;
    _selectDateButton.enabled = NO;
    _selectDateButton.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _expirationTextField) {
        [textField resignFirstResponder];
        _expirationDatePicker.hidden = NO;
        _selectDateButton.hidden = NO;
        _selectDateButton.enabled = YES;
    } else if (textField == _playerTextField) {
        [textField resignFirstResponder];
        _playerContainer.hidden = NO;
        playerController.player = nil;
        textField.text = @"";
        [playerController viewWillAppear:YES];
    }
}

- (IBAction)deleteBarButtonClicked:(id)sender {
    if ([adInventory deleteSportadinv:currentSettings.user]) {
        [currentSettings.inventorylist retrieveSportadinv:currentSettings.sport User:currentSettings.user];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Ad inventory delete failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)saveBarButtonClicked:(id)sender {
    if ([adInventory saveSportadinv:currentSettings.sport User:currentSettings.user]) {
        adInventory.price = [_priceTextField.text floatValue];
        adInventory.adlevelname = _adlevelnameTextField.text;
        adInventory.forsale = _forsaleSwitch.isOn;
        adInventory.sportid = currentSettings.sport.id;
        [currentSettings.inventorylist retrieveSportadinv:currentSettings.sport User:currentSettings.user];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:adInventory.httperror delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)selectDateButtonClicked:(id)sender {
    adInventory.expiration = [_expirationDatePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    _expirationTextField.text = [formatter stringFromDate:adInventory.expiration];
    _expirationDatePicker.hidden = YES;
    _expirationDatePicker.enabled = NO;
    _selectDateButton.hidden = YES;
    _selectDateButton.enabled = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _priceTextField) {
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    _playerContainer.hidden = YES;
    
    if (playerController.player) {
        _playerTextField.text = playerController.player.numberLogname;
        adInventory.athlete_id = playerController.player.athleteid;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerController = segue.destinationViewController;
    }
}

@end
