//
//  EditTeamViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/8/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Team.h"

@interface EditTeamViewController : UIViewController

@property(nonatomic, strong) Team *team;

@property(nonatomic, strong) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *teamlogoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *teamImage;
@property (weak, nonatomic) IBOutlet UITextField *teamnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mascotTextField;
@property (weak, nonatomic) IBOutlet UIButton *camerarollButton;
- (IBAction)camerarollButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)useSportMascotButtonClicked:(id)sender;

@end
