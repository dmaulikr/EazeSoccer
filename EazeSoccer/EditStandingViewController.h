//
//  EditStandingViewController.h
//  Basketball Console
//
//  Created by Gil on 10/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Standings.h"

@interface EditStandingViewController : UIViewController

@property(nonatomic, strong) Standings *standing;

@property (weak, nonatomic) IBOutlet UIImageView *teamImage;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *leagueWinsTextField;
@property (weak, nonatomic) IBOutlet UITextField *leagueLossesTextField;
@property (weak, nonatomic) IBOutlet UITextField *nonleagueWinsTextField;
@property (weak, nonatomic) IBOutlet UITextField *nonleagueLossesTextField;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
- (IBAction)importButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *importMessageLabel;

@end
