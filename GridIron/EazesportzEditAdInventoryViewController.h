//
//  EazesportzEditAdInventoryViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/26/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sportadinv.h"

@interface EazesportzEditAdInventoryViewController : UIViewController

@property (nonatomic, strong) Sportadinv *adInventory;

@property (weak, nonatomic) IBOutlet UITextField *adlevelnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UISwitch *forsaleSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *expirationDatePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarButton;
- (IBAction)deleteBarButtonClicked:(id)sender;
- (IBAction)saveBarButtonClicked:(id)sender;
- (IBAction)selectDateButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectDateButton;
@property (weak, nonatomic) IBOutlet UILabel *changePriceLabel;

@end
