//
//  UsersViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "UsersViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "sportzCurrentSettings.h"
#import "User.h"
#import "HeaderSelectCollectionReusableView.h"
#import "EditUserViewController.h"
#import "UserTableViewCell.h"
#import "SearchForUserViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface UsersViewController ()

@end

@implementation UsersViewController {
    SearchForUserViewController *searchController;
}

@synthesize user;
@synthesize users;

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
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _userSearchContainer.hidden = YES;
    _segmentButton.selectedSegmentIndex = 1;
}

- (IBAction)selectSearchUserTable:(UIStoryboardSegue *)segue {
    _userSearchContainer.hidden = YES;
    
    if ((searchController.emailTextField.text.length > 0) || (searchController.usernameTextField.text.length > 0)) {
         NSURL *url = [NSURL URLWithString:[sportzServerInit findUsers:searchController.emailTextField.text
                                                              Username:searchController.usernameTextField.text
                                                            Token:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        int statusCode = [(NSHTTPURLResponse*)response statusCode];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSArray *theusers = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        users = [[NSMutableArray alloc] init];
        
        if (statusCode == 200) {
            for (int i = 0; i < [theusers count]; i++) {
                [users addObject:[[User alloc] initWithDictionary:[theusers objectAtIndex:i]]];
            }
            if (users.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Users Found" message:@"Try a different search criteria!"
                                                               delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
            [_usertableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Users"
                                                            message:[NSString stringWithFormat:@"%d", statusCode]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
    }
}

- (IBAction)segmentButtonClicked:(id)sender {
    
    if (_segmentButton.selectedSegmentIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (_segmentButton.selectedSegmentIndex == 2) {
        [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
    }
}

- (IBAction)searchButtonClicked:(id)sender {
    _userSearchContainer.hidden = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = _usertableView.indexPathForSelectedRow;
    if ([segue.identifier isEqualToString:@"EditUserSegue"]) {
        EditUserViewController *destController = segue.destinationViewController;
        destController.theuser = [users objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"EditTheUserSegue"]) {
        EditUserViewController *destController = segue.destinationViewController;
        destController.theuser = [users objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"SearchUserSegue"]) {
        searchController = segue.destinationViewController;
    } else if (indexPath.length > 0) {
        user = [users objectAtIndex:indexPath.row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserTableCell";
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    User *item = [users objectAtIndex:indexPath.row];
    cell.emailLabel.text = item.email;
    cell.usernameLabel.text = item.username;
    
    if ([[item isactive] intValue] == 1)
        cell.activeLabel.text = @"True";
    else
        cell.activeLabel.text = @"False";
    
    if (item.avatarprocessing) {
        cell.userImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
    } else if (item.userthumb.length == 0)
        cell.userImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    else {
        NSURL * imageURL = [NSURL URLWithString:item.userthumb];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.userImage.image = [UIImage imageWithData:imageData];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Users";
}

@end
