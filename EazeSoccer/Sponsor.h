//
//  Sponsor.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/10/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EazesportzPhotoImage.h"

@interface Sponsor : NSObject

@property(nonatomic, strong) NSString *sponsorid;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *addrnum;
@property(nonatomic, strong) NSString *street;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *zip;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *fax;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *adurl;
@property(nonatomic, strong) NSString *tiny;
@property(nonatomic, strong) NSString *thumb;
@property(nonatomic, strong) NSString *medium;
@property(nonatomic, strong) NSString *large;
@property(nonatomic, strong) NSString *sponsorlevel;
@property(nonatomic, strong) NSNumber *teamonly;
@property(nonatomic, strong) NSString *teamid;
@property (nonatomic, strong) NSString *country;


@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *sportadinv_id;

@property (nonatomic, strong) NSString *ios_client_ad;

@property (nonatomic, assign) float adprice;
@property (nonatomic, assign) BOOL forsale;
@property (nonatomic, strong) NSString *adsponsorlevel;
@property (nonatomic, assign) BOOL playerad;

@property (nonatomic, strong) UIImage *tinyimage;
@property (nonatomic, strong) UIImage *thumbimage;
@property (nonatomic, strong) UIImage *mediumimage;
@property (nonatomic, strong) UIImage *largeimage;
@property (nonatomic, strong) NSDate *sponsorpic_updated_at;

@property (nonatomic, strong) NSString *portraitbanner;
@property (nonatomic, strong) NSString *landscapebanner;
@property (nonatomic, strong) UIImage *portraitBannerImage;
@property (nonatomic, strong) UIImage *landscapeBannerImage;
@property (nonatomic, strong) NSDate *adbanner_updated_at;

@property(nonatomic, strong) NSString *httperror;

- (id)initWithDirectory:(NSDictionary *)sponsorDictionary;
- (id)initDelete;

- (void)deleteSponsor;

- (void)saveSponsor;

- (void)loadImages;
- (UIImage *)bannerImage;
- (UIImage *)getPortraitBanner;

@end
