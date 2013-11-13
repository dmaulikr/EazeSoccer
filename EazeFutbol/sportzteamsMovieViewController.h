//
//  sportzteamsMovieViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Video.h"

@interface sportzteamsMovieViewController : UIViewController

@property(nonatomic, strong) Video *videoclip;
@property(nonatomic, strong) NSString *videoid;

- (IBAction)playButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
