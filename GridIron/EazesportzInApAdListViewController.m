//
//  EazesportzInApAdListViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzInApAdListViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzRetrieveInAppAdProducts.h"
#import "InAppProducts.h"
#import "PlayerSelectionViewController.h"

#import <StoreKit/StoreKit.h>

@interface EazesportzInApAdListViewController () <SKProductsRequestDelegate, UIAlertViewDelegate>

@end

@implementation EazesportzInApAdListViewController {
    EazesportzRetrieveInAppAdProducts *getProducts;
    PlayerSelectionViewController *playerController;
    NSIndexPath *selectedIndex;
    
    NSArray *skproducts;
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
    
    getProducts = [[EazesportzRetrieveInAppAdProducts alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([SKPaymentQueue canMakePayments]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotProducts:) name:@"InAppProductsChangedNotification" object:nil];
        [getProducts retrieveProducts];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please enable In App Purchase in Settings" delegate:self
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotProducts:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [self validateProductIdentifiers:getProducts.products];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieving ad products" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)validateProductIdentifiers:(NSMutableArray *)productIdentifiers {
    NSMutableArray *productarray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < productIdentifiers.count; i++) {
        [productarray addObject:[[productIdentifiers objectAtIndex:i] productid]];
    }
    
    NSSet *productset = [[NSSet alloc] initWithArray:productarray];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productset];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    skproducts = response.products;
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
    }
        
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    [skproducts sortedArrayUsingDescriptors:descriptors];

    [_inappAdLevelTable reloadData]; // Custom method
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [_inappAdLevelTable indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"AdvertisementSegue"]) {
        currentSettings.purchaseController = segue.destinationViewController;
        currentSettings.purchaseController.storekitProduct = [skproducts objectAtIndex:indexPath.row];
        currentSettings.purchaseController.sponsor = nil;
        
        for (int i = 0; i < getProducts.products.count; i++) {
            if ([[[getProducts.products objectAtIndex:i] productid] isEqualToString:[[skproducts objectAtIndex:indexPath.row] productIdentifier]]) {
                currentSettings.purchaseController.adproduct = [getProducts.products objectAtIndex:i];
                break;
            }
        }
    } else if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerController = segue.destinationViewController;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return skproducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InAppAdTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SKProduct *product = [skproducts objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    cell.textLabel.text = product.localizedTitle;
    cell.detailTextLabel.text = [product.price stringValue];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
        cell.imageView.image = [self getProductImage:product.productIdentifier Size:@"tiny"];
    else
        cell.imageView.image = [self getProductImage:product.productIdentifier Size:@"thumb"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Available Ad Levels - %@", currentSettings.team.mascot];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIImage *)getProductImage:(NSString *)productid Size:(NSString *)size {
    UIImage *image = nil;
    
    for (int i = 0; i < getProducts.products.count; i++) {
        if ([[[getProducts.products objectAtIndex:i] productid] isEqualToString:productid]) {
            
            if (([size isEqualToString:@"tiny"]) &&
                (![[[getProducts.products objectAtIndex:i] tinyurl] isEqualToString:@"/iosadimages/tiny/missing.png"])) {
                    image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:
                                                    [NSURL URLWithString:[[getProducts.products objectAtIndex:i] tinyurl]]]];
            } else if (([size isEqualToString:@"thumb"]) &&
                       (![[[getProducts.products objectAtIndex:i] thumburl] isEqualToString:@"/iosadimages/thumb/missing.png"])) {
                image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:
                                                [NSURL URLWithString:[[getProducts.products objectAtIndex:i] thumburl]]]];
            }
            
            break;
        }
    }
    
    return image;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Ok"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
