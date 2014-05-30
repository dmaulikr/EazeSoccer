//
//  EazesportzGoalieStatsTableViewCell.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazesportzLacrosseGoalieStatsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalsagainstLabel;
@property (weak, nonatomic) IBOutlet UILabel *decisionLabel;
@property (weak, nonatomic) IBOutlet UILabel *savesLabel;
@end
