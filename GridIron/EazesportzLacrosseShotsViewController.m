//
//  EazesportzLacrosseShotsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/1/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseShotsViewController.h"
#import "EazesportzAppDelegate.h"
#import "VisitingTeam.h"

@interface EazesportzLacrosseShotsViewController ()

@end

@implementation EazesportzLacrosseShotsViewController {
    NSArray *periodarray;
    NSMutableArray *shotsarray, *playershots;
    NSString *pickertype;
    VisitingTeam *visitors;
    
    Lacrosstat *stats;
}

@synthesize game;
@synthesize player;
@synthesize visitingPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pickertype = @"Player";
    periodarray = [[currentSettings.sport.lacrosse_periods allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[currentSettings.sport.lacrosse_periods objectForKey:obj1] compare:[currentSettings.sport.lacrosse_periods objectForKey:obj2]];
    }];
    
    NSArray *shotarray = [currentSettings.sport.lacrosse_shots allKeys];
    shotsarray = [shotarray mutableCopy];
    [shotsarray removeObject:@"Goal"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _pickerView.hidden = YES;
    
    if (visitingPlayer) {
        _playerLabel.text = visitingPlayer.numberlogname;
        stats = [visitingPlayer findLacrossStat:game];
    } else {
        _playerLabel.text = player.numberLogname;
        stats = [player findLacrosstat:game];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if ([pickertype isEqualToString:@"Period"]) {
        return periodarray.count;
    } else {
        return shotsarray.count;
    }
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickertype isEqualToString:@"Period"])
        return [periodarray objectAtIndex:row];
    else
        return [shotsarray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickertype isEqualToString:@"Shot"]){
        _shotTextField.text = [shotsarray objectAtIndex:row];
    } else {
        _periodTextField.text = [periodarray objectAtIndex:row];
        [_shotTableView reloadData];
    }
    
    _pickerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _periodTextField) {
        pickertype = @"Period";
        [_pickerView reloadAllComponents];
    } else if (textField == _shotTextField) {
        pickertype = @"Shot";
        [_pickerView reloadAllComponents];
    }
    
    _pickerView.hidden = NO;
    [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSNumber *period = [NSNumber numberWithInt:[_periodTextField.text intValue]];
    
    switch ([period intValue]) {
        case 1:
            if ([stats hasPlayerStatPeriod:period])
                return [[stats.player_stats objectAtIndex:0] shot].count;
            break;
            
        case 2:
            if ([stats hasPlayerStatPeriod:period])
                return [[stats.player_stats objectAtIndex:1] shot].count;
            break;
            
        case 3:
            if ([stats hasPlayerStatPeriod:period])
                return [[stats.player_stats objectAtIndex:2] shot].count;
            break;
            
        case 4:
            if ([stats hasPlayerStatPeriod:period])
                return [[stats.player_stats objectAtIndex:3] shot].count;
            break;
            
        case 5:
            if ([stats hasPlayerStatPeriod:period])
                return [[stats.player_stats objectAtIndex:4] shot].count;
            break;
            
        default:
            return 0;
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShotTableCell" forIndexPath:indexPath];
    
    int theperiod = [_periodTextField.text intValue];
    NSArray *shots = [[stats.player_stats objectAtIndex:(theperiod - 1)] shot];
    NSArray* arrayOfKeys = [currentSettings.sport.lacrosse_shots allKeysForObject:[shots objectAtIndex:indexPath.row]];
    cell.textLabel.text = [arrayOfKeys objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[stats.player_stats objectAtIndex:[_periodTextField.text intValue]] isEqualToString:@"G"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Shots from goals are automatically removed when a goal is deleted. Please delete the goal and the shot will be automtically removed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        LacrossPlayerStat *playerstat = [stats.player_stats objectAtIndex:[_periodTextField.text intValue]];
        [playerstat.shot removeObjectAtIndex:indexPath.row];
        [playerstat deleteshot:currentSettings.sport Team:currentSettings.team Game:game User:currentSettings.user
                                                    Shot:[currentSettings.sport.lacrosse_shots objectForKey:_shotTextField.text]];
        [_shotTableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Shot Type - Swipe to delete";
}

- (IBAction)saveButtonClicked:(id)sender {
    if ((_shotTextField.text.length > 0) && (_periodTextField.text.length > 0)) {
        LacrossPlayerStat *playerstat;
        
        if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:[_periodTextField.text intValue]]])
            playerstat = [stats.player_stats objectAtIndex:[_periodTextField.text intValue]];
        else {
            playerstat = [[LacrossPlayerStat alloc] init];
            playerstat.period = [NSNumber numberWithInt:[_periodTextField.text intValue]];
            playerstat.lacrosstat_id = stats.lacrosstat_id;
            
            if (visitingPlayer)
                playerstat.visitor_roster_id = visitingPlayer.visitor_roster_id;
            else
                playerstat.athlete_id = player.athleteid;
            
            [stats.player_stats addObject:playerstat];
        }
        
        [playerstat.shot addObject:[currentSettings.sport.lacrosse_shots objectForKey:_shotTextField.text]];
        [playerstat saveShot:currentSettings.sport Team:currentSettings.team Game:game User:currentSettings.user
                                                    Shot:[currentSettings.sport.lacrosse_shots objectForKey:_shotTextField.text]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter shot and period" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
