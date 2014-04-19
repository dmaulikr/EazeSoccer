//
//  SelectSiteTableViewController.m
//  Eazebasketball
//
//  Created by Gil on 9/30/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "SelectSiteTableViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzteamsRegisterLoginViewController.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzRetrieveAlerts.h"
#import "EazesportzRetrieveCoaches.h"
#import "EazesportzRetrieveGames.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzRetrieveSponsors.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzRetrieveTeams.h"

@interface SelectSiteTableViewController () <UIAlertViewDelegate>

@end

@implementation SelectSiteTableViewController {
    NSMutableArray *siteList;
    
    EazesportzRetrieveTeams *getTeams;
}

@synthesize state;
@synthesize sitename;
@synthesize city;
@synthesize country;
@synthesize zipcode;
@synthesize sportname;
@synthesize sport;

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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSport:) name:@"SportChangedNotification" object:nil];

    if (((state.length > 0) || (city.length > 0) || (sitename.length > 0) || (country.length > 0)) && (sportname.length > 0)) {
        NSString *astring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",
                                           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], @"/sports.json?sport=",
                                           sportname, @"&city=", city, @"&state=", state, @"&sitename=", sitename, @"&country=", country];
        NSString* webStringURL = [astring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:webStringURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        if ([(NSHTTPURLResponse*)response statusCode] == 200) {
            NSArray *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            siteList = [[NSMutableArray alloc] init];
            
            if (serverData.count > 0) {
                for (int i = 0; i < [serverData count]; i++) {
                    Sport *asport = [[Sport alloc] initWithDictionary:[serverData objectAtIndex:i]];
                     
                    if ((asport.approved) && ([asport.teamcount intValue] > 0))
                        [siteList addObject:asport];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice!" message:@"No Sites match search cirteria!" delegate:nil
                                                      cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Retrieving Site List" delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You must select a sport name and at least one other search criteria!"
                                            delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    [_siteTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
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
    return siteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SiteTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Sport *asport = [siteList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName: @"Arial" size: 14.0 ];
    cell.textLabel.text = asport.sitename;

    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
        cell.imageView.image = [asport getImage:@"thumb"];
    else
        cell.imageView.image = [asport getImage:@"tiny"];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", asport.mascot, @"   ", asport.city, @" ",
                                 asport.state, @" ", asport.zip, @" ", asport.country];;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    sport = [siteList objectAtIndex:indexPath.row];

    if (!_selectSite) {
        currentSettings.sport.id = @"";
        [currentSettings setUpSport:sport.id];
//        [[[EazesportzRetrieveSport alloc] init] retrieveSport:sport.id Token:currentSettings.user.authtoken];
        [self gotSport:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Eazesportz Sites";
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_siteTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"RegisterSiteLoginSegue"]) {
        sportzteamsRegisterLoginViewController *destController = segue.destinationViewController;
        destController.sport = [siteList objectAtIndex:indexPath.row];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if ([title isEqualToString:@"Continue"]) {
//        NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"];
//        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/currentsite.txt"];
        
//        [dataFile writeToFile:docPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        
    }
}

- (void)gotSport:(NSNotification *)notification {
    currentSettings.sitechanged = YES;
    
    if (currentSettings.changesite) {
        currentSettings.changesite = NO;
        self.tabBarController.tabBar.hidden = NO;
    }
    
    UIImageView *myGraphic;
    
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg-640x1136.png"]];
        else
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg.png"]];
    } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
        myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gymfloor-640x1136.png"]];
    } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soccer-640x1136"]];
    }
    
    [currentSettings.rootwindow.rootViewController.view addSubview: myGraphic];
    [currentSettings.rootwindow.rootViewController.view sendSubviewToBack: myGraphic];
    
    UITabBarController *tabBarController = self.tabBarController;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
    
    for (UIViewController *viewController in tabBarController.viewControllers) {
        if ([viewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

@end
