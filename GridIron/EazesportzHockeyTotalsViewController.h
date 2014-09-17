//
//  EazesportzHockeyTotalsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface EazesportzHockeyTotalsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) Athlete *player;

@property (weak, nonatomic) IBOutlet UICollectionView *totalsCollectionView;
@end
