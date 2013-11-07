//
//  FullGameScheduleViewController.m
//  EazeSportz
//
//  Created by Gil on 11/7/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FullGameScheduleViewController.h"
#import "EazesportzAppDelegate.h"

@interface FullGameScheduleViewController () <UIAlertViewDelegate>

@end

@implementation FullGameScheduleViewController {
    NSIndexPath *deleteIndexPath;
}

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteIndexPath = [self.gamesTableView indexPathForSelectedRow];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You are about delete the game. All data will be lost!"
                                                       delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if (![[currentSettings.gameList objectAtIndex:deleteIndexPath.row] initDeleteGame]) {
            [currentSettings.gameList removeObjectAtIndex:deleteIndexPath.row];
            [self.gamesTableView reloadData];
        }
    }
}

@end
