//
//  NewsTableViewController.h
//  EazeSportz
//
//  Created by Gil on 11/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray *newsfeed;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)changeTeamButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
- (IBAction)searchButtonClicked:(id)sender;

- (void)getNews:(NSString *)updated_at AllNews:(BOOL)allnews;

@end
