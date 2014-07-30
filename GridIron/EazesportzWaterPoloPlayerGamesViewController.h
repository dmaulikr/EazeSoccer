//
//  EazesportzWaterPoloPlayerGamesViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "VisitorRoster.h"

@interface EazesportzWaterPoloPlayerGamesViewController : UIViewController

@property (nonatomic, strong) Athlete *player;
@property (nonatomic, strong) VisitorRoster *visitingplayer;

@property (weak, nonatomic) IBOutlet UITableView *gamestatsTableView;
@end
