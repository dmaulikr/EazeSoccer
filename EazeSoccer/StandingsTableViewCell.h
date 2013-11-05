//
//  StandingsTableViewCell.h
//  Basketball Console
//
//  Created by Gil on 10/22/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandingsTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *teamImage;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallLabel;
@property (weak, nonatomic) IBOutlet UILabel *leagueLabel;

@end
