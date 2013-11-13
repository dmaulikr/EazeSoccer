//
//  RosterTableCell.h
//  EazeSoccer
//
//  Created by Gil on 10/31/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RosterTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rosterImage;
@property (weak, nonatomic) IBOutlet UILabel *playernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alertImage;

@end
