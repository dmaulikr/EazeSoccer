//
//  VideoInfoViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/7/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Video.h"
#import "GameScheduleViewController.h"

@interface VideoInfoViewController : UIViewController

@property(nonatomic, strong) Video *video;
@property(nonatomic, strong) UIPopoverController *popover;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *gameSelectContainer;
@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UITextField *videoNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UITextView *videoDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *teamTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameTextField;
@property (weak, nonatomic) IBOutlet UIButton *teamButton;

@property (weak, nonatomic) IBOutlet UIButton *gameButton;

@property (weak, nonatomic) IBOutlet UITableView *playerTableView;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cameraRollButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)playerButtonClicked:(id)sender;
- (IBAction)playButtonClicked:(id)sender;

- (IBAction)gameSelected:(UIStoryboardSegue *)segue;

- (IBAction)playerSelected:(UIStoryboardSegue *)segue;

@property(nonatomic, strong) GameScheduleViewController *gameController;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)textFieldDidBeginEditing:(UITextField *)textField;

@end
