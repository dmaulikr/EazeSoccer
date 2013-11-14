//
//  FindPlayerViewController.h
//  EazeSoccer
//
//  Created by Gil on 10/31/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;

-(IBAction)backGroundTap:(id)sender;
@end
