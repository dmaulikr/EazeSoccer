//
//  EazeEditSponsorViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/4/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzEditSponsorViewController.h"

@interface EazeEditSponsorViewController : EazesportzEditSponsorViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarButton;
- (IBAction)deleteBarButonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoBarButton;
- (IBAction)infoBarButtonClicked:(id)sender;
@end
