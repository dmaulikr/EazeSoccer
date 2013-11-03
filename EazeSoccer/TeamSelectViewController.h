//
//  TeamSelectViewController.h
//  Basketball Console
//
//  Created by Gil on 10/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sport.h"
#import "Team.h"

@interface TeamSelectViewController : UIViewController

@property(nonatomic, strong) Sport *sport;
@property(nonatomic, strong)  Team *team;

@property (weak, nonatomic) IBOutlet UITableView *teamTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editSportButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTeamButton;

@end
