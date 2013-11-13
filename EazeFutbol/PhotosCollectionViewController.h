//
//  PhotosCollectionViewController.h
//  Eazebasketball
//
//  Created by Gil on 10/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface PhotosCollectionViewController : UICollectionViewController

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) Athlete *player;

@end
