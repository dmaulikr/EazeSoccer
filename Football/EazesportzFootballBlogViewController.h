//
//  EazesportzFootballBlogViewController.h
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "BlogViewController.h"
#import "Gamelogs.h"

@interface EazesportzFootballBlogViewController : BlogViewController

@property (nonatomic, strong) Gamelogs *gamelog;
@property (weak, nonatomic) IBOutlet UIView *gamelogContainer;

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue;
@end
