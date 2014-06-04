//
//  EazesportzLacrosseShotsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/1/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"
#import "VisitorRoster.h"

@interface EazesportzLacrosseShotsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) Athlete *player;
@property (nonatomic, strong) VisitorRoster *visitingPlayer;

@property (weak, nonatomic) IBOutlet UITextField *shotTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *shotTableView;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
- (IBAction)saveButtonClicked:(id)sender;

@end
