//
//  EazesportzFootballVideoInfoViewController.h
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "Gamelogs.h"

@interface EazesportzFootballVideoInfoViewController : VideoInfoViewController

@property (weak, nonatomic) IBOutlet UITextField *gameplayTextField;
@property (weak, nonatomic) IBOutlet UIView *gameplayContainer;

@property (nonatomic, strong) Gamelogs *gamelog;

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIView *scorelogContainer;

- (IBAction)scoreLogSelected:(UIStoryboardSegue *)segue;

@end
