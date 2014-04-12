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
    self.navigationItem.rightBarButtonItem = self.addBarButton;
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SponsorsCell";
    EazesportzSponsorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    
    Sponsor *sponsor = [currentSettings.sponsors.sponsors objectAtIndex:indexPath.row];
    
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
    
    cell.sponsorName.text = sponsor.name;
    cell.addrnum.text = [sponsor.addrnum stringValue];
    cell.street.text = sponsor.street;
    cell.city.text = sponsor.city;
    cell.state.text = sponsor.state;
    cell.zip.text = sponsor.zip;
    cell.phone.text = sponsor.phone;
    cell.sponsorLevel.text = sponsor.sponsorlevel;
    cell.sponsorUrl.text = sponsor.adurl;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings isSiteOwner])
        [self performSegueWithIdentifier:@"EditSponsorSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"SponsorMapSegue" sender:self];
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

@end
