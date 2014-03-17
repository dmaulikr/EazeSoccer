//
//  EazesVideosViewController.h
//  EazeSportz
//
//  Created by Gil on 11/14/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "VideosViewController.h"

@interface EazesVideosViewController : VideosViewController


@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
- (IBAction)searchButtonClicked:(id)sender;

@end
