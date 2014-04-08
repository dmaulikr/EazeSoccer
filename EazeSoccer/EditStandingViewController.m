//
//  EditStandingViewController.m
//  Basketball Console
//
//  Created by Gil on 10/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "EditStandingViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "sportzCurrentSettings.h"

@interface EditStandingViewController ()

@end

@implementation EditStandingViewController

@synthesize standing;

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
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
        self.view.backgroundColor = [UIColor clearColor];
    else
        self.view.backgroundColor = [UIColor whiteColor];
    
    _leagueWinsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _leagueLossesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _nonleagueWinsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _nonleagueLossesTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _leagueLossesTextField.text = [standing.leaguelosses stringValue];
    _leagueWinsTextField.text = [standing.leaguewins stringValue];
    _nonleagueLossesTextField.text = [standing.nonleaguelosses stringValue];
    _nonleagueWinsTextField.text = [standing.nonleaguewins stringValue];
    _teamNameLabel.text = standing.teamname;
    
    if (standing.oppimageurl.length > 0) {
        NSURL * imageURL = [NSURL URLWithString:standing.oppimageurl];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        _teamImage.image = [UIImage imageWithData:imageData];
    } else {
        _teamImage.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    
    if ((standing.teamid == [NSNull null]) && (standing.sportid == [NSNull null])) {
        _importButton.hidden = YES;
        _importButton.enabled = NO;
        _importMessageLabel.hidden = YES;
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    Standings *newstanding = standing;
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    newstanding.leaguewins = [f numberFromString:_leagueWinsTextField.text];
    newstanding.leaguelosses = [f numberFromString:_leagueLossesTextField.text];
    newstanding.nonleaguewins = [f numberFromString:_nonleagueWinsTextField.text];
    newstanding.nonleaguelosses = [f numberFromString:_nonleagueLossesTextField.text];
    newstanding.teamid = standing.teamid;
    newstanding.gameschedule_id = standing.gameschedule_id;
    newstanding.sportid = standing.sportid;
    newstanding.oppimageurl = standing.oppimageurl;
    
    NSURL *aurl = [NSURL URLWithString:[sportzServerInit updateTeamStanding:newstanding Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180];
    NSError *jsonSerializationError = nil;
    
    NSMutableDictionary *standingDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:standing.gameschedule_id, @"gameschedule_id",
                                         [standing.leaguelosses stringValue], @"league_losses", [standing.leaguewins stringValue], @"league_wins",
                                         [standing.nonleaguelosses stringValue], @"nonleague_losses", [standing.nonleaguewins stringValue],
                                         @"nonleague_wins", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:standingDict options:0 error:&jsonSerializationError];
    
    if (jsonSerializationError) {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"PUT"];
    
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *standingData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if ([httpResponse statusCode] == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Opposing Team Record Updated!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[standingData objectForKey:@"error"]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)importButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:[sportzServerInit importTeamStanding:standing.gameschedule_id Token:currentSettings.user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *standingData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if ([httpResponse statusCode] == 200) {
        NSDictionary *gamerecord = [standingData objectForKey:@"gameschedule"];
        _leagueLossesTextField.text = [[gamerecord objectForKey:@"opponent_league_losses"] stringValue];
        _leagueWinsTextField.text = [[gamerecord objectForKey:@"opponent_league_wins"] stringValue];
        _nonleagueLossesTextField.text = [[gamerecord objectForKey:@"opponent_nonleague_losses"] stringValue];
        _nonleagueWinsTextField.text = [[gamerecord objectForKey:@"opponent_nonleague_wins"] stringValue];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Opppsing Eazesport team record imported"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Problem import opppsing Eazesport team record"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];

    if (myStringMatchesRegEx)
        return YES;
    else
        return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
