//
//  SearchForUserViewController.m
//  EazeSportz
//
//  Created by Gil on 11/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "SearchForUserViewController.h"

@interface SearchForUserViewController ()

@end

@implementation SearchForUserViewController {
    UITextField *atextField;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _emailTextField.text = @"";
    _usernameTextField.text = @"";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [atextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    atextField = textField;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [atextField resignFirstResponder];
}

@end
