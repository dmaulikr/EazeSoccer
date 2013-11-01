//
//  BlogCell.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/22/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *blogTitle;
@property (weak, nonatomic) IBOutlet UIImageView *bloggerImage;
@property (weak, nonatomic) IBOutlet UILabel *bloggerUser;
@property (weak, nonatomic) IBOutlet UITextView *blogEntryTextView;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coachLabel;

@end
