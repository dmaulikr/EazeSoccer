//
//  Photo.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/4/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "Photo.h"

@implementation Photo {
    NSString *imagesize;
    UIImage *photoimage;
}

@synthesize large_url;
@synthesize medium_url;
@synthesize thumbnail_url;
@synthesize description;
@synthesize displayname;
@synthesize teamid;
@synthesize photoid;
@synthesize players;
@synthesize owner;
@synthesize schedule;
@synthesize athletes;
@synthesize game;
@synthesize gamelog;

@synthesize thumbimage;
@synthesize mediumimage;
@synthesize largeimage;

@synthesize sport_id;
@synthesize team_id;

- (id)init {
    if (self = [super init]) {
        thumbimage = nil;
        mediumimage = nil;
        largeimage = nil;
        players = [[NSMutableArray alloc] init];
        athletes = [[NSMutableArray alloc] init];
        return self;
    } else
        return nil;
}

- (id)initWithDirectory:(NSDictionary *)items {
    if ((self = [super self]) && (items.count > 0)) {
        if ((NSNull *)[items objectForKey:@"large_url"] != [NSNull null])
            self.large_url = [items objectForKey:@"large_url"];
        else
            self.large_url = @"";
        
        if ((NSNull *)[items objectForKey:@"medium_url"] != [NSNull null])
            self.medium_url = [items objectForKey:@"medium_url"];
        else
            self.medium_url = @"";
        
        if ((NSNull *)[items objectForKey:@"thumbnail_url"] != [NSNull null]) {
            self.thumbnail_url = [items objectForKey:@"thumbnail_url"];
            [self getImage:@"thumb"];
        } else
            self.thumbnail_url = @"";
        
        [self loadImages];
        self.description = [items objectForKey:@"description"];
        self.displayname = [items objectForKey:@"displayname"];
        self.teamid = [items objectForKey:@"teamid"];
        self.schedule = [items objectForKey:@"gameschedule"];
        self.photoid = [items objectForKey:@"id"];
        self.owner = [items objectForKey:@"user"];
        self.players = [items objectForKey:@"players"];
        self.gamelog = [items objectForKey:@"gamelog"];
        
        self.sport_id = [items objectForKey:@"sport_id"];
        self.team_id = [items objectForKey:@"team_id"];
    
        return  self;
    } else {
        return nil;
    }
}

- (UIImage *)getImage:(NSString *)size {
    UIImage *image;
    
    if ([size isEqualToString:@"thumb"]) {
        
        if (self.thumbnail_url.length == 0) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if (((photoimage.CIImage == nil) && (photoimage.CGImage == nil)) || (![imagesize isEqualToString:@"thumb"])) {
            NSURL * imageURL = [NSURL URLWithString:self.thumbnail_url];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            photoimage = image;
            imagesize = size;
        } else
            image = photoimage;
        
    } else if ([size isEqualToString:@"medium"]) {
        
        if (self.medium_url.length == 0) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if (((photoimage.CIImage == nil) && (photoimage.CGImage == nil)) || (![imagesize isEqualToString:@"medium"])) {
            NSURL * imageURL = [NSURL URLWithString:self.medium_url];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            photoimage = image;
            imagesize = size;
        } else
            image = photoimage;
        
    } else if ([size isEqualToString:@"medium"]) {
    
        if (self.large_url.length == 0) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if (((photoimage.CIImage == nil) && (photoimage.CGImage == nil)) || (![imagesize isEqualToString:@"medium"])) {
            NSURL * imageURL = [NSURL URLWithString:self.large_url];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            photoimage = image;
            imagesize = size;
        } else
            image = photoimage;
        
    }

    return image;
}

- (void)loadImages {
    if (thumbnail_url.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnail_url]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                thumbimage = [UIImage imageWithData:image];
            });
        });
    } else {
        thumbimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    
    if (medium_url.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:medium_url]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                mediumimage = [UIImage imageWithData:image];
            });
        });
    } else {
        mediumimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
    
    if (large_url.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:large_url]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                largeimage = [UIImage imageWithData:image];
            });
        });
    } else {
        largeimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    }
}

- (BOOL)saveImagesToDocuments:(UIImage *)image Size:(NSString *)imageSize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *photofile = [documentsDirectory stringByAppendingPathComponent:sport_id];
    photofile = [photofile stringByAppendingPathComponent:team_id];
    photofile = [photofile stringByAppendingPathComponent:photoid];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    [data writeToFile:photofile atomically:YES];
    return YES;
}

@end
