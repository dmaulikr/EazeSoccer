//
//  EazesportzCheckAdImageViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sponsor.h"

@interface EazesportzCheckAdImageViewController : UIViewController

@property (nonatomic, strong) Sponsor *sponsor;

@property (weak, nonatomic) IBOutlet UIImageView *sponsorAdImage;
@property (weak, nonatomic) IBOutlet UILabel *adLabel;
@end
