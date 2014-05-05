//
//  EazesportzSponsorProductsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSponsorProductsViewController.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzSponsorProductsViewController ()

@end

@implementation EazesportzSponsorProductsViewController {
    BOOL showBanner;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    showBanner = NO;
    _bannerImage.hidden = YES;
    _bannerText.hidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (IBAction)bannerAdExampleButtonClicked:(id)sender {
    if (showBanner) {
        _bannerImage.hidden = YES;
        _bannerText.hidden = YES;
        showBanner = NO;
    } else {
        _bannerImage.hidden = NO;
        _bannerText.hidden = NO;
        showBanner = YES;
        
        _bannerText.text = [NSString stringWithFormat:@"%@ - proud sponsor", currentSettings.sport.sitename];
        
        if ([currentSettings.sport.name isEqualToString:@"Football"]) {
            [_bannerImage setImage:[UIImage imageNamed:@"football-field.png"]];
        } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
            [_bannerImage setImage:[UIImage imageNamed:@"bballongymfloor.png"]];
        } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
            [_bannerImage setImage:[UIImage imageNamed:@"Soccerbanner.png"]];
        }
    }
}

@end
