//
//  EazesportzBasketballScoreSheetViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzBasketballScoreSheetViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITableView *scoreSheetTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *otherBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@end
