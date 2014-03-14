//
//  EazeStartEndDateViewController.h
//  EazeSportz
//
//  Created by Gil on 3/14/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazeStartEndDateViewController : UIViewController

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)valueChanged:(id)sender;
@end
