//
//  EazesportzVisitingTeamRosterViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VisitingTeam.h"

@interface EazesportzVisitingTeamRosterViewController : UIViewController

@property (nonatomic, strong) VisitingTeam *visitingTeam;

@property (weak, nonatomic) IBOutlet UITableView *rosterTableView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;
@end
