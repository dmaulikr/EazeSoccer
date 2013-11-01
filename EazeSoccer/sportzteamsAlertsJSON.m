//
//  sportzteamsAlertsJSON.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/28/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzteamsAlertsJSON.h"
#import "Alert.h"

@implementation sportzteamsAlertsJSON

@synthesize alerts;

- (void)processAlertData:(NSArray *)alertData {
    alerts = [[NSMutableArray alloc] init];
    for (int i = 0; i < [alertData count]; i++) {
        NSDictionary *items = [alertData objectAtIndex:i];
        Alert *alert = [[Alert alloc] init];
        alert.alertid = [items objectForKey:@"id"];
        alert.message = [items objectForKey:@"message"];
        alert.created_at = [items objectForKey:@"created_at"];
        alert.sport = [items objectForKey:@"sport"];
        alert.athlete = [items objectForKey:@"athlete"];
        alert.photo = [items objectForKey:@"photo"];
        alert.user = [items objectForKey:@"user"];
        alert.blog = [items objectForKey:@"blog"];
        alert.videoclip = [items objectForKey:@"videoclip"];
        alert.stat = [items objectForKey:@"football_stat"];
        alert.stattype = [items objectForKey:@"stat_football"];
        [alerts addObject:alert];
    }

}

@end
