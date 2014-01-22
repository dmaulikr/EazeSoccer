//
//  ChangeTeamViewController.h
//  Basketball Console
//
//  Created by Gilbert Zaldivar on 9/16/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
- (IBAction)logoutButtonClicked:(id)sender;
- (IBAction)changeTeamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
- (IBAction)profileButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)siteButtonClicked:(id)sender;
@end
