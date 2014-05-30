//
//  EazesportzLacrosseScoresheetViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/27/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzLacrosseScoresheetViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UICollectionView *homeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *visitorCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *hometimeoutCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *visitortimeoutCollectionView;
@property (weak, nonatomic) IBOutlet UIView *timeoutContainer;

- (IBAction)timeoutSubmit:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *scoreEntryContainer;

- (IBAction)scoreEntryCompleted:(UIStoryboardSegue *)segue;
- (IBAction)deleteScoreEntryCompleted:(UIStoryboardSegue *)segue;

@end
