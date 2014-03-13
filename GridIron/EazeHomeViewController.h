//
//  EazeHomeViewController.h
//  EazeSportz
//
//  Created by Gil on 3/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazeHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
- (IBAction)changeTeamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *teamPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *changeTeamButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
