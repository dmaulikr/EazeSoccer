//
//  FullUserViewController.h
//  EazeSportz
//
//  Created by Gil on 11/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UsersViewController.h"

@interface FullUserViewController : UsersViewController

@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (weak, nonatomic) IBOutlet UIView *searchUserContainer;

@end
