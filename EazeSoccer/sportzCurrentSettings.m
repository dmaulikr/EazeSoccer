 //
//  sportzCurrentSettings.m
//  sportzSoftwareFootball
//
//  Created by Gil on 2/7/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "EazesportzImage.h"
#import "EazesportzRetrieveTeams.h"
#import "EazesportzRetrieveSport.h"

@implementation sportzCurrentSettings {
    AmazonS3Client *s3;
    S3Bucket *s3bucket;
}

@synthesize selectedTab;

@synthesize user;
@synthesize sport;
@synthesize team;
@synthesize game;

@synthesize refreshGames;

@synthesize roster;
@synthesize gameList;
@synthesize teams;
@synthesize sponsors;
@synthesize alerts;

@synthesize rosterimages;
@synthesize opponentimages;

@synthesize lastAlertUpdate;
@synthesize lastGameUpdate;
@synthesize getRoster;

@synthesize footballOL;
@synthesize footballQB;
@synthesize footballRB;
@synthesize footballWR;
@synthesize footballDEF;
@synthesize footballK;
@synthesize footballPK;
@synthesize footballPUNT;
@synthesize footballRET;

@synthesize rootwindow;
@synthesize sitechanged;
@synthesize changesite;
@synthesize firstuse;
@synthesize photodeleted;

@synthesize newuser;

@synthesize teamPhotos;
@synthesize teamVideos;
@synthesize inventorylist;
@synthesize coaches;

- (id)init {
    if (self = [super init]) {
        user = [[User alloc] init];
        sport = [Sport alloc];
        team = [Team alloc];
        
        teamPhotos = [[EazesportzRetrieveFeaturedPhotos alloc] init];
        teamVideos = [[EazesportzRetrieveFeaturedVideosController alloc] init];
        sponsors = [[EazesportzRetrieveSponsors alloc] init];
        inventorylist = [[EazesportzRetrieveSportadinv alloc] init];
        coaches = [[EazesportzRetrieveCoaches alloc] init];
        
        newuser = nil;
        photodeleted = NO;
        
        footballWR = [[NSMutableArray alloc] init];
        footballQB = [[NSMutableArray alloc] init];
        footballRB = [[NSMutableArray alloc] init];
        footballOL = [[NSMutableArray alloc] init];
        footballDEF = [[NSMutableArray alloc] init];
        footballK = [[NSMutableArray alloc] init];
        footballPK = [[NSMutableArray alloc] init];
        footballPUNT = [[NSMutableArray alloc] init];
        footballRET = [[NSMutableArray alloc] init];
        lastAlertUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
        rosterimages = [[NSMutableArray alloc] init];
        opponentimages = [[NSMutableArray alloc] init];
        
        refreshGames = YES;
        
        return self; 
    } else
        return nil;
}

- (UIImage *)getBannerImage {
    UIImage *image;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Soccer"])
        image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"soccerheader.png"], 1)];
    else if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Basketball"])
        image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"bballongymfloor.png"], 1)];
    
    return image;
}

- (Athlete *)findAthlete:(NSString *)athleteid {
    Athlete *result = nil;
    for (int count = 0; count < [roster count]; count++) {
        if ([[[roster objectAtIndex:count] athleteid] isEqualToString:athleteid]) {
            result =  [roster objectAtIndex:count];
        }
    }
    return result;
}

- (Athlete *)findAthleteByLogname:(NSString *)logname {
    Athlete *result = nil;
    for (int count = 0; count < [roster count]; count++) {
        if ([[[roster objectAtIndex:count] logname] isEqualToString:logname]) {
            result =  [roster objectAtIndex:count];
        }
    }
    return result;
}

- (Athlete *)findAthleteByNumber:(NSNumber *)number {
    Athlete *result = nil;
    for (int cnt = 0; cnt < [roster count]; cnt++) {
        if ([[[roster objectAtIndex:cnt] number] intValue] == [number intValue]) {
            result = [roster objectAtIndex:cnt];
        }
    }
    return result;
}

- (NSMutableArray *)findAthleteByPosition:(NSString *)position {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int cnt = 0; cnt < [roster count]; cnt++) {
        Athlete *ath = [roster objectAtIndex:cnt];
        NSArray *listItems = [[ath position] componentsSeparatedByString:@"/"];
        for (int cnt = 0; cnt < [listItems count]; cnt++) {
            NSString *item = [listItems objectAtIndex:cnt];
            if ([item caseInsensitiveCompare:position] == NSOrderedSame) {
                [result addObject:ath];
            }
        }
    }
    return result;
}

- (void)replaceAthleteById:(Athlete *)athlete {
    for (int i = 0; i < roster.count; i++) {
        if ([[[roster objectAtIndex:i] athleteid] isEqualToString:athlete.athleteid]) {
            [roster removeObjectAtIndex:i];
            [roster insertObject:athlete atIndex:i];
            break;
        }
    }
}

- (BOOL)followingAthlete:(NSString *)athleteid {
    for (int cnt = 0; cnt < [roster count]; cnt++) {
        if ([[[roster objectAtIndex:cnt] athleteid] isEqualToString:athleteid]) {
            return YES;
        }
    }
    return NO;
}

- (Coach *)findCoach:(NSString *)coachid {
    Coach *result = nil;
    for (int count = 0; count < [coaches.coaches count]; count++) {
        if ([[[coaches.coaches objectAtIndex:count] coachid] isEqualToString:coachid]) {
            result =  [coaches.coaches objectAtIndex:count];
        }
    }
    return result;
}

- (GameSchedule *)findGame:(NSString *)gamescheduleid {
    GameSchedule *result = nil;
    for (int count = 0; count < [gameList count]; count++) {
        if ([[[gameList objectAtIndex:count] id] isEqualToString:gamescheduleid]) {
            result =  [gameList objectAtIndex:count];
        }
    }
    return result;
}

- (Team *)findTeam:(NSString *)teamid {
    Team *result = nil;
    for (int count = 0; count < [teams count]; count++) {
        if ([[[teams objectAtIndex:count] teamid] isEqualToString:teamid]) {
            result = [teams objectAtIndex:count];
        }
    }
    return  result;
}

- (NSMutableArray *)findAlerts:(NSString *)athleteid {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int count = 0; count < [alerts count]; count++) {
        if ([[[alerts objectAtIndex:count] athlete] isEqualToString:athleteid]) {
            [result addObject:[alerts objectAtIndex:count]];
        }
    }
    return result;
}

- (BOOL)hasAlerts:(NSString *)athleteid {
    for (int cnt = 0; cnt < [alerts count]; cnt++) {
        if ([[[alerts objectAtIndex:cnt] athlete] isEqualToString:athleteid]) {
            return YES;
        }
    }
    return NO;    
}

- (BOOL)addAlert:(Alert *)alert {
    return NO;
}

- (void)deleteAlert:(Alert *)alert {
    for (int cnt = 0; cnt < [alerts count]; cnt++) {
        if ([[[alerts objectAtIndex:cnt] alertid] isEqualToString:[alert alertid]]) {
            [alerts removeObjectAtIndex:cnt];
        }
    }
}

- (void)insertPlayerRoster:(Athlete *)player {
    NSMutableArray *newroster = [[NSMutableArray alloc] init];
    int cnt;
    for (cnt = 0; cnt < [roster count]; cnt++) {
        if ([[player number] intValue] > [[[roster objectAtIndex:cnt] number] intValue])
            [newroster addObject:[roster objectAtIndex:cnt]];
        else {
            [newroster addObject:player];
            break;
        }
    }
    if (cnt < [roster count]) {
        for (int i = cnt; i < [roster count]; i++) {
            [newroster addObject:[roster objectAtIndex:i]];
        }
    } else
        [newroster addObject:player];
    roster = newroster;
}

- (GameSchedule *)retrieveGame:(NSString *)gameid {
    GameSchedule *agame = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (self.user.authtoken)
         url = [NSURL URLWithString:[sportzServerInit getGame:[self.team teamid] Game:gameid Token:self.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", self.sport.id, @"/teams/", self.team.teamid, @"/gameschedules/", gameid, @".json"]];
            
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    if ([httpResponse statusCode] == 200) {
        agame = [[GameSchedule alloc] initWithDictionary:serverData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Game"
                                                        message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    return agame;
}

- (Athlete *)retrievePlayer:(NSString *)playerid {
    Athlete *aplayer = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (self.user.authtoken)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", self.sport.id, @"/athletes/", playerid, @".json?auth_token=", self.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                   @"/sports/", self.sport.id, @"/athletes/", playerid, @".json"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if ([httpResponse statusCode] == 200) {
        aplayer = [[Athlete alloc] initWithDictionary:serverData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Athlete"
                                                        message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    return aplayer;
}

- (BOOL)deleteCoach:(Coach *)acoach {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getCoach:[acoach coachid] Token:user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] init];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *coachdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if ([httpResponse statusCode] == 200) {
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Coach"
                                                        message:[coachdata objectForKey:@"error"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return  NO;
    }
}

- (void)populatePositionLists:(Athlete *)player {
        if ([player isQB:nil])
            [footballQB addObject:player];
        
        if ([player isRB:nil])
            [footballRB addObject:player];
        
        if ([player isWR:nil])
            [footballWR addObject:player];
        
        if ([player isOL:nil])
            [footballOL addObject:player];
        
        if ([player isDEF:nil])
            [footballDEF addObject:player];
        
        if ([player isPK:nil])
            [footballPK addObject:player];
        
        if ([player isKicker:nil])
            [footballK addObject:player];
        
        if ([player isPunter:nil])
            [footballPUNT addObject:player];
        
        if ([player isReturner:nil])
            [footballRET addObject:player];
}

- (Sport *)retrieveSport:(NSString *)asport {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sports/%@.json?auth_token=%@",
                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], asport, user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
    
    if (responseStatusCode == 200) {
        NSDictionary *sportdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        return [[Sport alloc] initWithDictionary:sportdata];
    } else {
        return nil;
    }
}

- (int)teamFouls:(NSString *)gameid {
    int teamfouls = 0;
    
    for (int cnt = 0; cnt < self.roster.count; cnt++) {
        Athlete *player = [self.roster objectAtIndex:cnt];
        
        if ([sport.name isEqualToString:@"Basketball"]) {
            for (int i = 0; i < player.basketball_stats.count; i++) {
                BasketballStats *stats = [player.basketball_stats objectAtIndex:i];
                
                if ([stats.gameschedule_id isEqualToString:gameid]) {
                    teamfouls = teamfouls + [stats.fouls intValue];
                }
            }
        } else if ([sport.name isEqualToString:@"Soccer"]) {
        }
    }
    
    return teamfouls;
}

- (int)teamTotalPoints:(NSString *)gameid {
    int totalpoints = 0;
    
    for (int cnt = 0; cnt < self.roster.count; cnt++) {
        Athlete *player = [self.roster objectAtIndex:cnt];
        
        if ([sport.name isEqualToString:@"Basketball"]) {
            for (int i = 0; i < player.basketball_stats.count; i++) {
                BasketballStats *stats = [player.basketball_stats objectAtIndex:i];
                
                if ([stats.gameschedule_id isEqualToString:gameid]) {
                    totalpoints = totalpoints + ([stats.twomade intValue] * 2) + ([stats.threemade intValue] * 3) + [stats.ftmade intValue];
                }
            }
        } else if ([sport.name isEqualToString:@"Soccer"]) {
            for (int i = 0; i < player.soccer_stats.count; i++) {
                Soccer *stats = [player.soccer_stats objectAtIndex:i];
                
                if ([stats.gameschedule_id isEqualToString:gameid]) {
                    totalpoints = totalpoints + [stats.goals intValue];
                }
            }
        } else if ([sport.name isEqualToString:@"Football"]) {
            for (int cnt = 0; cnt <  player.football_passing_stats.count; cnt++) {
                if ([[[player.football_passing_stats objectAtIndex:cnt] gameschedule_id] isEqualToString:gameid]) {
                    totalpoints += [[[player.football_passing_stats objectAtIndex:cnt] td] intValue] * 6;
                    totalpoints += [[[player.football_passing_stats objectAtIndex:cnt] twopointconv] intValue] * 2;
                    break;
                }
            }
            
            for (int cnt = 0; cnt <  player.football_rushing_stats.count; cnt++) {
                if ([[[player.football_rushing_stats objectAtIndex:cnt] gameschedule_id] isEqualToString:gameid]) {
                    totalpoints += [[[player.football_rushing_stats objectAtIndex:cnt] td] intValue] * 6;
                    totalpoints += [[[player.football_rushing_stats objectAtIndex:cnt] twopointconv] intValue] * 2;
                    break;
                }
            }
            
            for (int cnt = 0; cnt <  player.football_defense_stats.count; cnt++) {
                if ([[[player.football_defense_stats objectAtIndex:cnt] gameschedule_id] isEqualToString:gameid]) {
                    totalpoints += [[[player.football_defense_stats objectAtIndex:cnt] td] intValue] * 6;
                    totalpoints += [[[player.football_defense_stats objectAtIndex:cnt] safety] intValue] * 2;
                    break;
                }
            }
            
            for (int cnt = 0; cnt <  player.football_returner_stats.count; cnt++) {
                if ([[[player.football_returner_stats objectAtIndex:cnt] gameschedule_id] isEqualToString:gameid]) {
                    totalpoints += [[[player.football_returner_stats objectAtIndex:cnt] kotd] intValue] * 6;
                    totalpoints += [[[player.football_returner_stats objectAtIndex:cnt] punt_returntd] intValue] * 6;
                    break;
                }
            }
            
            for (int cnt = 0; cnt <  player.football_place_kicker_stats.count; cnt++) {
                if ([[[player.football_place_kicker_stats objectAtIndex:cnt] gameschedule_id] isEqualToString:gameid]) {
                    totalpoints += [[[player.football_place_kicker_stats objectAtIndex:cnt] fgmade] intValue] * 3;
                    totalpoints += [[[player.football_place_kicker_stats objectAtIndex:cnt] xpmade] intValue];
                    break;
                }
            }
        }
     }
    
    return totalpoints;
}

- (BOOL)initS3Bucket {
    s3bucket = nil;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *bucket = [mainBundle objectForInfoDictionaryKey:@"s3bucket"];
    // Initialize the S3 Client.
    s3 = [[AmazonS3Client alloc] initWithAccessKey:self.user.awskeyid withSecretKey:self.user.awssecretkey];
//    s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
    if (self.user.awskeyid) {
        NSArray *buckets = s3.listBuckets;
        for (int i = 0; i < [buckets count]; i++) {
            if ([[[buckets objectAtIndex:i] name] isEqualToString:bucket]) {
                s3bucket = [buckets objectAtIndex:i];
            }
        }
        // Create the picture bucket.
        if ((s3bucket == nil) && (self.user.admin) && ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])) {
            S3CreateBucketRequest *createBucketRequest = [[S3CreateBucketRequest alloc] initWithName:bucket andRegion:[S3Region USWest2]];
            S3CreateBucketResponse *createBucketResponse = [s3 createBucket:createBucketRequest];
            if(createBucketResponse.error != nil) {
                NSLog(@"Error: %@", createBucketResponse.error);
            }
        }
        return YES;
    } else
        return  NO;
}

- (S3Bucket *)getBucket {
    return s3bucket;
}

- (AmazonS3Client *)getS3 {
    return s3;
}

- (UIImage *)normalizedImage:(UIImage *)image scaledToSize:(int)size {
    UIImage *normalizedImage;
    
//    if (image.imageOrientation == UIImageOrientationUp) {
    
    if (image.size.height == image.size.width) {
        switch (size) {
            case 50:
                UIGraphicsBeginImageContext(CGSizeMake(50.0, 50.0));
                [image drawInRect:CGRectMake(0, 0 , 50.0, 50.0)];
                break;
                
            case 125:
                UIGraphicsBeginImageContext(CGSizeMake(125.0, 125.0));
                [image drawInRect:CGRectMake(0, 0 , 125.0, 125.0)];
                break;
                
            case 200:
                UIGraphicsBeginImageContext(CGSizeMake(200.0, 200.0));
                [image drawInRect:CGRectMake(0, 0, 200.0, 200.0)];
                break;
                
            case 512:
                UIGraphicsBeginImageContext(CGSizeMake(512.0, 512));
                [image drawInRect:CGRectMake(0, 0 , 512.0, 512)];
                break;
                
            default:
                UIGraphicsBeginImageContext(CGSizeMake(1024.0, 1024));
                [image drawInRect:CGRectMake(0, 0 , 1024.0, 1024)];
                break;
        }
    } else if (image.size.height < image.size.width) {
        switch (size) {
            case 50:
                UIGraphicsBeginImageContext(CGSizeMake(75.0, 50.0));
                [image drawInRect:CGRectMake(0, 0 , 75.0, 50.0)];
                break;
                
            case 125:
                UIGraphicsBeginImageContext(CGSizeMake(190.0, 125.0));
                [image drawInRect:CGRectMake(0, 0 , 190.0, 125.0)];
                break;
                
            case 200:
                UIGraphicsBeginImageContext(CGSizeMake(200.0, 150.0));
                [image drawInRect:CGRectMake(0, 0, 200.0, 150.0)];
                break;
                
            case 512:
                UIGraphicsBeginImageContext(CGSizeMake(512.0, 345.0));
                [image drawInRect:CGRectMake(0, 0 , 512.0, 345.0)];
                break;
                
            default:
                UIGraphicsBeginImageContext(CGSizeMake(1024.0, 680.0));
                [image drawInRect:CGRectMake(0, 0 , 1024.0, 680.0)];
                break;
        }
    } else if (image.size.height > image.size.width) {
        switch (size) {
            case 50:
                UIGraphicsBeginImageContext(CGSizeMake(50.0, 75.0));
                [image drawInRect:CGRectMake(0, 0 , 50.0, 75.0)];
                break;
                
            case 125:
                UIGraphicsBeginImageContext(CGSizeMake(125.0, 190.0));
                [image drawInRect:CGRectMake(0, 0 , 125.0, 190.0)];
                break;
                
            case 200:
                UIGraphicsBeginImageContext(CGSizeMake(150.0, 200.0));
                [image drawInRect:CGRectMake(0, 0, 150.0, 200.0)];
                break;
                
            case 512:
                UIGraphicsBeginImageContext(CGSizeMake(345.0, 512.0));
                [image drawInRect:CGRectMake(0, 0 , 345.0, 512.0)];
                break;
                
            default:
                UIGraphicsBeginImageContext(CGSizeMake(680.0, 1024.0));
                [image drawInRect:CGRectMake(0, 0 , 680.0, 1024.0)];
                break;
        }
    } else {
        UIGraphicsBeginImageContext(CGSizeMake((float)size, (float)size));
        [image drawInRect:CGRectMake(0, 0 , (float)size, (float)size)];
    }

        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
/*    } else {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        [image drawInRect:(CGRect){0, 0, image.size}];
        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
 */
    
    return normalizedImage;
}

- (void)replaceOpponentTinyImage:(GameSchedule *)thegame {
    BOOL found = NO;
    
    for (int i = 0; i < opponentimages.count; i++) {
        EazesportzImage *animage = [opponentimages objectAtIndex:i];
        
        if ([animage.modelid isEqualToString:thegame.id]) {
            if ((![thegame.opponentpic isEqualToString:@"/opponentpics/original/missing.png"]) &&
                (![thegame.opponentpic isEqualToString:@"/opponentpics/tiny/missing.png"])) {
                [animage setTiny:thegame.opponentpic UpdatedAt:thegame.opponentpic_updated_at];
            } else{
                animage.noimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
            }
            found = YES;
            break;
        }
    }
    
    if (!found) {
        EazesportzImage *animage = [[EazesportzImage alloc] initWithId:thegame.id];
        if ((![thegame.opponentpic isEqualToString:@"/opponentpics/original/missing.png"]) &&
            (![thegame.opponentpic isEqualToString:@"/opponentpics/tiny/missing.png"])) {
            [animage setTiny:thegame.opponentpic UpdatedAt:thegame.opponentpic_updated_at];
        } else {
            animage.noimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        }
        [opponentimages addObject:animage];
    }
}

- (void)removeOldOpponentImages {
    for (int i = 0; i < opponentimages.count; i++) {
        BOOL found = NO;
        EazesportzImage *animage = [opponentimages objectAtIndex:i];
        
        for (int count = 0; count < gameList.count; count++) {
            if (![[[gameList objectAtIndex:count] id] isEqualToString:animage.modelid]) {
                found = YES;
                break;
            }
        }
        
        if (!found) {
            [opponentimages removeObject:animage];
        }
    }    
}

- (UIImage *)getOpponentImage:(GameSchedule *)agame {
    UIImage *image = nil;
    
    for (int i = 0; i < opponentimages.count; i++) {
        if ([[[opponentimages objectAtIndex:i] modelid] isEqualToString:agame.id]) {
            EazesportzImage *animage = [opponentimages objectAtIndex:i];
            if (animage.noimage == nil)
                image = animage.tiny;
            else
                image = animage.noimage;
            break;
        }
    }
    
    return image;
}

- (void)replaceRosterImages:(Athlete *)player {
    BOOL found = NO;
    
    for (int i = 0; i < rosterimages.count; i++) {
        EazesportzImage *animage = [rosterimages objectAtIndex:i];
        
        if ([animage.modelid isEqualToString:player.athleteid]) {
            if (![player.tinypic isEqualToString:@"/pics/tiny/missing.png"]) {
                [animage setTiny:player.tinypic UpdatedAt:player.pic_updated_at];
                [animage setThumb:player.thumb UpdatedAt:player.pic_updated_at];
                [animage setMedium:player.mediumpic UpdatedAt:player.pic_updated_at];
//                [animage setLarge:player.largepic UpdatedAt:player.pic_updated_at];
            } else{
                animage.noimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
            }
            found = YES;
            break;
        }
    }
    
    if (!found) {
        EazesportzImage *animage = [[EazesportzImage alloc] initWithId:player.athleteid];
        if (![player.tinypic isEqualToString:@"/pics/tiny/missing.png"]) {
            [animage setTiny:player.tinypic UpdatedAt:player.pic_updated_at];
            [animage setThumb:player.thumb UpdatedAt:player.pic_updated_at];
            [animage setMedium:player.mediumpic UpdatedAt:player.pic_updated_at];
//            [animage setLarge:player.largepic UpdatedAt:player.pic_updated_at];
        } else {
            animage.noimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        }
        [rosterimages addObject:animage];
    }
}

- (UIImage *)getRosterTinyImage:(Athlete *)player {
    UIImage *image = nil;
    
    for (int i = 0; i < rosterimages.count; i++) {
        if ([[[rosterimages objectAtIndex:i] modelid] isEqualToString:player.athleteid]) {
            EazesportzImage *animage = [rosterimages objectAtIndex:i];
            if (animage.noimage == nil)
                image = animage.tiny;
            else
                image = animage.noimage;
            break;
        }
    }
    
    return image;
}

- (UIImage *)getRosterThumbImage:(Athlete *)player {
    UIImage *image = nil;
    
    for (int i = 0; i < rosterimages.count; i++) {
        if ([[[rosterimages objectAtIndex:i] modelid] isEqualToString:player.athleteid]) {
            EazesportzImage *animage = [rosterimages objectAtIndex:i];
            if (animage.noimage == nil)
                image = animage.thumb;
            else
                image = animage.noimage;
            break;
        }
    }
    
    return image;
}

- (UIImage *)getRosterMediumImage:(Athlete *)player {
    UIImage *image = nil;
    
    for (int i = 0; i < rosterimages.count; i++) {
        if ([[[rosterimages objectAtIndex:i] modelid] isEqualToString:player.athleteid]) {
            EazesportzImage *animage = [rosterimages objectAtIndex:i];
            if (animage.noimage == nil)
                image = animage.medium;
            else
                image = animage.noimage;
            break;
        }
    }
    
    return image;
}

- (UIImage *)getRosterLargeImage:(Athlete *)player {
    UIImage *image = nil;
    
    for (int i = 0; i < rosterimages.count; i++) {
        if ([[[rosterimages objectAtIndex:i] modelid] isEqualToString:player.athleteid]) {
            EazesportzImage *animage = [rosterimages objectAtIndex:i];
            if (animage.noimage == nil)
                image = animage.large;
            else
                image = animage.noimage;
            break;
        }
    }
    
    return image;
}

- (BOOL)isSiteOwner {
    if ((user.admin) && (user.adminsite.length > 0)) {
        if ([user.adminsite isEqualToString:sport.id])
            return YES;
        else
            return NO;
    } else
        return NO;
}

- (void)setUpSport:(NSString *)sportid {
    EazesportzRetrieveTeams *getTeams;
    
    if ([[[EazesportzRetrieveSport alloc] init] retrieveSportSynchronous:sportid Token:user.authtoken]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/currentsite.txt", documentsDirectory];
        NSString *sportFile = [NSString stringWithFormat:@"%@/currentsport.txt", documentsDirectory];
        //create content - four lines of text
        NSString *content = sport.id;
        //save content to the documents directory
        [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        [sport.name writeToFile:sportFile atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        
        getTeams = [[EazesportzRetrieveTeams alloc] init];
        
        if ([getTeams retrieveTeamsSynchronous:sport.id Token:user.authtoken]) {
            teams = getTeams.teams;
            sponsors = [[EazesportzRetrieveSponsors alloc] init];
            team = nil;
        }
    }
}

- (NSURL *)addAuthenticationToken:(NSString *)urlstring {
    if ([self isSiteOwner])
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?auth_token=%@", urlstring, user.authtoken]];
    else
        return [NSURL URLWithString:urlstring];

}

@end

