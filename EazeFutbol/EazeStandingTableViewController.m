//
//  EazeStandingTableViewController.m
//  EazeSportz
//
//  Created by Gil on 11/14/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeStandingTableViewController.h"

@interface EazeStandingTableViewController ()

@end

@implementation EazeStandingTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 60.0)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(78.0, 15.0, 200.0, 55.0)];
    label.backgroundColor= [UIColor clearColor];
    label.textColor = [UIColor blueColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.font = [UIFont boldSystemFontOfSize:14.0];
    label.text = @"Team";
    [header addSubview:label];
    
    UILabel *FGALabel = [[UILabel alloc] initWithFrame:CGRectMake(156.0, 15.0, 100.0, 55.0)];
    FGALabel.backgroundColor= [UIColor clearColor];
    FGALabel.textColor = [UIColor blueColor];
    FGALabel.shadowColor = [UIColor whiteColor];
    FGALabel.shadowOffset = CGSizeMake(0, 1);
    FGALabel.font = [UIFont boldSystemFontOfSize:14.0];
    FGALabel.text = @"Overall";
    [header addSubview:FGALabel];
    
    UILabel *FGMLabel = [[UILabel alloc] initWithFrame:CGRectMake(216.0, 15.0, 100.0, 55.0)];
    FGMLabel.backgroundColor= [UIColor clearColor];
    FGMLabel.textColor = [UIColor blueColor];
    FGMLabel.shadowColor = [UIColor whiteColor];
    FGMLabel.shadowOffset = CGSizeMake(0, 1);
    FGMLabel.font = [UIFont boldSystemFontOfSize:14.0];
    FGMLabel.text = @"League";
    [header addSubview:FGMLabel];
    
    return header;
}

@end
