//
//  EditBasketballGameViewController.h
//  Basketball Console
//
//  Created by Gilbert Zaldivar on 9/13/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EditGameViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *opponentTextField;
@property (weak, nonatomic) IBOutlet UITextField *mascotTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeawayTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectDateButton;
- (IBAction)selectDateButtonClicked:(id)sender;
- (IBAction)scoreButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *homeScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;
@property (weak, nonatomic) IBOutlet UILabel *homescoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *leagueSwitch;
- (IBAction)searchEazesportzButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *findsiteContainer;
@property (weak, nonatomic) IBOutlet UIView *findTeamContainer;

- (IBAction)findsiteSelected:(UIStoryboardSegue *)segue;
- (IBAction)findteamSelected:(UIStoryboardSegue *)segue;

@end
