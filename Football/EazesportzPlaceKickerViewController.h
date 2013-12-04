//
//  EazesportzPlaceKickerViewController.h
//  EazeSportz
//
//  Created by Gil on 11/30/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzPlaceKickerViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgaLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgmLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockedLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *xpaLabel;
@property (weak, nonatomic) IBOutlet UILabel *xpmLabel;
@property (weak, nonatomic) IBOutlet UILabel *xpblockedLabel;
- (IBAction)fgaButtonClicked:(id)sender;
- (IBAction)fgmButtonClicked:(id)sender;
- (IBAction)fgblockedButtonClicked:(id)sender;
- (IBAction)xpaButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *xpmButtonClicked;
- (IBAction)xpblockedButtonClicked:(id)sender;
- (IBAction)xpmButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *fgyardsTextField;
@property (weak, nonatomic) IBOutlet UILabel *fgyardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
@property (weak, nonatomic) IBOutlet UITextField *quarterTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeofscoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalsButton;
@end
