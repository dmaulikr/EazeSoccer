//
//  EazeEventViewController.h
//  EazeSportz
//
//  Created by Gil on 3/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Sport.h"
#import "Team.h"
#import "User.h"

@interface EazeEventViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
- (IBAction)searchButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dateContainer;

@property (nonatomic, strong) Sport *sport;
@property (nonatomic, strong) Team *team;
@property (nonatomic, strong) User *user;

- (IBAction)datesSelected:(UIStoryboardSegue *)segue;
- (IBAction)datesSelectCanceled:(UIStoryboardSegue *)segue;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
