//
//  EazesportzRetrieveFeaturedPhotos.m
//  EazeSportz
//
//  Created by Gil on 1/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveFeaturedPhotos.h"
#import "EazesportzAppDelegate.h"

@implementation EazesportzRetrieveFeaturedPhotos {
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize featuredphotos;

- (id)init {
    if (self = [super init] ) {
        featuredphotos = nil;
        return  self;
    } else
        return nil;
}

- (void)retrieveFeaturedPhotos:(NSString *)sportid Token:(NSString *)token {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url;
    
    if (token)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/photos/showfeaturedphotos.json?team_id=",
                                       currentSettings.team.teamid, @"&auth_token=", currentSettings.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", currentSettings.sport.id, @"/photos/showfeaturedphotos.json?team_id=",
                                    currentSettings.team.teamid]];
    
    originalRequest = [NSURLRequest requestWithURL:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[NSURLConnection alloc] initWithRequest:originalRequest delegate:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FeaturedPhotosChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result" , nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        if (featuredphotos) {
            NSMutableArray *photolist = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < serverData.count; i++) {
                Photo *photo = [[Photo alloc] initWithDirectory:[serverData objectAtIndex:i]];
                [self replaceFeaturedPhotoImages:photo];
                [photolist addObject:photo];
            }
            
            [self cleanUpFeaturedPhotosList:photolist];
        } else {
            featuredphotos = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < serverData.count; i++) {
                Photo *photo = [[Photo alloc] initWithDirectory:[serverData objectAtIndex:i]];
                [photo loadImagesInBackground];
                [featuredphotos addObject:photo];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FeaturedPhotosChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FeaturedPhotosChangedNotification" object:nil
                                            userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retrieving Featured Photos", @"Result" , nil]];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if (redirectResponse) {
        NSMutableURLRequest *newrequest = [originalRequest mutableCopy];
        [newrequest setURL:[request URL]];
        return  newrequest;
    } else {
        return request;
    }
}

- (void)addFeaturedPhoto:(Photo *)photo {
    BOOL found = NO;
    int cnt;
    
    for (cnt = 0; cnt < featuredphotos.count; cnt++) {
        if ([photo.photoid isEqualToString:[[featuredphotos objectAtIndex:cnt] photoid]]) {
            found = YES;
            break;
        }
    }
    
    if (!found)
        [featuredphotos addObject:photo];
    else
        [featuredphotos replaceObjectAtIndex:cnt withObject:photo];
}

- (void)removeFeaturedPhoto:(Photo *)photo {
    [featuredphotos removeObject:photo];
}

- (void)saveFeaturedPhotos {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/photos/updatefeaturedphotos.json?team_id=",
                                        currentSettings.team.teamid, @"&auth_token=", currentSettings.user.authtoken]];
    
    NSMutableArray *thephotos = [[NSMutableArray alloc] init];
    for (int i = 0; i < featuredphotos.count; i++) {
        [thephotos addObject:[[featuredphotos objectAtIndex:i] photoid]];
    }
    
    NSMutableDictionary *featuredphotolist = [[NSMutableDictionary alloc] initWithObjectsAndKeys:thephotos, @"photo_ids", nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:featuredphotolist options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([httpResponse statusCode] != 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error adding photo to featured photo list"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (BOOL)isFeaturedPhoto:(Photo *)photo {
    BOOL found = NO;
    
    for (int i = 0; i < featuredphotos.count; i++) {
        if ([[[featuredphotos objectAtIndex:i] photoid] isEqualToString:photo.photoid]) {
            found = YES;
            break;
        }
    }
    
    return found;
}

- (void)replaceFeaturedPhotoImages:(Photo *)photo {
     BOOL found = NO;
     
     for (int i = 0; i < featuredphotos.count; i++) {
     
         if (([[[featuredphotos objectAtIndex:i] photoid] isEqualToString:photo.photoid]) &&
             ([[[featuredphotos objectAtIndex:i] updated_at] compare:photo.updated_at] == NSOrderedSame)) {
             found = YES;
             break;
         }
     }
     
     if (!found) {
         [photo loadImagesInBackground];
         [featuredphotos addObject:photo];
     }
 }

- (void)cleanUpFeaturedPhotosList:(NSMutableArray *)photolist {
    
    for (int i = 0; i < featuredphotos.count; i++) {
        BOOL found = NO;
        
        for (int cnt = 0; cnt < photolist.count; cnt++) {
            if ([[[photolist objectAtIndex:cnt] photoid] isEqualToString:[[featuredphotos objectAtIndex:i] photoid] ]) {
                found = YES;
                break;
            }
        }
        
        if (!found) {
            [featuredphotos removeObjectAtIndex:i];
        }
    }
}

@end
