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
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@property (weak, nonatomic) IBOutlet UILabel *fgmTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *threefgmTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *threefgaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *threefgpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftmTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsTitleLabel;
@end
