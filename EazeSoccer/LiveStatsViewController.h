//
//  LiveStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveStatsViewController : UIViewController

- (IBAction)clockButtonClicked:(id)sender;
- (IBAction)gameButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clockButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gameButton;

@property (weak, nonatomic) IBOutlet UIView *soccerContainer;
@property (weak, nonatomic) IBOutlet UIView *gameContainer;

- (IBAction)selectGameLiveStats:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIView *soccerClockContainer;
-(IBAction)soccerClockClose:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)changeteamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveButtonClicked:(id)sender;
@end
