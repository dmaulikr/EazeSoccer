//
//  EazesportzFootballEditPlayerViewController.m
//  EazeSportz
//
//  Created by Gil on 12/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballEditPlayerViewController.h"
#import "EazesportzFootballPlayerStatsViewController.h"

@interface EazesportzFootballEditPlayerViewController ()

@end

@implementation EazesportzFootballEditPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.statsButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
