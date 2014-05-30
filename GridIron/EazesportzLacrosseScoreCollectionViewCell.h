//
//  EazesportzLacrosseScoreCollectionViewCell.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/27/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, TLGridBorder) {
    TLGridBorderNone = 0,
    TLGridBorderTop = 1 << 0,
    TLGridBorderRight = 1 << 1,
    TLGridBorderBottom = 1 << 2,
    TLGridBorderLeft = 1 << 3,
    TLGridBorderAll = TLGridBorderTop | TLGridBorderRight | TLGridBorderBottom | TLGridBorderLeft,
};

@interface EazesportzLacrosseScoreCollectionViewCell : UICollectionViewCell

@property (nonatomic) TLGridBorder border;

@property (weak, nonatomic) IBOutlet UILabel *timetypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalassistLabel;
@end
