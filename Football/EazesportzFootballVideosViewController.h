//
//  EazesportzFootballVideosViewController.h
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "VideosViewController.h"
#import "Gamelogs.h"

@interface EazesportzFootballVideosViewController : VideosViewController

@property(nonatomic, strong) Gamelogs *gamelog;

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *gamelogContainer;
@end
