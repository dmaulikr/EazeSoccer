//
//  EazeBasketballScoringTableCell.h
//  EazeSportz
//
//  Created by Gil on 1/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazeBasketballScoringTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldgoalLabel;
@property (weak, nonatomic) IBOutlet UILabel *threefgLabel;
@property (weak, nonatomic) IBOutlet UILabel *freethrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalsLabel;
@end
