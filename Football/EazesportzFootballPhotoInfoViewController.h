//
//  EazesportzFootballPhotoInfoViewController.h
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "Gamelogs.h"
#import "PhotoInfoViewController.h"

@interface EazesportzFootballPhotoInfoViewController : PhotoInfoViewController

@property (weak, nonatomic) IBOutlet UIView *gamelogContainer;
@property (weak, nonatomic) IBOutlet UITextField *gameplayTextField;

@property (nonatomic, strong) Gamelogs *gamelog;

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end
