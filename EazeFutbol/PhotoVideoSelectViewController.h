//
//  sportzteamsPhotoVideoSelectViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface PhotoVideoSelectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *selectSegmentControl;
- (IBAction)selectSegmentClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
- (IBAction)submitButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UITextField *playerTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameTextField;

- (IBAction)selectPhotoVideoPlayer:(UIStoryboardSegue *)segue;
- (IBAction)selectPhotoVideoGame:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;
@property (weak, nonatomic) IBOutlet UIView *gameScheduleContainer;

@end
