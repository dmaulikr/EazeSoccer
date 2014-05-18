//
//  EazesportzClientNotificationViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/14/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazesportzClientNotificationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *scoreSwitch;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabelSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *athleteSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mediaSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *blogSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *teamNewsSwitch;
- (IBAction)submitButtonClicked:(id)sender;
@end
