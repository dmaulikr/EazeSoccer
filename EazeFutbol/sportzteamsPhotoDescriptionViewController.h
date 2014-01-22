//
//  sportzteamsPhotoDescriptionViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Photo.h"

@interface sportzteamsPhotoDescriptionViewController : UIViewController

@property(nonatomic, strong) Photo *photo;
@property (weak, nonatomic) IBOutlet UILabel *photoNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *photoDescriptionText;
@property (weak, nonatomic) IBOutlet UITableView *playerTableView;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
- (IBAction)gameButtonClicked:(id)sender;

@end
