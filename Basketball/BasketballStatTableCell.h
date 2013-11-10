//
//  PlayerStatTableCell.h
//  Basketball Console
//
//  Created by Gil on 9/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasketballStatTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerImage;

@property (weak, nonatomic) IBOutlet UILabel *fgmLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgaLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgpLabel;
@property (weak, nonatomic) IBOutlet UILabel *threepaLabel;
@property (weak, nonatomic) IBOutlet UILabel *threepmLabel;
@property (weak, nonatomic) IBOutlet UILabel *threepctLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftmLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftaLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftpctLabel;
@property (weak, nonatomic) IBOutlet UILabel *foulLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@end
