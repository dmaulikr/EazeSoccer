//
//  EazeStartEndDateViewController.m
//  EazeSportz
//
//  Created by Gil on 3/14/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeStartEndDateViewController.h"

@interface EazeStartEndDateViewController ()

@end

@implementation EazeStartEndDateViewController {
    BOOL begindate;
}

@synthesize startDate;
@synthesize endDate;

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
    begindate = YES;
    _startDateTextField.inputView = _datePicker.inputView;
    _endDateTextField.inputView = _datePicker.inputView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _datePicker.hidden = YES;
    _datePicker.date = [[NSDate alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueChanged:(id)sender {
    if (begindate) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy HH:mm"];
        _startDateTextField.text = [dateFormat stringFromDate:_datePicker.date];
        startDate = _datePicker.date;
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy HH:mm"];
        _endDateTextField.text = [dateFormat stringFromDate:_datePicker.date];
        endDate = _datePicker.date;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _startDateTextField) {
        begindate = YES;
    } else {
        begindate = NO;
    }
    
    _datePicker.hidden = NO;
    [textField resignFirstResponder];
}

@end
