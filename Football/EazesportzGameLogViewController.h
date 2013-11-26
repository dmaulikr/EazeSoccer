//
//  EazesportzGameLogViewController.h
//  EazeSportz
//
//  Created by Gil on 11/25/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzGameLogViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITableView *gamelogTableView;
@end
