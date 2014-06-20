//
//  EazeSponsorTableViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/4/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeSponsorTableViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzSponsorsTableViewCell.h"
#import "EazesportzSponsorMapViewController.h"
#import "EazesportzRetrieveAdvertisements.h"
#import "EazesportzEditSponsorViewController.h"

@interface EazeSponsorTableViewController () <UIAlertViewDelegate>

@end

@implementation EazeSponsorTableViewController {
    EazesportzRetrieveAdvertisements *getAds;
    BOOL myads;
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
    getAds = [[EazesportzRetrieveAdvertisements alloc] init];
    myads = NO;
    
    if ([currentSettings.user loggedIn]) {
        NSMutableArray *barButtons = [[NSMutableArray alloc] init];
        
        if (currentSettings.sport.purchaseads)
            [barButtons addObject:self.addBarButton];
        
        [barButtons addObjectsFromArray:[NSArray arrayWithObjects:self.searchBarButton, self.infoButton, nil]];
        self.navigationItem.rightBarButtonItems = barButtons;
    } else {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.infoButton, nil];
    }
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (myads)
        return getAds.advertisements.count;
    else
        return currentSettings.sponsors.sponsors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SponsorsCell";
    EazesportzSponsorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    
    Sponsor *sponsor;
    
    if (myads) {
        sponsor = [getAds.advertisements objectAtIndex:indexPath.row];
    } else {
        sponsor = [currentSettings.sponsors.sponsors objectAtIndex:indexPath.row];
    }
    
    if (sponsor.playerad) {
        if ((sponsor.portraitBannerImage == nil) && (sponsor.portraitbanner.length > 0)) {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sponsor.portraitbanner]];
                cell.sponsorImage.image = [UIImage imageWithData:image];
            });
        } else if (sponsor.portraitbanner.length > 0) {
            cell.sponsorImage.image = sponsor.portraitBannerImage;
        } else if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
            cell.sponsorImage.image = [currentSettings.team getImage:@"tiny"];
        } else {
            cell.sponsorImage.image = [currentSettings.team getImage:@"thumb"];
        }
    } else {
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
            if (sponsor.tinyimage == nil) {
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //this will start the image loading in bg
                dispatch_async(concurrentQueue, ^{
                    NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sponsor.tiny]];
                    cell.sponsorImage.image = [UIImage imageWithData:image];
                });
            } else {
                cell.sponsorImage.image = sponsor.tinyimage;
            }
        } else {
            if (sponsor.thumbimage == nil) {
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //this will start the image loading in bg
                dispatch_async(concurrentQueue, ^{
                    NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:sponsor.thumb]];
                    cell.sponsorImage.image = [UIImage imageWithData:image];
                });
            } else {
                cell.sponsorImage.image = sponsor.thumbimage;
            }
        }
    }
    
    cell.sponsorName.text = sponsor.name;
    
    if ([sponsor.addrnum intValue] == 0)
        cell.addrnum.text = @"";
    else
        cell.addrnum.text = [sponsor.addrnum stringValue];
    
    cell.street.text = sponsor.street;
    cell.city.text = sponsor.city;
    cell.state.text = sponsor.state;
    cell.zip.text = sponsor.zip;
    cell.phone.text = sponsor.phone;
    cell.sponsorLevel.text = sponsor.adsponsorlevel;
    cell.sponsorUrl.text = sponsor.adurl;
    
    if (sponsor.athlete_id.length > 0)
        cell.playerAdLabel.hidden = NO;
    else
        cell.playerAdLabel.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings.user loggedIn]) {
        if (myads)
            [self performSegueWithIdentifier:@"EditSponsorSegue" sender:self];
        else if (([[[currentSettings.sponsors.sponsors objectAtIndex:indexPath.row] user_id] isEqualToString:currentSettings.user.userid]) ||
            ([currentSettings isSiteOwner])) {
            [self performSegueWithIdentifier:@"EditSponsorSegue" sender:self];
        } else {
            [self performSegueWithIdentifier:@"SponsorMapSegue" sender:self];
        }
    } else if (![[currentSettings.sponsors.sponsors objectAtIndex:indexPath.row] playerad]) {
        [self performSegueWithIdentifier:@"SponsorMapSegue" sender:self];
    }
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.sponsorTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"EditSponsorSegue"]) {
        NSIndexPath *indexPath = [self.sponsorTableView indexPathForSelectedRow];
        EazesportzEditSponsorViewController *destController = segue.destinationViewController;
        destController.sponsor = [currentSettings.sponsors.sponsors objectAtIndex:indexPath.row];
        destController.storekitProduct = nil;
        destController.adproduct = nil;
    } else if ([segue.identifier isEqualToString:@"SponsorMapSegue"]) {
        EazesportzSponsorMapViewController *destController = segue.destinationViewController;
        
        if (myads)
            destController.sponsor = [getAds.advertisements objectAtIndex:indexPath.row];
        else
            destController.sponsor = [currentSettings.sponsors.sponsors objectAtIndex:indexPath.row];
    }
}

- (IBAction)addBarButtonClicked:(id)sender {
    if ([currentSettings isSiteOwner])
        [super addSponsor];
    else {
        [self performSegueWithIdentifier:@"ListInappAdSegue" sender:self];
    }
}

- (IBAction)infoButtonClicked:(id)sender {
    if ([currentSettings isSiteOwner])
        [self performSegueWithIdentifier:@"AdminAdInformationSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"UserAdInformationSegue" sender:self];
}

- (IBAction)searchBarButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
                                                    message:[NSString stringWithFormat:@"Find Sponsors for %@", currentSettings.team.mascot]
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"My Ads",
                                                    [NSString stringWithFormat:@"%@ Sponsors", currentSettings.team.mascot], nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"My Ads"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMyAds:) name:@"AdvertisementListChangedNotification" object:nil];
        [getAds retrieveUserAds:currentSettings.sport UserId:currentSettings.user.userid];
    } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:[NSString stringWithFormat:@"%@ Sponsors", currentSettings.team.mascot]]) {
        myads = NO;
        [self.sponsorTableView reloadData];
    }
}

- (void)gotMyAds:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        myads = YES;
        [self.sponsorTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error getting user advertisements" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

@end
