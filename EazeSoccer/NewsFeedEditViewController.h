//
//  NewsFeedEditViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Newsfeed.h"

@interface NewsFeedEditViewController : UIViewController

@property(nonatomic, strong) Newsfeed *newsitem;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UITextField *newsTitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *newsFeedImageView;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;
@property (weak, nonatomic) IBOutlet UITextField *gameTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerTextField;
@property (weak, nonatomic) IBOutlet UITextField *coachTextField;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)playerButtonClicked:(id)sender;
- (IBAction)gameButtonClicked:(id)sender;
- (IBAction)coachButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;

- (IBAction)newsfeedPlayerSelected:(UIStoryboardSegue *)segue;

- (IBAction)playerSelected:(UIStoryboardSegue *)segue;

- (IBAction)newsfeedCoachSelected:(UIStoryboardSegue *)segue;

- (IBAction)newsfeedGameSelected:(UIStoryboardSegue *)segue;

- (IBAction)gameSelected:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *playerSelectionContainer;
@property (weak, nonatomic) IBOutlet UIView *coachSelectionContainer;
@property (weak, nonatomic) IBOutlet UIView *gameSelectionContainer;
@property (weak, nonatomic) IBOutlet UIButton *coachButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;

@end
