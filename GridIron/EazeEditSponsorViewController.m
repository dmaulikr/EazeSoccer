//
//  EazeEditSponsorViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/4/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeEditSponsorViewController.h"

@interface EazeEditSponsorViewController ()

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
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.saveBarButton, self.deleteBarButton, self.infoBarButton, nil];
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)saveBarButtonClicked:(id)sender {
}
- (IBAction)deleteBarButonClicked:(id)sender {
}
- (IBAction)infoBarButtonClicked:(id)sender {
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
