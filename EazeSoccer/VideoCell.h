//
//  VideoCell.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *videoDuration;
@property (weak, nonatomic) IBOutlet UILabel *gametagLabel;
@property (weak, nonatomic) IBOutlet UITableView *playerTagTableView;

@end
