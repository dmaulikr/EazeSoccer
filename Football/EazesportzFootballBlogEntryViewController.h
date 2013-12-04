//
//  EazesportzFootballBlogEntryViewController.h
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "BlogEntryViewController.h"
#import "Gamelogs.h"

@interface EazesportzFootballBlogEntryViewController : BlogEntryViewController

@property (nonatomic, strong) Gamelogs *gamelog;
@property (weak, nonatomic) IBOutlet UIView *gamelogContainer;

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UITextField *gameplayTextField;
@property (weak, nonatomic) IBOutlet UIButton *gameplayButton;

@end
