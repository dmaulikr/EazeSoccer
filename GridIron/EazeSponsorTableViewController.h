//
//  EazeSponsorTableViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/4/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSponsorTableViewController.h"

@interface EazeSponsorTableViewController : EazesportzSponsorTableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButton;
- (IBAction)addBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
- (IBAction)infoButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;
- (IBAction)searchBarButtonClicked:(id)sender;

@end
