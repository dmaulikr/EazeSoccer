//
//  EazesportzHockeyTotalsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzHockeyTotalsViewController.h"

#import "EazesportzAppDelegate.h"

#import "HeaderSelectCollectionReusableView.h"
#import "EazesportzLacrosseScoreCollectionViewCell.h"
#import "HockeyPlayerStatTotals.h"

@interface EazesportzHockeyTotalsViewController ()

@end

@implementation EazesportzHockeyTotalsViewController

@synthesize game;
@synthesize player;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = [NSString stringWithFormat:@"%@ - Totals", player.numberLogname];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 17;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return  1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EazesportzLacrosseScoreCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"StatsCollectionViewCell" forIndexPath:indexPath];
        
//        cell.layer.borderWidth=1.0f;
//        cell.layer.borderColor=[UIColor blackColor].CGColor;
        
    HockeyPlayerStatTotals *stats = [[HockeyPlayerStatTotals alloc] initWithPlayer:player];
    
    switch (indexPath.row) {
            
        case 0:
            cell.timetypeLabel.text = @"Games Played";
            cell.goalassistLabel.text = [NSString stringWithFormat:@"%d", currentSettings.gameList.count];
            break;
            
        case 1:
            cell.timetypeLabel.text = @"Goals";
            cell.goalassistLabel.text = [stats.totalGoals stringValue];
            break;
            
        case 2:
            cell.timetypeLabel.text = @"Assists";
            cell.goalassistLabel.text = [stats.totalAssists stringValue];
            break;
            
        case 3:
            cell.timetypeLabel.text = @"Points";
            cell.goalassistLabel.text = [stats.totalPoints stringValue];
            break;

        case 4:
            cell.timetypeLabel.text = @"Shots";
            cell.goalassistLabel.text = [stats.totalShots stringValue];
            break;
            
        case 5:
            cell.timetypeLabel.text = @"Power Play Goals";
            cell.goalassistLabel.text = [stats.totalPowerPlayGoals stringValue];
            break;
            
        case 6:
            cell.timetypeLabel.text = @"Power Play Assists";
            cell.goalassistLabel.text = [stats.totalPowerPlayAssists stringValue];
            break;
            
        case 7:
            cell.timetypeLabel.text = @"Short Handed Goals";
            cell.goalassistLabel.text = [stats.totalShortHandedGoals stringValue];
            break;
            
        case 8:
            cell.timetypeLabel.text = @"Short Handed Assists";
            cell.goalassistLabel.text = [stats.totalShortHandedAssists stringValue];
            break;
            
        case 9:
            cell.timetypeLabel.text = @"Penalty Time";
            cell.goalassistLabel.text = [stats.totalPenaltyMinutes stringValue];
            break;
            
        case 10:
            cell.timetypeLabel.text = @"Face Offs Won";
            cell.goalassistLabel.text = [stats.totalFaceOffsWon stringValue];
            break;
            
        case 11:
            cell.timetypeLabel.text = @"Face Offs Lost";
            cell.goalassistLabel.text = [stats.totalFaceOffsLost stringValue];
            break;
            
        case 12:
            cell.timetypeLabel.text = @"Time On Ice";
            cell.goalassistLabel.text = [stats.totalTimeOnIce stringValue];
            break;
            
        case 13:
            cell.timetypeLabel.text = @"Hits";
            cell.goalassistLabel.text = [stats.totalHits stringValue];
            break;
            
        case 14:
            cell.timetypeLabel.text = @"Plus/Minus";
            cell.goalassistLabel.text = [stats.totalPlusMinus stringValue];
            break;
            
        case 15:
            cell.timetypeLabel.text = @"Blocked Shots";
            cell.goalassistLabel.text = [stats.totalBlockedShots stringValue];
            break;
            
        default:
            cell.timetypeLabel.text = @"Game Won";
            cell.goalassistLabel.text = [stats.totalGamesWon stringValue];
            break;
            
    }

    return cell;
}

// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 }

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderSelectCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                withReuseIdentifier:@"TotalStatsCollectionHeaderView" forIndexPath:indexPath];
        
        reusableview = headerView;
        headerView.headerLabel.text = [game vsOpponent];
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterCell" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    
//    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        size.height = 100;
        size.width = 100;
//    } else {
//        size.height = 100;
//        size.width = 100;
//    }
    
    return size;
}

@end
