//
//  CoachTableCell.h
//  EazeSportz
//
//  Created by Gil on 11/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *coachnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *responsibilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coachImage;
@end
