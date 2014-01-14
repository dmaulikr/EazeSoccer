//
//  LiveStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface LiveStatsViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clockButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (weak, nonatomic) IBOutlet UIView *soccerContainer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)changeteamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveButtonClicked:(id)sender;
@end
