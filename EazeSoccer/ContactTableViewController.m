//
//  ContactTableViewController.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "ContactTableViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "EditContactViewController.h"
#import "ContactCell.h"

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController {
    NSArray *serverData;
    NSMutableData *theData;
    NSMutableArray *contacts;
    long responseStatusCode;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (currentSettings.sport.id.length > 0) {
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/contacts.json?auth_token=", currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/contacts.json"]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else {
        Contact *contact = [[Contact alloc] init];
        contact.title = @"Eazesportz, LLC.";
        contact.email = @"info@eazesportz.com";
        contacts = [[NSMutableArray alloc] init];
        [contacts addObject:contacts];
        [self.tableView reloadData];
    }
    
    if (([currentSettings isSiteOwner]) && ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])) {
        self.navigationItem.rightBarButtonItem = self.addBarButton;
        self.navigationController.toolbarHidden = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ContactInfoSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EditContactViewController *destViewController = segue.destinationViewController;
        destViewController.contact = [contacts objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"NewContactSegue"]) {
        EditContactViewController *destController = segue.destinationViewController;
        destController.contact = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download cound not complete - please make sure you're connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    contacts = [[NSMutableArray alloc] init];
    
    if (responseStatusCode == 200) {
        for (int i = 0; i < [serverData count]; i++) {
            [contacts addObject:[[Contact alloc] initWithDirectory:[serverData objectAtIndex:i]] ];
        }
        
        if (contacts.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Contacts"
                                                            message:[NSString stringWithFormat:@"%@%@", @"Contacts have not been entered for ", currentSettings.sport.sitename]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        [self.tableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Contacts"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
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
    return [contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactTableCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.contactTitle setText:[[contacts objectAtIndex:indexPath.row] title]];
    [cell.contactName setText:[[contacts objectAtIndex:indexPath.row] name]];
    [cell.contactPhone setText:[[contacts objectAtIndex:indexPath.row] phone]];
    [cell.contactMobile setText:[[contacts objectAtIndex:indexPath.row] mobile]];
    [cell.contactFax setText:[[contacts objectAtIndex:indexPath.row] fax]];
    [cell.contactEmail setText:[[contacts objectAtIndex:indexPath.row] email]];
    
    if ([currentSettings isSiteOwner]) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ContactInfoSegue" sender:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return currentSettings.sport.sitename;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([currentSettings isSiteOwner])
        return YES;
    else
        return  NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Contact *acontact = [contacts objectAtIndex:indexPath.row];
        if (![acontact initDeleteContact]) {
            [contacts removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Contact"  message:[acontact httperror]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
 //   else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
