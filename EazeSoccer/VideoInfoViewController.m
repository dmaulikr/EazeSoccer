//
//  VideoInfoViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/7/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "ShuffleAlphabet.h"

#import "PlayerSelectionViewController.h"
#import "EditPlayerViewController.h"
#import "EditUserViewController.h"
#import "EditGameViewController.h"
#import "EditTeamViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,
                                        AmazonServiceRequestDelegate, UIAlertViewDelegate>

@end

@implementation VideoInfoViewController{
    PlayerSelectionViewController *playerSelectController;
    
    BOOL newVideo, newmedia, videoselected;
    int videosize;
    NSString *videopath, *moviePath;
    User *user;
    
    GameSchedule *selectedgame;
    
    NSMutableArray *addtags, *removetags;
}


@synthesize video;
@synthesize gameController;

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
    self.view.backgroundColor = [UIColor clearColor];
/*    _cameraButton.layer.cornerRadius = 4;
    _cameraButton.backgroundColor = [UIColor greenColor];
    _cameraRollButton.layer.cornerRadius = 4;
    _cameraRollButton.backgroundColor = [UIColor greenColor];
    _deleteButton.layer.cornerRadius = 4;
    _deleteButton.backgroundColor = [UIColor redColor];
    _teamButton.layer.cornerRadius = 4;
    _gameButton.layer.cornerRadius = 4;
    _gameButton.backgroundColor = [UIColor whiteColor];
 */
    _gameTextField.inputView = gameController.inputView;
//    _gameplayTextField.inputView = gameplaySelectController.inputView;
    _activityIndicator.hidesWhenStopped = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    addtags = [[NSMutableArray alloc] init];
    removetags = [[NSMutableArray alloc] init];
    
    if ((video) && (!newVideo)) {
        newVideo = NO;
        _cameraRollButton.hidden = YES;
        _cameraRollButton.enabled = NO;
        _cameraButton.hidden = YES;
        _cameraButton.enabled = NO;
        
        if (video.poster_url.length > 0) {
            NSURL * imageURL = [NSURL URLWithString:video.poster_url];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            _videoImageView.image = [UIImage imageWithData:imageData];
        } else {
            _videoImageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
        }
        
        _videoDescriptionTextView.text = video.description;
        _videoNameTextField.text = video.displayName;
        
        NSURL *url = [NSURL URLWithString:[sportzServerInit getAUser:video.userid Token:currentSettings.user.authtoken]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
        NSDictionary *userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        if (responseStatusCode == 200) {
            user = [[User alloc] init];
            user.userid = [userdata objectForKey:@"id"];
            user.username = [userdata objectForKey:@"name"];
            user.email = [userdata objectForKey:@"email"];
            user.authtoken = [userdata objectForKey:@"authentication_token"];
            user.userthumb = [userdata objectForKey:@"avatar"];
            user.tiny = [userdata objectForKey:@"tiny"];
            user.isactive = [NSNumber numberWithInteger:[[userdata objectForKey:@"is_active"] integerValue]];
            user.bio_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"bio_alert"] integerValue]];
            user.blog_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"blog_alert"] integerValue]];
            user.media_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"media_alert"] integerValue]];
            user.stat_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"stat_alert"] integerValue]];
            user.score_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"score_alert"] integerValue]];
            user.admin = [NSNumber numberWithInteger:[[userdata objectForKey:@"admin"] integerValue]];
            
            [_userButton setTitle:user.username forState:UIControlStateNormal];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving User"
                                                            message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        if (video.schedule.length > 0) {
            video.game = [currentSettings findGame:video.schedule];
            _gameTextField.text = video.game.game_name;
//            _gameButton.backgroundColor = [UIColor greenColor];
            [_gameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _gameButton.enabled = YES;
        } else {
            _gameButton.enabled = NO;
//            _gameButton.backgroundColor = [UIColor redColor];
            [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
    } else if (!newVideo) {
        video = [[Video alloc] init];
        newVideo = YES;
        _deleteButton.enabled = NO;
        _deleteButton.hidden = YES;
        _playButton.enabled = NO;
        _videoNameTextField.text = @"";
        _videoDescriptionTextView.text = @"";
        user = currentSettings.user;
        [_userButton setTitle:currentSettings.user.username forState:UIControlStateNormal];
        _videoImageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"uploadmovie.png"], 1)];
        _gameButton.enabled = NO;
        [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        video.userid = currentSettings.user.userid;
    }
    
    _teamTextField.text = currentSettings.team.team_name;
    
    _gameSelectContainer.hidden = YES;
    _playerSelectContainer.hidden = YES;
}

- (IBAction)submitButtonClicked:(id)sender {
    if (newVideo) {
        // Upload photo before storing data
        [self uploadImage:video];
    } else {
        NSURL *aurl = [NSURL URLWithString:[sportzServerInit getVideo:video.videoid Token:currentSettings.user.authtoken]];
        
        NSMutableDictionary *videoDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: _videoNameTextField.text, @"displayname",
                      _videoDescriptionTextView.text, @"description", currentSettings.team.teamid, @"team_id", nil];
        
        if (video.schedule.length > 0)
            [videoDict setObject:video.schedule forKey:@"gameschedule_id"];
        
        if (video.gamelog.length > 0)
            [videoDict setObject:video.gamelog forKey:@"gamelog_id"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:videoDict, @"videoclip", nil];
        
        NSError *jsonSerializationError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:nil error:&jsonSerializationError];
        
        if (!jsonSerializationError) {
            NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"Serialized JSON: %@", serJson);
        } else {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody:jsonData];
        
        //Capturing server response
        NSURLResponse* response;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
        NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
        NSLog(@"%@", serverData);
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([httpResponse statusCode] == 200) {
            NSDictionary *items = [serverData objectForKey:@"videoclip"];
            
            if (addtags.count > 0) {
                [self addVideoTags:video];
            }
            
            if (removetags.count > 0) {
                [self removeVideoTags:video];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update sucessful!"
                                                            message:@"Video Clip updated"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating Video data"
                                                            message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [video.athletes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Athlete *athlete = [video.athletes objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.textLabel.text = athlete.full_name;
    cell.imageView.image = [athlete getImage:@"tiny"];
    cell.detailTextLabel.text = athlete.position;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Players";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Add to remove tag array
        BOOL remtag = YES;
        if (removetags.count > 0) {
            for (int cnt = 0; cnt < removetags.count; cnt++) {
                if ([[[removetags objectAtIndex:cnt] athleteid] isEqualToString:[[video.athletes objectAtIndex:indexPath.row] athleteid]]) {
                    remtag = NO;
                    break;
                }
            }
        }
        if (remtag)
            [removetags addObject:[video.athletes objectAtIndex:indexPath.row]];
        
        // Remove from add tag array
        for (int cnt = 0; cnt < addtags.count; cnt++) {
            if ([[[addtags objectAtIndex:cnt] athleteid] isEqualToString:[[video.athletes objectAtIndex:indexPath.row] athleteid]]) {
                [addtags removeObjectAtIndex:cnt];
                break;
            }
        }
        
        [video.athletes removeObjectAtIndex:indexPath.row];
    }
    [_playerTableView reloadData];
}

- (IBAction)playerButtonClicked:(id)sender {
    _playerSelectContainer.hidden = NO;
    playerSelectController.player = nil;
    [playerSelectController viewWillAppear:YES];
}

- (IBAction)playButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:video.video_url];
    
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:)
                                          name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
}

- (IBAction)gameSelected:(UIStoryboardSegue *)segue {
    if (gameController.thegame) {
        _gameTextField.text = gameController.thegame.game_name;
        video.schedule = gameController.thegame.id;
        video.game = gameController.thegame;
        _gameButton.enabled = YES;
//        _gameButton.backgroundColor = [UIColor greenColor];
        [_gameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
//        _gameButton.backgroundColor = [UIColor whiteColor];
        [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _gameButton.enabled = NO;
        _gameTextField.text = @"";
    }
    _gameSelectContainer.hidden = YES;
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    if (playerSelectController.player) {
        BOOL insert = YES;
        for (int i = 0; i < video.athletes.count; i++) {
            if ([[[video.athletes objectAtIndex:i] athleteid] isEqualToString:playerSelectController.player.athleteid]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Athlete already tagged"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                insert = NO;
            }
        }
        if (insert) {
            [video.athletes addObject:playerSelectController.player];
            BOOL addthetag = YES;
            
            // Add athlete to add tag array
            if (addtags.count > 0) {
                for (int cnt = 0; cnt < [addtags count]; cnt++) {
                    if ([[[addtags objectAtIndex:cnt] athleteid] isEqualToString:playerSelectController.player.athleteid]) {
                        addthetag = NO;
                        break;
                    }
                }
            }
            if (addthetag)
                [addtags addObject:playerSelectController.player];
            
            // Remove the tag from remove tag array if
            if (removetags.count > 0) {
                for (int cnt = 0; cnt < removetags.count; cnt++) {
                    if ([[[removetags objectAtIndex:cnt] athleteid] isEqualToString:playerSelectController.player.athleteid]) {
                        [removetags removeObjectAtIndex:cnt];
                        break;
                    }
                }
            }
        }
    }
    _playerSelectContainer.hidden = YES;
    [_playerTableView reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _gameTextField) {
        [textField resignFirstResponder];
        gameController.thegame = nil;
        _gameSelectContainer.hidden = NO;
        [gameController viewWillAppear:YES];
    } else if (textField == _teamTextField) {
        [textField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _teamTextField) {
        return NO;
    } else
        return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        NSIndexPath *indexPath = _playerTableView.indexPathForSelectedRow;
        EditPlayerViewController *destController = segue.destinationViewController;
        destController.player = [video.athletes objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameInfoSegue"]) {
        EditGameViewController *destController = segue.destinationViewController;
        destController.game = video.game;
    } else if ([segue.identifier isEqualToString:@"UserInfoSegue"]) {
        EditUserViewController *destController = segue.destinationViewController;
        destController.theuser = user;
    } else if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TeamInfoSegue"]) {
        EditTeamViewController *destController = segue.destinationViewController;
        destController.team = currentSettings.team;
    }
}

- (void)addVideoTags:(Video *)avideo {
    NSURL *aurl = [NSURL URLWithString:[sportzServerInit tagAthletesVideo:video Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    NSMutableDictionary *tagDict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [addtags count]; i++) {
        [tagDict setObject:[[addtags objectAtIndex:i] athleteid] forKey:[[addtags objectAtIndex:i] logname]];
    }
    
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:tagDict, @"videoclip", nil];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&jsonSerializationError];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    if ([httpResponse statusCode] != 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating videoclip data" message:[json objectForKey:@"error"]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)removeVideoTags:(Video *)avideo {
    NSURL *aurl = [NSURL URLWithString:[sportzServerInit untagAthletesVideo:video Token:currentSettings.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    NSMutableDictionary *tagDict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [removetags count]; i++) {
        [tagDict setObject:[[removetags objectAtIndex:i] athleteid] forKey:[[removetags objectAtIndex:i] logname]];
    }
    
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:tagDict, @"videoclip", nil];
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&jsonSerializationError];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    if ([httpResponse statusCode] != 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating videoclip data"
                                                        message:[json objectForKey:@"error"]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (BOOL)uploadImage:(Video *)avideo {
    if ((videoselected) && (_videoNameTextField.text.length > 0)) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [_activityIndicator startAnimating];

        // Upload video.  Remember to set the content type.
        NSString *randomstr = [[ShuffleAlphabet alloc] shuffledAlphabet];
        NSString *selvideopath = [NSString stringWithFormat:@"%@%@%@%@%@", [[currentSettings getBucket] name], @"/uploads/videos/",
                               currentSettings.team.teamid, @"_", randomstr];
        videopath = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"uploads/videos/", currentSettings.team.teamid, @"_", randomstr, @"/",
                     _videoNameTextField.text];
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:_videoNameTextField.text inBucket:selvideopath];
        por.contentType = @"video/mp4";
        
 /*
        //FIXING ORIENTATION//
        NSURL *url = [NSURL fileURLWithPath:moviePath];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
        
        AVMutableCompositionTrack *track = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                preferredTrackID:kCMPersistentTrackID_Invalid];
        [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
                
        AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        AVMutableVideoCompositionLayerInstruction *instruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:track];
        AVAssetTrack *firstAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation firstAssetOrientation_  = UIImageOrientationUp;
        BOOL isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = firstAssetTrack.preferredTransform;
        if (firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0) {
            firstAssetOrientation_ = UIImageOrientationRight;
            isFirstAssetPortrait_ = YES;
        }
        if (firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0) {
            firstAssetOrientation_ =  UIImageOrientationLeft;
            isFirstAssetPortrait_ = YES;
        }
        if (firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0) {
            firstAssetOrientation_ =  UIImageOrientationUp;
        }
        if (firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {
            firstTransform.a = 1.0;
            firstTransform.d = 1.0;
            firstAssetOrientation_ = UIImageOrientationDown;
        }
//        [instruction setTransform:asset.preferredTransform atTime:kCMTimeZero];

        CGFloat FirstAssetScaleToFitRatio = 640.0/firstAssetTrack.naturalSize.width;
        
        if (isFirstAssetPortrait_) {
            FirstAssetScaleToFitRatio = 640.0/firstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [instruction setTransform:CGAffineTransformConcat(firstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        } else {
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [instruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(firstTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
//        [firstlayerInstruction setOpacity:0.0 atTime:asset.duration];
        mainInstruction.layerInstructions = [NSArray arrayWithObjects:instruction, nil];
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        mainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
        
        NSURL *aurl = [NSURL fileURLWithPath:myPathDocs];
        
        CGSize naturalSizeFirst, naturalSizeSecond;
        if(isFirstAssetPortrait_){
            naturalSizeFirst = CGSizeMake(firstAssetTrack.naturalSize.height, firstAssetTrack.naturalSize.width);
        } else {
            naturalSizeFirst = firstAssetTrack.naturalSize;
        }
        
        float renderWidth, renderHeight;
        if(naturalSizeFirst.width > naturalSizeSecond.width) {
            renderWidth = naturalSizeFirst.width;
        } else {
            renderWidth = naturalSizeSecond.width;
        }
        if(naturalSizeFirst.height > naturalSizeSecond.height) {
            renderHeight = naturalSizeFirst.height;
        } else {
            renderHeight = naturalSizeSecond.height;
        }
        mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight); 
 
        // 5 - Create exporter
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=aurl;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        exporter.videoComposition = mainCompositionInst;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self exportDidFinish:exporter];
            });
        }];
*/
        
        NSData *videoData = [NSData dataWithContentsOfFile:moviePath];
        por.data = videoData;
        videosize = videoData.length;
//        por.contentLength = videosize;
        por.delegate = self;
        
        // Put the image data into the specified s3 bucket and object.
        [[currentSettings getS3] putObject:por]; 
 
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must select a video and give it a name!" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return NO;
    }
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
//                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
                        NSLog(@"Transformed Video");
                        // Upload video.  Remember to set the content type.
                        NSString *randomstr = [[ShuffleAlphabet alloc] shuffledAlphabet];
                        NSString *selvideopath = [NSString stringWithFormat:@"%@%@%@%@%@", [[currentSettings getBucket] name],
                                                  @"/uploads/videos/",
                                                  currentSettings.team.teamid, @"_", randomstr];
                        videopath = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"uploads/videos/", currentSettings.team.teamid,
                                     @"_", randomstr, @"/", _videoNameTextField.text];
                        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:_videoNameTextField.text inBucket:selvideopath];
                        por.contentType = @"video/mp4";
                        NSData *videoData = [NSData dataWithContentsOfFile:moviePath];
                        por.data = videoData;
                        videosize = videoData.length;
                        //        por.contentLength = videosize;
                        por.delegate = self;
                        
                        // Put the image data into the specified s3 bucket and object.
                        [[currentSettings getS3] putObject:por]; 
                    }
                });
            }];
        }
    }
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    [_activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSURL *url = [NSURL URLWithString:[sportzServerInit newVideo:currentSettings.user.authtoken]];
    NSMutableDictionary *photoDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: _videoNameTextField.text, @"filename",
                                       _videoNameTextField.text, @"displayname", videopath, @"filepath", @"image/mp4", @"filetype",
                                       [NSString stringWithFormat:@"%d", videosize], @"filesize", _videoDescriptionTextView.text, @"description",
                                       currentSettings.team.teamid, @"team_id", currentSettings.user.userid, @"user_id", nil];
    
    if (gameController.thegame) {
        [photoDict setObject:gameController.thegame.id forKey:@"gameschedule_id"];
        
//        if (gameplaySelectController.play)
//            [photoDict setObject:gameplaySelectController.play.gamelogid forKey:@"gamelog_id"];
    }
    
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:photoDict, @"videoclip", nil];
    
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* urlresponse;
    NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)urlresponse;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([httpResponse statusCode] == 200) {
        NSDictionary *items = [serverData objectForKey:@"videoclip"];
        video = [[Video alloc] initWithDirectory:items];
        
        if (newVideo) {
            video.videoid= [items objectForKey:@"_id"];
             newVideo = NO;
        }
        if (addtags.count > 0) {
            [self addVideoTags:video];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload sucessful!"
                                                        message:@"Video uploaded"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error uploading video"
                                                        message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Upload Error" delegate:nil
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
    [_activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (IBAction)cameraRollButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        imagePicker.allowsEditing = NO;
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        _popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        _popover.delegate = self;
        
        // set contentsize
        [_popover setPopoverContentSize:CGSizeMake(220,300)];
        
        [_popover presentPopoverFromRect:CGRectMake(700,1000,10,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)cameraButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeMovie];
        imagePicker.allowsEditing = NO;
        newmedia = YES;
        _popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        _popover.delegate = self;
        
        // set contentsize
        [_popover setPopoverContentSize:CGSizeMake(220,300)];
        
        [_popover presentPopoverFromRect:CGRectMake(700,1000,10,10) inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [_popover dismissPopoverAnimated:YES];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        // Code here to support video if enabled
        videoselected = YES;
        moviePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        _videoImageView.image = (UIImage*) [info objectForKey:UIImagePickerControllerOriginalImage];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:moviePath];
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
//       _videoImageView.image = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
        generate1.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 2);
        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
        [_videoImageView setImage:one];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [player stop];
    }
}

-(void)image:(UIImage *)imag finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save video"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (IBAction)selectVideoClipPlayEdit:(UIStoryboardSegue *)segue {
    if (gameplaySelectController.play) {
        _gameplayTextField.text = gameplaySelectController.play.logentry;
        video.gamelog = gameplaySelectController.play.gamelogid;
    } else {
        _gameplayTextField.text = @"";
        video.gamelog = @"";
        
    }
    _gameplaySelectContainer.hidden = YES;
}
*/
- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Video Clip?"
                                                    message:@"All video tags will also be deleted!"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        NSURL *url = [NSURL URLWithString:[sportzServerInit deleteVideo:video.videoid Token:currentSettings.user.authtoken]];
        NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
        NSDictionary *jsonDict = [[NSDictionary alloc] init];
        NSError *jsonSerializationError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
        
        if (!jsonSerializationError) {
            NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"Serialized JSON: %@", serJson);
        } else {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [urlrequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [urlrequest setHTTPMethod:@"DELETE"];
        [urlrequest setHTTPBody:jsonData];
        
        //Capturing server response
        NSURLResponse* urlresponse;
        NSData* result = [NSURLConnection sendSynchronousRequest:urlrequest  returningResponse:&urlresponse error:&jsonSerializationError];
        NSMutableDictionary *photoDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)urlresponse;
        if ([httpResponse statusCode] == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Video"
                                                            message:[photoDict objectForKey:@"error"]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

@end
