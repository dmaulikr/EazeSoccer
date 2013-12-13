//
//  BlogEntryViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/10/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Blog.h"
#import "GameScheduleViewController.h"

@interface BlogEntryViewController : UIViewController

@property(nonatomic, strong) Blog *blog;

@property (weak, nonatomic) IBOutlet UITextField *blogTitleText;
@property (weak, nonatomic) IBOutlet UITextView *blogentryTextView;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIImageView *bloggerImage;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)deleteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tagPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *tagGameButton;
@property (weak, nonatomic) IBOutlet UIButton *tagCoachButton;
@property (weak, nonatomic) IBOutlet UIView *playerContainer;
@property (weak, nonatomic) IBOutlet UIView *coachContainer;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *gameContainer;

@property (weak, nonatomic) IBOutlet UITextField *gameTextField;
@property (weak, nonatomic) IBOutlet UITextField *coachTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerTextField;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@property(nonatomic, strong) GameScheduleViewController *gameSelectionController;

- (IBAction)playerSelected:(UIStoryboardSegue *)segue;
- (IBAction)gameSelected:(UIStoryboardSegue *)segue;
- (IBAction)coachSelected:(UIStoryboardSegue *)segue;

@end
