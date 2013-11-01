//
//  FindEazesportzSiteViewController.h
//  Basketball Console
//
//  Created by Gil on 10/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sport.h"

@interface FindEazesportzSiteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *sitenameTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITableView *siteTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *stateListPicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)searchButtonClicked:(id)sender;

@property(nonatomic, strong) Sport *sport;

@end
