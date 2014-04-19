//
//  EazesportzManageUsersViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazesportzManageUsersViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *usersSelectContainer;

- (IBAction)selectUser:(UIStoryboardSegue *)segue;

@end
