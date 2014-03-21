//
//  EazNewsViewController.h
//  EazeSportz
//
//  Created by Gil on 1/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface EazeNewsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *news;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
- (IBAction)refreshButtonClicked:(id)sender;

@end
