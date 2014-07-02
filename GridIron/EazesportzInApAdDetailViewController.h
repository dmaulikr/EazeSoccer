//
//  EazesportzInApAdDetailViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "InAppProducts.h"
#import "Sponsor.h"

@interface EazesportzInApAdDetailViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) InAppProducts *adproduct;
@property (nonatomic, strong) SKProduct *storekitProduct;
@property (nonatomic, strong) Sponsor *sponsor;

@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectPlayerButton;
- (IBAction)selectPlayerButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;

- (IBAction)playerSelected:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
- (IBAction)purchaseButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;

@end
