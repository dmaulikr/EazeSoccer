//
//  GameScheduleTableViewCell.h
//  EazeSoccer
//
//  Created by Gil on 10/30/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImageView;
@property (weak, nonatomic) IBOutlet UILabel *hometeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorteamLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeawayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wonlostLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
