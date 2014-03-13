//
//  EazeFeaturedPhotosViewController.h
//  EazeSportz
//
//  Created by Gil on 1/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazeFeaturedPhotosViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *videoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photosButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@end
