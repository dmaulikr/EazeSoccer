//
//  EazeWebViewController.h
//  EazeSportz
//
//  Created by Gil on 3/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazeWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSURL *external_url;

@end
