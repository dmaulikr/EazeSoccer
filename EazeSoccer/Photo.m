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

- (id)init {
    if (self = [super init]) {
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
        
        if ((NSNull *)[items objectForKey:@"thumbnail_url"] != [NSNull null])
            self.thumbnail_url = [items objectForKey:@"thumbnail_url"];
        else
            self.thumbnail_url = @"";
        
        self.description = [items objectForKey:@"description"];
        self.displayname = [items objectForKey:@"displayname"];
        self.teamid = [items objectForKey:@"teamid"];
        self.schedule = [items objectForKey:@"gameschedule"];
        self.photoid = [items objectForKey:@"id"];
        self.owner = [items objectForKey:@"user"];
        self.players = [items objectForKey:@"players"];
        self.gamelog = [items objectForKey:@"gamelog"];
    
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

@end
