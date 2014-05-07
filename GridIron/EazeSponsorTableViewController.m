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

@interface EazeSponsorTableViewController ()

@end

@implementation EazeSponsorTableViewController

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
//    if ([currentSettings isSiteOwner])
//        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addBarButton, self.infoButton, nil];
//    else
        self.navigationItem.rightBarButtonItem = self.infoButton;
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SponsorsCell";
    EazesportzSponsorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    
    Sponsor *sponsor = [currentSettings.sponsors.sponsors objectAtIndex:indexPath.row];
    
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
    
    cell.sponsorName.text = sponsor.name;
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
    if (currentSettings.user.userid.length > 0) {
        if (([[[currentSettings.sponsors.sponsors objectAtIndex:indexPath.row] user_id] isEqualToString:currentSettings.user.userid]) ||
            ([currentSettings isSiteOwner])) {
            [self performSegueWithIdentifier:@"EditSponsorSegue" sender:self];
        }
    } else if ((![[currentSettings.sponsors.sponsors objectAtIndex:indexPath.row] playerad]) &&
               ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])) {
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
    
    if (![segue.identifier isEqualToString:@"SponsorMapSegue"]) {
        [super prepareForSegue:segue sender:sender];
    } else {
        EazesportzSponsorMapViewController *destController = segue.destinationViewController;
        destController.sponsor = [currentSettings.sponsors.sponsors objectAtIndex:indexPath.row];
    }
}

- (IBAction)addBarButtonClicked:(id)sender {
    [super addSponsor];
}

- (IBAction)infoButtonClicked:(id)sender {
    if ([currentSettings isSiteOwner])
        [self performSegueWithIdentifier:@"AdminAdInformationSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"UserAdInformationSegue" sender:self];
}

@end
