//
//  sportzteamsAlertViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 5/2/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "Athlete.h"

@interface EazeAlertViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *alertTableView;

@property(nonatomic, strong) NSMutableArray *alerts;
@property(nonatomic, strong) Athlete *player;
@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
- (IBAction)sortButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;
- (IBAction)clearButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *adBannerContainer;

@end
