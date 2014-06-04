//
//  EazesportzLacrosseScoresheetViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/27/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseScoresheetViewController.h"

#import "HeaderSelectCollectionReusableView.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzLacrosseScoreCollectionViewCell.h"
#import "LacrossScoring.h"
#import "EazesportzTimeOfTimeOutViewController.h"
#import "EazesportzLacrosseScoreEntryViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface EazesportzLacrosseScoresheetViewController ()

@end

@implementation EazesportzLacrosseScoresheetViewController {
    NSMutableArray *homescores, *visitorscores;
    VisitingTeam *visitors;
    
    BOOL hometimeout;
    
    EazesportzTimeOfTimeOutViewController *timeoutController;
    EazesportzLacrosseScoreEntryViewController *scoreEntryController;
}

@synthesize game;

@synthesize homeCollectionView;
@synthesize visitorCollectionView;

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
    
    _homeLabel.text = currentSettings.team.mascot;
    _visitorLabel.text = game.opponent_mascot;
    homescores = [self getHomeScores];
    [homeCollectionView reloadData];
    
    if (game.lacross_game.visiting_team_id.length > 0) {
        visitors = [currentSettings findVisitingTeam:game.lacross_game.visiting_team_id];
        visitorscores = [self getVisitorScores];
        [visitorCollectionView reloadData];
    }
    
    _timeoutContainer.hidden = YES;
    _scoreEntryContainer.hidden = YES;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TimeOutSegue"]) {
        timeoutController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"ScoreEntrySegue"]) {
        scoreEntryController = segue.destinationViewController;
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if ((view == homeCollectionView) || (view == visitorCollectionView))
        return 21;
    else
        return 12;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    if ((collectionView == homeCollectionView) || (collectionView == visitorCollectionView))
        return 2;
    else
        return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((cv == homeCollectionView) || (cv == visitorCollectionView)) {
        EazesportzLacrosseScoreCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ScoreCell" forIndexPath:indexPath];
        
        cell.layer.borderWidth=1.0f;
        cell.layer.borderColor=[UIColor blackColor].CGColor;
        
        if (indexPath.section == 0) {
            if (indexPath.item == [self collectionView:homeCollectionView numberOfItemsInSection:indexPath.section - 1]) {
                cell.border = TLGridBorderLeft;
            } else {
                cell.border = TLGridBorderLeft | TLGridBorderRight;
            }
        } else {
            if (indexPath.item == [self collectionView:homeCollectionView numberOfItemsInSection:indexPath.section - 1]) {
                cell.border = TLGridBorderLeft;
            } else {
                cell.border = TLGridBorderLeft | TLGridBorderRight;
            }
        }
        
        if (indexPath.row > 0) {
            LacrossScoring *astat;
            
            if ((cv == homeCollectionView) && (homescores.count >= indexPath.row)) {
                astat = [homescores objectAtIndex:indexPath.row - 1];
                cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", astat.gametime, astat.scorecode];
                cell.goalassistLabel.text = [NSString stringWithFormat:@"%@", [[[currentSettings findAthlete:astat.athlete_id] number] stringValue] ];
                
                if (astat.assist.length > 0)
                    cell.goalassistLabel.text = [cell.goalassistLabel.text stringByAppendingString:[NSString stringWithFormat:@" - %@",
                                                                            [[[currentSettings findAthlete:astat.assist] number] stringValue]]];
            } else if ((cv == visitorCollectionView) && (visitorscores.count >= indexPath.row)) {
                astat = [visitorscores objectAtIndex:indexPath.row - 1];
                cell.timetypeLabel.text = [NSString stringWithFormat:@"%@ - %@", astat.gametime, astat.scorecode];
                cell.goalassistLabel.text = [NSString stringWithFormat:@"%@", [[[visitors findAthlete:astat.visitor_roster_id] number] stringValue]];
                
                if (astat.assist.length > 0)
                    cell.goalassistLabel.text = [cell.goalassistLabel.text stringByAppendingString:[NSString stringWithFormat:@" - %@",
                                             [[[visitors findAthlete:astat.assist] number] stringValue]]];
            } else {
                cell.timetypeLabel.text = @"";
                cell.goalassistLabel.text = @"";
            }
        } else {
            cell.timetypeLabel.text = @"Time - Type";
            cell.goalassistLabel.text = @"Goal - Assist";
        }
        
        return cell;
    } else {
        EazesportzLacrosseScoreCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TimeOutCell" forIndexPath:indexPath];

        cell.layer.borderWidth=1.0f;
        cell.layer.borderColor=[UIColor blackColor].CGColor;
        
        if (cv == _hometimeoutCollectionView) {
            if ((indexPath.row == 0) || (indexPath.row == 3) || (indexPath.row == 6) || (indexPath.row == 9))
                switch (indexPath.row) {
                    case 0:
                        cell.timetypeLabel.text = @"";
                        break;
                        
                    case 3:
                        cell.timetypeLabel.text = @"1";
                        break;
                        
                    case 6:
                        cell.timetypeLabel.text = @"2";
                        break;
                        
                    default:
                        cell.timetypeLabel.text = @"3";
                        break;
                }
            else {
                
                switch (indexPath.row) {
                    case 1:
                        cell.timetypeLabel.text = @"1st";
                        break;
                        
                    case 2:
                        cell.timetypeLabel.text = @"2nd";
                        break;
                        
                    case 4:
                    case 5:
                    case 7:
                    case 8:
                    case 10:
                    case 11:
                        cell.timetypeLabel.text = [self getTimeoutString:indexPath.row FirstPeriod:game.lacross_game.home_1stperiod_timeouts
                                                            SecondPeriod:game.lacross_game.home_2ndperiod_timeouts];
                        break;
                        
                    default:
                        break;
                }
            }
        } else {
            if ((indexPath.row == 0) || (indexPath.row == 3) || (indexPath.row == 6) || (indexPath.row == 9)) {
                switch (indexPath.row) {
                    case 0:
                        cell.timetypeLabel.text = @"";
                        break;
                        
                    case 3:
                        cell.timetypeLabel.text = @"1";
                        break;
                        
                    case 6:
                        cell.timetypeLabel.text = @"2";
                        break;
                        
                    default:
                        cell.timetypeLabel.text = @"3";
                        break;
                }
            } else {
                switch (indexPath.row) {
                    case 1:
                        cell.timetypeLabel.text = @"1st";
                        break;
                        
                    case 2:
                        cell.timetypeLabel.text = @"2nd";
                        break;
                        
                    case 4:
                    case 5:
                    case 7:
                    case 8:
                    case 10:
                    case 11:
                        cell.timetypeLabel.text = [self getTimeoutString:indexPath.row FirstPeriod:game.lacross_game.visitor_1stperiod_timeouts
                                                            SecondPeriod:game.lacross_game.visitor_2ndperiod_timeouts];
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        return cell;
    }
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == homeCollectionView) {
        
        if (indexPath.row - 1 < homescores.count)
            scoreEntryController.scorestat = [homescores objectAtIndex:indexPath.row - 1];
        else
            scoreEntryController.scorestat = nil;
        
        scoreEntryController.game = game;
        scoreEntryController.visitingTeam = NO;
        [scoreEntryController viewWillAppear:YES];
        _scoreEntryContainer.hidden = NO;
    } else if (collectionView == visitorCollectionView) {
        
        if (indexPath.row - 1 < visitorscores.count)
            scoreEntryController.scorestat = [visitorscores objectAtIndex:indexPath.row - 1];
        else
            scoreEntryController.scorestat = nil;
        
        scoreEntryController.game = game;
        scoreEntryController.visitingTeam = YES;
        [scoreEntryController viewWillAppear:YES];
        _scoreEntryContainer.hidden = NO;
    } else {
        _timeoutContainer.hidden = NO;
        NSString *timeoutString;
        NSArray *timeout;
        
        if ((indexPath.row == 4) || (indexPath.row == 5))
            timeoutController.period = [NSNumber numberWithInt:1];
        else if ((indexPath.row == 7) || (indexPath.row == 8))
            timeoutController.period = [NSNumber numberWithInt:2];
        else
            timeoutController.period = [NSNumber numberWithInt:3];
        
        if ((indexPath.row == 5) || (indexPath.row == 8) || (indexPath.row == 11))
            timeoutController.half = 2;
        else
            timeoutController.half = 1;
        
        if (collectionView == _hometimeoutCollectionView) {
            timeoutString = [self getTimeoutString:indexPath.row FirstPeriod:game.lacross_game.home_1stperiod_timeouts
                                      SecondPeriod:game.lacross_game.home_2ndperiod_timeouts];
            
            if (timeoutString.length > 0) {
                timeout = [timeoutString componentsSeparatedByString:@":"];
                timeoutController.minutesTextField.text = timeout[0];
                timeoutController.secondsTextField.text = timeout[1];
                
            } else {
                timeoutController.minutesTextField.text = @"";
                timeoutController.secondsTextField.text = @"";
            }
            
            hometimeout = YES;
        } else if (((indexPath.row == 4) || (indexPath.row == 5)) && (collectionView == _visitortimeoutCollectionView)) {
            timeoutString = [self getTimeoutString:indexPath.row FirstPeriod:game.lacross_game.visitor_1stperiod_timeouts
                                      SecondPeriod:game.lacross_game.visitor_2ndperiod_timeouts];
            
            if (timeoutString.length > 0) {
                timeout = [timeoutString componentsSeparatedByString:@":"];
                timeoutController.minutesTextField.text = timeout[0];
                timeoutController.secondsTextField.text = timeout[1];
            } else {
                timeoutController.minutesTextField.text = @"";
                timeoutController.secondsTextField.text = @"";
            }
            
            hometimeout = NO;
        }
        
        [timeoutController viewWillAppear:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderSelectCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                            withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        
        reusableview = headerView;
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
    
    if ((collectionView == homeCollectionView) || (collectionView == visitorCollectionView)) {
        size.height = 80;
        size.width = 80;
    } else {
        if ((indexPath.row == 0) || (indexPath.row == 3) || (indexPath.row == 6) || (indexPath.row == 9)) {
            size.height = 20;
            size.width = 20;
        } else {
            size.height = 20;
            size.width = 55;
        }
    }
    
    return size;
}

- (NSString *)getTimeoutString:(NSUInteger)index FirstPeriod:(NSMutableArray *)firstPeriodTimeOuts
                                                SecondPeriod:(NSMutableArray *)secondPeriodTimeOuts {
    NSString *timeoutString;
    
    switch (index) {
        case 4:
            timeoutString = firstPeriodTimeOuts[0];
            break;
        case 5:
            timeoutString = secondPeriodTimeOuts[0];
            break;
        case 7:
            timeoutString = firstPeriodTimeOuts[1];
            break;
        case 8:
            timeoutString = secondPeriodTimeOuts[1];
            break;
        case 10:
            timeoutString = firstPeriodTimeOuts[2];
            break;
        case 11:
            timeoutString = secondPeriodTimeOuts[2];
            break;
    }
    
    return timeoutString;
}

- (NSMutableArray *)getHomeScores {
    NSMutableArray *scores = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < currentSettings.roster.count; i++) {
        Lacrosstat *astat = [[currentSettings.roster objectAtIndex:i] findLacrosstat:game];
        
        if (astat.scoring_stats.count > 0) {
            for (int cnt = 0; cnt < astat.scoring_stats.count; cnt++) {
                [scores addObject:[astat.scoring_stats objectAtIndex:cnt]];
            }
        }
    }
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"period" ascending:YES selector:@selector(compare:)];
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gametime" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, secondDescriptor, nil];
    [scores sortUsingDescriptors:descriptors];
    
    return scores;
}

- (NSMutableArray *)getVisitorScores {
    NSMutableArray *scores = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < visitors.visitor_roster.count; i++) {
        Lacrosstat *astat = [[visitors.visitor_roster objectAtIndex:i] findLacrossStat:game];
        
        if (astat) {
            if (astat.scoring_stats.count > 0) {
                for (int cnt = 0; cnt < astat.scoring_stats.count; cnt++) {
                    [scores addObject:[astat.scoring_stats objectAtIndex:cnt]];
                }
            }
        }
    }
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"period" ascending:YES];
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gametime" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, secondDescriptor, nil];
    [scores sortUsingDescriptors:descriptors];
    
    return scores;
}

- (IBAction)timeoutSubmit:(UIStoryboardSegue *)segue {
    _timeoutContainer.hidden = YES;
    NSMutableString *timeformat = [NSMutableString stringWithFormat:@"%@:%@", timeoutController.minutesTextField.text,
                                   timeoutController.secondsTextField.text];
    
    if (hometimeout) {        
        if (([timeoutController.period intValue] == 1) && (timeoutController.half == 1))
           [ game.lacross_game.home_1stperiod_timeouts replaceObjectAtIndex:0 withObject:timeformat];
        else if (([timeoutController.period intValue] == 1) && (timeoutController.half == 2))
            [game.lacross_game.home_2ndperiod_timeouts replaceObjectAtIndex:0 withObject:timeformat];
        else if (([timeoutController.period intValue] == 2) && (timeoutController.half == 1))
            [game.lacross_game.home_1stperiod_timeouts replaceObjectAtIndex:1 withObject:timeformat];
        else if (([timeoutController.period intValue] == 2) && (timeoutController.half == 2))
            [game.lacross_game.home_2ndperiod_timeouts replaceObjectAtIndex:1 withObject:timeformat];
        else if (([timeoutController.period intValue] == 3) && (timeoutController.half == 1))
            [game.lacross_game.home_1stperiod_timeouts replaceObjectAtIndex:2 withObject:timeformat];
        else
            [game.lacross_game.home_2ndperiod_timeouts replaceObjectAtIndex:2 withObject:timeformat];
        
        [game.lacross_game saveHomeTimeouts];
        
        [_hometimeoutCollectionView reloadData];
    } else {
        if (([timeoutController.period intValue] == 1) && (timeoutController.half == 1))
            [ game.lacross_game.visitor_1stperiod_timeouts replaceObjectAtIndex:0 withObject:timeformat];
        else if (([timeoutController.period intValue] == 1) && (timeoutController.half == 2))
            [game.lacross_game.visitor_2ndperiod_timeouts replaceObjectAtIndex:0 withObject:timeformat];
        else if (([timeoutController.period intValue] == 2) && (timeoutController.half == 1))
            [game.lacross_game.visitor_1stperiod_timeouts replaceObjectAtIndex:1 withObject:timeformat];
        else if (([timeoutController.period intValue] == 2) && (timeoutController.half == 2))
            [game.lacross_game.visitor_2ndperiod_timeouts replaceObjectAtIndex:1 withObject:timeformat];
        else if (([timeoutController.period intValue] == 3) && (timeoutController.half == 1))
            [game.lacross_game.visitor_1stperiod_timeouts replaceObjectAtIndex:2 withObject:timeformat];
        else
            [game.lacross_game.visitor_2ndperiod_timeouts replaceObjectAtIndex:2 withObject:timeformat];
        
        [game.lacross_game saveHomeTimeouts];
        
        [_visitortimeoutCollectionView reloadData];
    }
}

- (IBAction)scoreEntryCompleted:(UIStoryboardSegue *)segue {
    _scoreEntryContainer.hidden = YES;
    
    scoreEntryController.scorestat.gametime = [NSString stringWithFormat:@"%@:%@", scoreEntryController.minutesTextField.text,
                                                                                    scoreEntryController.secondsTextField.text];
    [scoreEntryController.scorestat save:currentSettings.sport Team:currentSettings.team Gameschedule:game User:currentSettings.user];
    Lacrosstat *lacrosstat;
    
    if (scoreEntryController.visitingTeam) {
        lacrosstat = [scoreEntryController.visitor findLacrossStat:game];
        [lacrosstat addScoringStat:scoreEntryController.scorestat];
    } else {
        lacrosstat = [scoreEntryController.athlete findLacrosstat:game];
        [lacrosstat addScoringStat:scoreEntryController.scorestat];
    }
    
    homescores = [self getHomeScores];
    [visitorCollectionView reloadData];
    
    visitorscores = [self getVisitorScores];
    [homeCollectionView reloadData];
}

- (IBAction)deleteScoreEntryCompleted:(UIStoryboardSegue *)segue {
    Lacrosstat *thestat;
    
    if (scoreEntryController.visitingTeam) {
        thestat = [scoreEntryController.visitor findLacrossStat:game];
    } else {
        thestat = [scoreEntryController.athlete findLacrosstat:game];
    }
    
    if (![thestat deleteStat:thestat.lacrosse_scoring Game:game.id Stat:scoreEntryController.scorestat.lacross_scoring_id]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error deleting scoring stat." delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    homescores = [self getHomeScores];
    [visitorCollectionView reloadData];
    
    visitorscores = [self getVisitorScores];
    [homeCollectionView reloadData];
}

@end
