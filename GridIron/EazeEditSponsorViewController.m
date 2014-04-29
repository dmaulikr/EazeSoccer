//
//  EazeEditSponsorViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/4/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeEditSponsorViewController.h"
#import "EazesportzSponsorMapViewController.h"
#import "EazesportzCheckAdImageViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazeEditSponsorViewController () <UIGestureRecognizerDelegate>

@end

@implementation EazeEditSponsorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.saveBarButton, self.deleteBarButton, self.globeBarButton, nil];
    self.navigationController.toolbarHidden = YES;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.delegate = self;
    [_scrollView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([currentSettings isSiteOwner]) {
        _catalogButton.hidden = NO;
        _catalogButton.enabled = YES;
    } else {
        _catalogButton.hidden = YES;
        _catalogButton.enabled = NO;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SponsorMapSegue"]) {
        EazesportzSponsorMapViewController *destController = segue.destinationViewController;
        destController.sponsor = self.sponsor;
    } else if ([segue.identifier isEqualToString:@"CheckImageSegue"]) {
        EazesportzCheckAdImageViewController *destController = segue.destinationViewController;
        destController.sponsor = self.sponsor;
    } else
        [super prepareForSegue:segue sender:self];
}


- (IBAction)saveBarButtonClicked:(id)sender {
    [super submitButtonClicked:sender];
}

- (IBAction)deleteBarButonClicked:(id)sender {
    [super deleteButtonClicked:sender];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void) hideKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

@end
