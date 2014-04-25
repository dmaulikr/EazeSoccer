//
//  EazeCoachSelectionViewController.m
//  EazeSportz
//
//  Created by Gil on 11/14/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeCoachSelectionViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazeCoachSelectionViewController ()

@end

@implementation EazeCoachSelectionViewController

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

- (IBAction)cancelButtonClicked:(id)sender {
    self.coach = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.coach = [currentSettings.coaches.coaches objectAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];    
}

@end
