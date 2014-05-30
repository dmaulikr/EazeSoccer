//
//  VisitingTeam.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "VisitingTeam.h"
#import "EazesportzRetrieveVisitorRoster.h"
#import "EazesportzAppDelegate.h"

@implementation VisitingTeam {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    BOOL deleteTeam;
    
    EazesportzRetrieveVisitorRoster *visitorRoster;
}


@synthesize teamtitile;
@synthesize mascot;
@synthesize visiting_team_id;

@synthesize visitor_roster;

@synthesize httperror;

- (id)initWithDictionary:(NSDictionary *)visitingTeamDictionary {
    if (self = [super init]) {
        teamtitile = [visitingTeamDictionary objectForKey:@"title"];
        mascot = [visitingTeamDictionary objectForKey:@"mascot"];
        
        if ([visitingTeamDictionary objectForKey:@"_id"])
            visiting_team_id = [visitingTeamDictionary objectForKey:@"_id"];
        else
            visiting_team_id = [visitingTeamDictionary objectForKey:@"id"];
        
        visitorRoster = [[EazesportzRetrieveVisitorRoster alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotVisitorRoster:) name:@"VisitorRosterListChangedNotification" object:nil];
        [visitorRoster retrieveVisitorRoster:currentSettings.sport VisitingTeam:self User:currentSettings.user];
                         
        return self;
    } else
        return nil;
}

- (void)gotVisitorRoster:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        visitor_roster = visitorRoster.visitorRoster;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieving visitor roster" delegate:nil cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [alert show];
    }
}

- (void)save:(Sport *)sport User:(User *)user {
    NSURL *aurl;
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if (self.visiting_team_id.length > 0)
        aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", sport.id, @"/visiting_teams.json?auth_token=", user.authtoken]];
    else
        aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", sport.id, @"/visiting_teams.json?auth_token=",
                                     user.authtoken]];
    
    NSMutableDictionary *teamDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:teamtitile, @"title",
                                     mascot, @"mascot", nil];
    
    /*    if (imageselected) {
     UIImage *photoImage = _teamImage.image;
     NSData *imageData = UIImageJPEGRepresentation(photoImage, 1.0);
     NSString *imageDataEncodedString = [imageData base64EncodedString];
     [teamDict setObject:imageDataEncodedString forKey:@"image_data"];
     [teamDict setObject:@"image/jpg" forKey:@"content_type"];
     NSString *name = [_teamnameTextField.text stringByAppendingFormat:@"%@%@%@", @"_", _mascotTextField.text, @".jpg"];
     [teamDict setObject:name forKey:@"original_filename"];
     imageselected = NO;
     }
     */
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:teamDict, @"visiting_team", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (visiting_team_id.length > 0) {
        [request setHTTPMethod:@"PUT"];
    } else {
        [request setHTTPMethod:@"POST"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    if (jsonSerializationError) {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (self.visiting_team_id != nil)
        [request setHTTPMethod:@"PUT"];
    else
        [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:jsonData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (void)deleteTeam:(Sport *)sport User:(User *)user {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", sport.id, @"/visiting_teams.json?auth_token=", user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSError *error = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] init];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    deleteTeam = YES;
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitingTeamDeletedNotification" object:nil
                            userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error.", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    if (responseStatusCode == 200) {
        if (deleteTeam) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitingTeamDeletedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
            [self initDelete];
        } else {
            NSDictionary *items = [serverData objectForKey:@"visiting_team"];
            self.visiting_team_id = [items objectForKey:@"_id"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitingTeamSavedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
        }
        
    } else {
        if (deleteTeam)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitingTeamDeletedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error", @"Result", nil]];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitingTeamSavedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error", @"Result", nil]];
        
        httperror = [serverData objectForKey:@"error"];
    }
}

- (id)initDelete {
    self = nil;
    return self;
}

- (VisitorRoster *)findAthlete:(NSString *)rosterid {
    VisitorRoster *athlete = nil;
    
    for (int i = 0; i < visitor_roster.count; i++) {
        if ([[[visitor_roster objectAtIndex:i] visitor_roster_id] isEqualToString:rosterid]) {
            athlete = [visitor_roster objectAtIndex:i];
            break;
        }
    }
    
    return athlete;
}

@end
