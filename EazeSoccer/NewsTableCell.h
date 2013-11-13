//
//  NewsTableCell.h
//  EazeSportz
//
//  Created by Gil on 11/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *athleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *coachLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerdisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *coachdisplayLabel;

@end
