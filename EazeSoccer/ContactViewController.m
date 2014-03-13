//
//  sportzteamsContactViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/7/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "ContactViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "Contact.h"
#import "ContactCell.h"
#import "EditContactViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface ContactViewController ()

@end

@implementation ContactViewController {
    NSArray *serverData;
    NSMutableData *theData;
    NSMutableArray *contacts;
    int responseStatusCode;
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
    self.view.backgroundColor = [UIColor clearColor];
    _contactTableView.layer.cornerRadius = 4;
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
    NSURL *url = [NSURL URLWithString:[sportzServerInit getContacts:currentSettings.user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ContactInfoSegue"]) {
        NSIndexPath *indexPath = [_contactTableView indexPathForSelectedRow];
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
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:nil error:nil];
    contacts = [[NSMutableArray alloc] init];
    
    if (responseStatusCode == 200) {
        for (int i = 0; i < [serverData count]; i++) {
            NSDictionary *items = [serverData objectAtIndex:i];
            Contact *contact = [[Contact alloc] init];
            contact.contactid = [items objectForKey:@"id"];
            contact.title = [items objectForKey:@"title"];
            contact.name = [items objectForKey:@"name"];
            contact.phone = [items objectForKey:@"phone"];
            contact.mobile = [items objectForKey:@"mobile"];
            contact.fax = [items objectForKey:@"fax"];
            contact.email = [items objectForKey:@"email"];
            [contacts addObject:contact];
        }
        
        if (contacts.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Contacts"
                                 message:[NSString stringWithFormat:@"%@%@", @"Contacts have not been entered for ", currentSettings.sport.sitename]
                                 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        [_contactTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Newsfeed"
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
    static NSString *CellIdentifier = @"ContactCell";
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
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    //     gomobisportsNewsViewController *detailViewController = [[gomobisportsNewsViewController alloc] initWithNibName:@"NewsDetail" bundle:nil];
    // Pass the selected object to the new view controller.
    //     [self.navigationController pushViewController:detailViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return currentSettings.sport.sitename;
}

@end
