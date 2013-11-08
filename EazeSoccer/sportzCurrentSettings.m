//
//  sportzCurrentSettings.m
//  sportzSoftwareFootball
//
//  Created by Gil on 2/7/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"

@implementation sportzCurrentSettings {
    AmazonS3Client *s3;
    S3Bucket *s3bucket;
}

@synthesize user;
@synthesize sport;
@synthesize team;
@synthesize game;

@synthesize roster;
@synthesize gameList;
@synthesize coaches;
@synthesize teams;
@synthesize sponsors;
@synthesize alerts;

@synthesize lastAlertUpdate;
@synthesize lastGameUpdate;
@synthesize getRoster;

- (id)init {
    if (self = [super init]) {
        user = [User alloc];
        sport = [Sport alloc];
        team = [Team alloc];
        lastAlertUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
        
        return self; 
    } else
        return nil;
}

- (UIImage *)getBannerImage {
    UIImage *image;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Soccer"])
        image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"soccerheader.jpg"], 1)];
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
/*
- (Athlete *)addAthleteStats:(Athlete *)athlete Stats:(Stats *)stats {
    Athlete *player = [self findAthlete:[athlete athleteid]];
    
    if (player != nil)
        player.stats = stats;
    
    return player;
}
*/
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
    for (int count = 0; count < [coaches count]; count++) {
        if ([[[coaches objectAtIndex:count] coachid] isEqualToString:coachid]) {
            result =  [coaches objectAtIndex:count];
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

- (void)retrieveGameList {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getGameSchedule:self.team.teamid Token:self.user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSArray *games = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    if ([httpResponse statusCode] == 200) {
        self.gameList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [games count]; i++ ) {
            [gameList addObject:[[GameSchedule alloc] initWithDictionary:[games objectAtIndex:i]]];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Games"
                                                        message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (GameSchedule *)retrieveGame:(NSString *)gameid {
    GameSchedule *agame = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[sportzServerInit getGame:[self.team teamid] Game:gameid
                                                          Token:self.user.authtoken]];
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

- (BOOL)deleteGame:(GameSchedule *)agame {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[sportzServerInit getGame:team.teamid Game:agame.id Token:user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
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
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    if ([httpResponse statusCode] == 200) {
        game = nil;
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[serverData objectForKey:@"error"]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return NO;
    }
}

- (void)retrieveCoaches {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getCoachList:self.team.teamid Token:self.user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSArray *thecoaches = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    if ([httpResponse statusCode] == 200) {
        self.coaches = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < thecoaches.count; i++) {
            [coaches addObject:[[Coach alloc] initWithDictionary:[thecoaches objectAtIndex:i]]];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Coaches"
                                                        message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
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

- (void)retrievePlayers {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getRoster:self.team.teamid Token:self.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSArray *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    if ([httpResponse statusCode] == 200) {
        roster = [[NSMutableArray alloc] init];
        for (int i = 0; i < serverData.count; i++) {
            [roster addObject:[[Athlete alloc] initWithDictionary:[serverData objectAtIndex:i]]];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Players"
                                                        message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (BOOL)deletePlayer:(Athlete *)player {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getAthlete:[player athleteid] Token:user.authtoken]];
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
    int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *athdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (responseStatusCode == 200) {
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Athlete"
                                                        message:[athdata objectForKey:@"error"]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return NO;
    }
}

- (void)retrieveTeams {
    teams = [self retrieveSportTeams:self.sport.id];
    if (!teams) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                message:@"Error retrieving teams" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (NSMutableArray *)retrieveSportTeams:(NSString *)sportid {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getTeams:sportid Token:self.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSArray *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    if ([httpResponse statusCode] == 200) {
        NSMutableArray *theteams =[[NSMutableArray alloc] init];
        for (int i = 0; i < [serverData count]; i++) {
            [theteams addObject:[[Team alloc] initWithDictionary:[serverData objectAtIndex:i]]];
        }
        NSURL *url = [NSURL URLWithString:[sportzServerInit getSponsors:self.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSArray *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        if ([httpResponse statusCode] == 200) {
            for (int i = 0; i < [serverData count]; i++) {
                NSDictionary *items = [serverData objectAtIndex:i];
                Sponsor *sponsor = [Sponsor alloc];
                sponsor.sponsorid = [items objectForKey:@"sponsorid"];
                sponsor.name = [items objectForKey:@"name"];
                sponsor.address = [items objectForKey:@"address"];
                sponsor.city = [items objectForKey:@"city"];
                sponsor.state = [items objectForKey:@"state"];
                sponsor.zip = [items objectForKey:@"zip"];
                sponsor.phone = [items objectForKey:@"phone"];
                sponsor.mobile = [items objectForKey:@"mobile"];
                sponsor.fax = [items objectForKey:@"fax"];
                sponsor.email = [items objectForKey:@"email"];
                sponsor.adurl = [items objectForKey:@"adurl"];
                sponsor.thumb = [items objectForKey:@"thumb"];
                sponsor.medium = [items objectForKey:@"medium"];
                sponsor.large = [items objectForKey:@"large"];
                sponsor.priority = [NSNumber numberWithBool:[[items objectForKey:@"priority"] boolValue]];
                sponsor.teamonly = [NSNumber numberWithBool:[[items objectForKey:@"teamonl"] boolValue]];
                sponsor.teamid = [items objectForKey:@"team_id"];
                [sponsors addObject:sponsor];
            }
            return theteams;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)retrieveSport {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getSport:self.user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
    
    if (responseStatusCode == 200) {
        NSDictionary *sportdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        self.sport = [[Sport alloc] initWithDictionary:sportdata];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving Sport"
                              message:[NSString stringWithFormat:@"%d", responseStatusCode] delegate:nil cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (BOOL)initS3Bucket {
    s3bucket = nil;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *bucket = [mainBundle objectForInfoDictionaryKey:@"s3bucket"];
    // Initialize the S3 Client.
    s3 = [[AmazonS3Client alloc] initWithAccessKey:self.user.awskeyid withSecretKey:self.user.awssecretkey];
//    s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
    if ((self.user.awskeyid) && ([self.user.admin boolValue])) {
        NSArray *buckets = s3.listBuckets;
        for (int i = 0; i < [buckets count]; i++) {
            if ([[[buckets objectAtIndex:i] name] isEqualToString:bucket]) {
                s3bucket = [buckets objectAtIndex:i];
            }
        }
        // Create the picture bucket.
        if (s3bucket == nil) {
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

- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end

