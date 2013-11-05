//
//  LiveStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveStatsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;
- (IBAction)clockButtonClicked:(id)sender;
- (IBAction)gameButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clockButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gameButton;

@property (weak, nonatomic) IBOutlet UIView *soccerContainer;
@property (weak, nonatomic) IBOutlet UIView *gameContainer;

- (IBAction)selectGameLiveStats:(UIStoryboardSegue *)segue;

@end
