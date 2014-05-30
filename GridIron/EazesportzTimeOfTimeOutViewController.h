//
//  EazesportzTimeOfTimeOutViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/28/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzTimeOfTimeOutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;

@property (nonatomic, strong) NSNumber *period;
@property (nonatomic, assign) int half;
@property (nonatomic, strong) GameSchedule *game;

- (IBAction)submitButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@end
