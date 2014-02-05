//
//  SelectSiteTableViewController.h
//  Eazebasketball
//
//  Created by Gil on 9/30/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSiteTableViewController : UITableViewController

@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *zipcode;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, strong) NSString *sitename;
@property(nonatomic, strong) NSString *sportname;

@property (strong, nonatomic) IBOutlet UITableView *siteTableView;

@end
