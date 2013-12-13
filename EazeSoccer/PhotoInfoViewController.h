//
//  PhotoInfoViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Photo.h"
#import "GameScheduleViewController.h"


@interface PhotoInfoViewController : UIViewController

@property(nonatomic, strong) Photo *photo;
@property(nonatomic, strong) UIPopoverController *popover;

@property (weak, nonatomic) IBOutlet UIButton *teamButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;

@property (weak, nonatomic) IBOutlet UIView *gameSelectContainer;

- (IBAction)playerSelected:(UIStoryboardSegue *)segue;
- (IBAction)gameSelected:(UIStoryboardSegue *)segue;

//- (IBAction)selectPhotoGamePlayEdit:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UITextField *photonameTextField;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UITextField *teamTextField;
- (IBAction)teamButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *gameTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *playerTableView;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)tagPlayersButtonClicked:(id)sender;

- (IBAction)cameraRollButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
- (IBAction)cameraButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@property(nonatomic, strong) GameScheduleViewController *gameController;

@end
