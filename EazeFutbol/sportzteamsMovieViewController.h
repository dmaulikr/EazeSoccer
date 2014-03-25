//
//  sportzteamsMovieViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <iAd/iAd.h>
#import "Video.h"

@interface sportzteamsMovieViewController : UIViewController

@property(nonatomic, strong) Video *videoclip;
@property(nonatomic, strong) NSString *videoid;

@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
- (IBAction)playButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UILabel *gameButtonLabel;
@property (weak, nonatomic) IBOutlet UITableView *playerTagTableView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
- (IBAction)gameButtonClicked:(id)sender;

@end
