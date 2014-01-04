//
//  EazesportzFeaturedVideosViewController.h
//  EazeSportz
//
//  Created by Gil on 1/3/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "VideosViewController.h"

@interface EazesportzFeaturedVideosViewController : VideosViewController

- (IBAction)saveButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *featuredVideoTableView;
@end
