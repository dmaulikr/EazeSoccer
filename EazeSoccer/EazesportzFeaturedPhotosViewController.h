//
//  EazesportzFeaturedPhotosViewController.h
//  EazeSportz
//
//  Created by Gil on 1/2/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "PhotosViewController.h"

@interface EazesportzFeaturedPhotosViewController : PhotosViewController

@property (weak, nonatomic) IBOutlet UITableView *featuredTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveButtonClicked:(id)sender;
@end
