//
//  EazNewsViewController.h
//  EazeSportz
//
//  Created by Gil on 1/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazeNewsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *teamPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)teamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *contactsButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
@end
