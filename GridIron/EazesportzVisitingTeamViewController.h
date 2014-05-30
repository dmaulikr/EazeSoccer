//
//  EazesportzVisitingTeamViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazesportzVisitingTeamViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *visitingTeamTableView;
@property (weak, nonatomic) IBOutlet UITextField *teamnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mascotTextField;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;

@end
