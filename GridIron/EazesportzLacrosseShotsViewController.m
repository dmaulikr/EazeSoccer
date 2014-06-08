//
//  EazesportzLacrosseShotsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/1/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseShotsViewController.h"
#import "EazesportzAppDelegate.h"
#import "VisitingTeam.h"
#import "EazesportzLacrosseScoreCollectionViewCell.h"
#import "HeaderSelectCollectionReusableView.h"

@interface EazesportzLacrosseShotsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzLacrosseShotsViewController {
    NSArray *periodarray;
    NSMutableArray *playershots;
    VisitingTeam *visitors;
    int selectedPeriod;
    NSIndexPath *deleteIndex;
    
    Lacrosstat *stats;
}

@synthesize game;
@synthesize player;
@synthesize visitingPlayer;

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
    periodarray = [[currentSettings.sport.lacrosse_periods allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[currentSettings.sport.lacrosse_periods objectForKey:obj1] compare:[currentSettings.sport.lacrosse_periods objectForKey:obj2]];
    }];
    
    [_periodoneCollectionView.layer setBorderColor:(__bridge CGColorRef)([UIColor blackColor])];
    [_periodoneCollectionView.layer setBorderWidth:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _saveImage.hidden = YES;
    
    _overtimeCollectionView.hidden = YES;
    
    [_periodSegmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_shottypeSegmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    if (visitingPlayer) {
        stats = [visitingPlayer findLacrossStat:game];
        _shotsNavigationItem.title = [NSString stringWithFormat:@"%@ - Shots", visitingPlayer.numberlogname];
    } else {
        stats = [player findLacrosstat:game];
        _shotsNavigationItem.title = [NSString stringWithFormat:@"%@ - Shots", player.numberLogname];
    }
    
    [_periodoneCollectionView reloadData];
    [_periodtwoCollectionView reloadData];
    [_periodthreeCollectionView reloadData];
    [_periodfourCollectionView reloadData];
    [_overtimeCollectionView reloadData];
}

- (IBAction)addButonClicked:(id)sender {
    [stats save:currentSettings.sport Game:game User:currentSettings.user];
    _saveImage.hidden = NO;
}

- (IBAction)shottypeSegmentClicked:(id)sender {
    LacrossPlayerStat *astat;
    
    if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:selectedPeriod]]) {
        astat = [stats.player_stats objectAtIndex:selectedPeriod - 1];
    } else {
        astat = [[LacrossPlayerStat alloc] init];
        [stats.player_stats addObject:astat];
        astat.period = [NSNumber numberWithInt:selectedPeriod];
        astat.lacrosstat_id = stats.lacrosstat_id;
        
        if (visitingPlayer)
            astat.visitor_roster_id = visitingPlayer.visitor_roster_id;
        else
            astat.athlete_id = player.athleteid;
    }
    
    if (astat.shot.count == 0)
        astat.shot = [[NSMutableArray alloc] init];
    
    switch (_shottypeSegmentControl.selectedSegmentIndex) {
        case 0:
            [astat.shot addObject:[currentSettings.sport.lacrosse_shots objectForKey:@"Wide"]];
            break;
            
        case 1:
            [astat.shot addObject:[currentSettings.sport.lacrosse_shots objectForKey:@"Pipe"]];
            break;
            
        default:
            [astat.shot addObject:[currentSettings.sport.lacrosse_shots objectForKey:@"Save"]];
    }
    
    astat.dirty = YES;
    _saveImage.hidden = YES;
    
    [self updateCollectionViews];
}

- (IBAction)periodSegmentClicked:(id)sender {
    switch (_periodSegmentControl.selectedSegmentIndex) {
        case 0:
            selectedPeriod = 1;
            break;
            
        case 1:
            selectedPeriod = 2;
            break;
            
        case 2:
            selectedPeriod = 3;
            break;
            
        case 3:
            selectedPeriod = 4;
            break;
            
        default:
            selectedPeriod = 5;
            break;
    }
    
    if (_periodSegmentControl.selectedSegmentIndex == 4) {
        _overtimeCollectionView.hidden = NO;
        [self.view bringSubviewToFront:_overtimeCollectionView];
    } else {
        _overtimeCollectionView.hidden = YES;
        [self.view sendSubviewToBack:_overtimeCollectionView];
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (view == _periodoneCollectionView) {
        if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:1]])
             return [stats getPlayerStatPeriod:[NSNumber numberWithInt:1]].shot.count;
        else
            return 0;
    } else if (view == _periodtwoCollectionView) {
        if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:2]])
            return [stats getPlayerStatPeriod:[NSNumber numberWithInt:2]].shot.count;
        else
            return 0;
    } else if (view == _periodthreeCollectionView) {
        if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:3]])
            return [stats getPlayerStatPeriod:[NSNumber numberWithInt:3]].shot.count;
        else
            return 0;
    } else if (view == _periodfourCollectionView) {
        if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:4]])
            return [stats getPlayerStatPeriod:[NSNumber numberWithInt:4]].shot.count;
        else
            return 0;
    } else {
        if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:5]])
            return [stats getPlayerStatPeriod:[NSNumber numberWithInt:5]].shot.count;
        else
            return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EazesportzLacrosseScoreCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ShotCell" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    
    if (cv == _periodoneCollectionView) {
        LacrossPlayerStat *thestat = [stats getPlayerStatPeriod:[NSNumber numberWithInt:1]];
        [thestat.shot objectAtIndex:indexPath.row];
        
        if (visitingPlayer)
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [visitingPlayer.number stringValue],
                                       [thestat.shot objectAtIndex:indexPath.row]];
        else
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [player.number stringValue], [thestat.shot objectAtIndex:indexPath.row]];
        
    } else if (cv == _periodtwoCollectionView) {
        LacrossPlayerStat *thestat = [stats getPlayerStatPeriod:[NSNumber numberWithInt:2]];
        [thestat.shot objectAtIndex:indexPath.row];
        
        if (visitingPlayer)
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [visitingPlayer.number stringValue],
                                       [thestat.shot objectAtIndex:indexPath.row]];
        else
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [player.number stringValue], [thestat.shot objectAtIndex:indexPath.row]];
        
    } else if (cv == _periodthreeCollectionView) {
        LacrossPlayerStat *thestat = [stats getPlayerStatPeriod:[NSNumber numberWithInt:3]];
        [thestat.shot objectAtIndex:indexPath.row];
        
        if (visitingPlayer)
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [visitingPlayer.number stringValue],
                                       [thestat.shot objectAtIndex:indexPath.row]];
        else
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [player.number stringValue], [thestat.shot objectAtIndex:indexPath.row]];
        
    } else if (cv == _periodfourCollectionView) {
        LacrossPlayerStat *thestat = [stats getPlayerStatPeriod:[NSNumber numberWithInt:4]];
        [thestat.shot objectAtIndex:indexPath.row];
        
        if (visitingPlayer)
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [visitingPlayer.number stringValue],
                                       [thestat.shot objectAtIndex:indexPath.row]];
        else
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [player.number stringValue], [thestat.shot objectAtIndex:indexPath.row]];
        
    } else {
        LacrossPlayerStat *thestat = [stats getPlayerStatPeriod:[NSNumber numberWithInt:5]];
        [thestat.shot objectAtIndex:indexPath.row];
        
        if (visitingPlayer)
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [visitingPlayer.number stringValue],
                                       [thestat.shot objectAtIndex:indexPath.row]];
        else
            cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", [player.number stringValue], [thestat.shot objectAtIndex:indexPath.row]];
        
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Delete shot?" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
    deleteIndex = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderSelectCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                    withReuseIdentifier:@"ShotHeaderCell" forIndexPath:indexPath];
        
        headerView.layer.borderWidth = 1.0f;
        headerView.layer.borderColor=[UIColor blackColor].CGColor;
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterCell" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Delete"]) {
        LacrossPlayerStat *thestat = [stats.player_stats objectAtIndex:selectedPeriod - 1];
        [thestat.shot removeObjectAtIndex:deleteIndex.row];
    }
    
    [self updateCollectionViews];
}

- (void)updateCollectionViews {
    switch (selectedPeriod) {
        case 1:
            [_periodoneCollectionView reloadData];
            break;
            
        case 2:
            [_periodtwoCollectionView reloadData];
            break;
            
        case 3:
            [_periodthreeCollectionView reloadData];
            break;
            
        case 4:
            [_periodfourCollectionView reloadData];
            break;
            
        default:
            [_overtimeCollectionView reloadData];
            break;
    }
}
@end
