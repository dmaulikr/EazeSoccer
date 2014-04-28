//
//  EazesportzSponsorProductsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazesportzSponsorProductsViewController : UIViewController

- (IBAction)bannerAdExampleButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *bannerText;
@end
