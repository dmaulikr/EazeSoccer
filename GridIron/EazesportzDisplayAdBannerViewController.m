//
//  EazesportzDisplayAdBannerViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/27/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzDisplayAdBannerViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzDisplayAdBannerViewController ()

@end

@implementation EazesportzDisplayAdBannerViewController {
    Sponsor *sponsor;
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
    self.view.layer.borderWidth = 1.0f;
    self.view.layer.borderColor = [[UIColor lightGrayColor] CGColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)displayAd {
    sponsor = [currentSettings.sponsors getSponsorAd];
    [self displayAdSponsor];
}

- (void)displayPlayerAd:(Athlete *)player {
    sponsor = [currentSettings.sponsors getPlayerAd:player];
    
    if (sponsor)
        [self displayAdSponsor];
    else {
        sponsor = [currentSettings.sponsors getSponsorAd];
        [self displayAdSponsor];
    }
}

-(void)displayAdSponsor {
    if (sponsor.portraitbanner.length > 0) {
        UIImage *image = [sponsor getPortraitBanner];
        
        if ((image.CIImage == nil) && (image.CGImage == nil)) {
            _fullBannerImageView.hidden = YES;
            
            image = [sponsor bannerImage];
            
            if ((image.CIImage == nil) && (image.CGImage == nil)) {
                _bannerImage.hidden = YES;
                _teamLabel.hidden = YES;
                _sponsorLabel.hidden = YES;
            } else {
                _bannerImage.image = [sponsor bannerImage];
                _teamLabel.text = [NSString stringWithFormat:@"%@ Proud Sponsor", currentSettings.team.mascot];
                _sponsorLabel.text = [NSString stringWithFormat:@"%@", sponsor.name];
            }
        } else {
            _fullBannerImageView.image = image;
            _bannerImage.hidden = YES;
        }
    } else {
        _fullBannerImageView.hidden = YES;
        _bannerImage.image = [sponsor bannerImage];
        _teamLabel.text = [NSString stringWithFormat:@"%@ Proud Sponsor", currentSettings.team.mascot];
        _sponsorLabel.text = [NSString stringWithFormat:@"%@", sponsor.name];
    }
}

- (IBAction)fullBannerButtonClicked:(id)sender {
    if (sponsor.adurl.length > 0)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sponsor.adurl]];
}

@end
