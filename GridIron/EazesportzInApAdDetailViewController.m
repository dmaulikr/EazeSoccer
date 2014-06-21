//
//  EazesportzInApAdDetailViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzInApAdDetailViewController.h"
#import "PlayerSelectionViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeEditSponsorViewController.h"

#import <CommonCrypto/CommonCrypto.h>

@interface EazesportzInApAdDetailViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzInApAdDetailViewController {
    PlayerSelectionViewController *playerController;
}

@synthesize adproduct;
@synthesize storekitProduct;
@synthesize sponsor;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _playerSelectContainer.hidden = YES;
    _playerLabel.text = @"";
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    if (adproduct.playerad) {
        _selectPlayerButton.hidden = NO;
        _selectPlayerButton.enabled = YES;
    } else {
        _selectPlayerButton.hidden = YES;
        _selectPlayerButton.enabled = NO;
    }
    
    if (![adproduct.thumburl isEqualToString:@"/iosadimages/thumb/missing.png"])
        _productImageView.image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:adproduct.thumburl]]];
    
    _productTitle.text = storekitProduct.localizedTitle;
    _descriptionLabel.text = storekitProduct.localizedDescription;
    _priceLabel.text = [storekitProduct.price stringValue];
    
    if (sponsor) {
        [self requestPayment];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"SponsorInfoSegue"]) {
        EazeEditSponsorViewController *destController = segue.destinationViewController;
        destController.storekitProduct = storekitProduct;
        destController.adproduct = adproduct;
        
        if (adproduct.playerad)
            destController.player = playerController.player;
        else
            destController.player = nil;
    }
}

- (IBAction)selectPlayerButtonClicked:(id)sender {
    _playerSelectContainer.hidden = NO;
    playerController.player = nil;
    [playerController viewWillAppear:YES];
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    _playerSelectContainer.hidden = YES;
    
    if (playerController.player) {
        _playerLabel.text = playerController.player.numberLogname;
    }
}

- (void)requestPayment {
    NSString *useremail = [self hashedValueForAccountName:currentSettings.user.email];
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:storekitProduct];
    payment.applicationUsername = useremail;
    payment.quantity = 1;
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method.
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                [currentSettings.sponsors retrieveSponsors:currentSettings.sport.id Token:currentSettings.user.authtoken];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                    message:[NSString stringWithFormat:@"Ad Purchased! Thank you for supporting %@", currentSettings.sport.sitename]
                                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"Transaction Failed= %@", transaction.error);
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [sponsor deleteSponsor];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Purchase failed!" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// Custom method to calculate the SHA-256 hash using Common Crypto
- (NSString *)hashedValueForAccountName:(NSString*)userAccountName {
    const int HASH_SIZE = 32;
    unsigned char hashedChars[HASH_SIZE];
    const char *accountName = [userAccountName UTF8String];
    size_t accountNameLen = strlen(accountName);
    
    // Confirm that the length of the user name is small enough
    // to be recast when calling the hash function.
    if (accountNameLen > UINT32_MAX) {
        NSLog(@"Account name too long to hash: %@", userAccountName);
        return nil;
    }
    CC_SHA256(accountName, (CC_LONG)accountNameLen, hashedChars);
    
    // Convert the array of bytes into a string showing its hex representation.
    NSMutableString *userAccountHash = [[NSMutableString alloc] init];
    for (int i = 0; i < HASH_SIZE; i++) {
        // Add a dash every four bytes, for readability.
        if (i != 0 && i%4 == 0) {
            [userAccountHash appendString:@"-"];
        }
        [userAccountHash appendFormat:@"%02x", hashedChars[i]];
    }
    
    return userAccountHash;
}

- (IBAction)purchaseButtonClicked:(id)sender {
    if ((adproduct.playerad) && (!playerController.player)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please sleect the player you want to sponsor." delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self performSegueWithIdentifier:@"SponsorInfoSegue" sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Cancel"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
