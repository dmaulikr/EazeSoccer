//
//  HeaderSelectCollectionReusableView.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderSelectCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@end
