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

@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *periodoneCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *periodtwoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *periodthreeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *periodfourCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *overtimeCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *shottypeSegmentControl;
- (IBAction)addButonClicked:(id)sender;
- (IBAction)shottypeSegmentClicked:(id)sender;

- (IBAction)periodSegmentClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *shotsNavBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *shotsNavigationItem;
@property (weak, nonatomic) IBOutlet UIImageView *saveImage;
@end
