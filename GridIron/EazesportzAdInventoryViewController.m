//
//  EazesportzAdInventoryViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/26/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzAdInventoryViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzAdInventoryTableCellTableViewCell.h"
#import "EazesportzEditAdInventoryViewController.h"

@interface EazesportzAdInventoryViewController ()

@end

@implementation EazesportzAdInventoryViewController

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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
    return currentSettings.inventorylist.inventorylist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AdInventoryCell";
    EazesportzAdInventoryTableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Sportadinv *adinventory = [currentSettings.inventorylist.inventorylist objectAtIndex:indexPath.row];
    
    cell.adLevelLabel.text = adinventory.adlevelname;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%.02f", adinventory.price];
    
    if (adinventory.forsale)
        cell.forSaleLabel.text = @"True";
    else
        cell.forSaleLabel.text = @"False";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditAdInventorySegue"]) {
        NSIndexPath *indexPath = [_inventoryTableView indexPathForSelectedRow];
        EazesportzEditAdInventoryViewController *destController = segue.destinationViewController;
        destController.adInventory = [currentSettings.inventorylist.inventorylist objectAtIndex:indexPath.row];
    }
}


@end
