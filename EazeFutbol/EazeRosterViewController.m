//
//  EazeRosterViewViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeRosterViewController.h"
#import "PlayerInfoViewController.h"
#import "EazesportzAppDelegate.h"
#import "RosterTableCell.h"

@interface EazeRosterViewController ()

@end

@implementation EazeRosterViewController

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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.coachesButton, self.searchButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.rosterTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RosterTableCell";
    RosterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[RosterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *aplayer = [currentSettings.roster objectAtIndex:indexPath.row];
    cell.playernameLabel.text = aplayer.name;
    cell.playerNumberLabel.text = [aplayer.number stringValue];
    cell.playerPositionLabel.text = aplayer.position;
    
    if (aplayer.tinyimage == nil) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:aplayer.tinypic]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.rosterImage.image = [UIImage imageWithData:image];
            });
        });
    } else
        cell.rosterImage.image = aplayer.tinyimage;
    
    if ([currentSettings hasAlerts:aplayer.athleteid] == NO)
        cell.alertImage.image = nil;
    
    return cell;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
}

@end
