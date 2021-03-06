//
//  EazesportzSponsorTableViewController.m
//  EazeSportz
//
//  Created by Gil on 1/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSponsorTableViewController.h"

#import "EazesportzAppDelegate.h"
#import "EazesportzSponsorsTableViewCell.h"
#import "EazesportzEditSponsorViewController.h"

@interface EazesportzSponsorTableViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzSponsorTableViewController {
    BOOL nosponsormessage;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSponsors:) name:@"SponsorListChangedNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (([currentSettings isSiteOwner]) && (!currentSettings.sport.purchaseads)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Your sport is not set up to sell ads and receive ad revenue. \nPlease visit GameTrackerPro.com to set up your site for ads." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotSponsors:(NSNotification *)notification {
    [_sponsorTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return currentSettings.sponsors.sponsors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SponsorsCell";
    EazesportzSponsorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Sponsor *sponsor = [currentSettings.sponsors.sponsors objectAtIndex:indexPath.row];
    
    if (sponsor.thumb.length > 0) {
        NSURL * imageURL = [NSURL URLWithString:sponsor.thumb];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.sponsorImage.image = [UIImage imageWithData:imageData];
    } else {
        cell.sponsorImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    
    cell.sponsorName.text = sponsor.name;
    cell.addrnum.text = [sponsor.addrnum stringValue];
    cell.street.text = sponsor.street;
    cell.city.text = sponsor.city;
    cell.state.text = sponsor.state;
    cell.zip.text = sponsor.zip;
    cell.phone.text = sponsor.phone;
    cell.sponsorLevel.text = sponsor.adsponsorlevel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Sponsors for %@", currentSettings.team.mascot];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EditSponsorSegue"]) {
        NSIndexPath *indexPath = [_sponsorTableView indexPathForSelectedRow];
        EazesportzEditSponsorViewController *destController = segue.destinationViewController;
        destController.sponsor = [currentSettings.sponsors.sponsors objectAtIndex:indexPath.row];
        destController.storekitProduct = nil;
        destController.adproduct = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Info"]) {
        [self performSegueWithIdentifier:@"UpgradeInfoSegue" sender:self];
    } else if ([title isEqualToString:@"Dismiss"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if ([title isEqualToString:@"More Info"]) {
        [self performSegueWithIdentifier:@"SponsorInfoSegue" sender:self];
    }
}

- (void)addSponsor {
    if ([currentSettings.user loggedIn])
        [self performSegueWithIdentifier:@"NewSponsorSegue" sender:self];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please create a login to become a sponsor" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"More Info", nil];
        [alert show];
    }
}

@end
