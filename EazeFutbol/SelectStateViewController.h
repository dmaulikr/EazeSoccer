//
//  SelectStateViewController.h
//  Eazebasketball
//
//  Created by Gil on 9/28/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectStateViewController : UIViewController

@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *stateabreviation;

@property (weak, nonatomic) IBOutlet UITableView *stateTableView;

@end
