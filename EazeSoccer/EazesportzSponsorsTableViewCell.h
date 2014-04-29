//
//  EazesportzSponsorsTableViewCell.h
//  EazeSportz
//
//  Created by Gil on 1/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazesportzSponsorsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sponsorImage;
@property (weak, nonatomic) IBOutlet UILabel *sponsorName;
@property (weak, nonatomic) IBOutlet UILabel *addrnum;
@property (weak, nonatomic) IBOutlet UILabel *street;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *zip;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *sponsorLevel;
@property (weak, nonatomic) IBOutlet UILabel *sponsorUrl;
@property (weak, nonatomic) IBOutlet UILabel *playerAdLabel;
@end
