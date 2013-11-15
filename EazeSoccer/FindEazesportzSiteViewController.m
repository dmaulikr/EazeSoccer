//
//  FindEazesportzSiteViewController.m
//  Basketball Console
//
//  Created by Gil on 10/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "FindEazesportzSiteViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"

@interface FindEazesportzSiteViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation FindEazesportzSiteViewController {
    NSMutableArray *siteList;
    NSDictionary *stateDictionary;
    NSArray *stateList;
    NSString *state;
    NSString *thesport;
}

@synthesize sport;

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
    _zipcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    NSBundle *mainBundle = [NSBundle mainBundle];
    thesport = [mainBundle objectForInfoDictionaryKey:@"sportzteams"];
    
    _imageView.image = [currentSettings getBannerImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    siteList = [[NSMutableArray alloc] init];
    _sitenameTextField.text = @"";
    _stateTextField.text = @"";
    _zipcodeTextField.text = @"";
    _cityTextField.text = @"";
    [_siteTableView reloadData];
    _stateListPicker.hidden = YES;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return siteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SiteTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Sport *asport = [siteList objectAtIndex:indexPath.row];
    cell.textLabel.text = asport.sitename;
    cell.imageView.image = [asport getImage:@"tiny"];
    cell.detailTextLabel.text = asport.mascot;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    sport = [siteList objectAtIndex:indexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Sites";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_siteTableView indexPathForSelectedRow];
    
    if (indexPath.length > 0)
        sport = [siteList objectAtIndex:indexPath.row];
    else
        sport = nil;
}

- (IBAction)searchButtonClicked:(id)sender {
    _stateListPicker.hidden = YES;
    
    if ((_stateTextField.text.length > 0) || (_zipcodeTextField.text.length > 0) || (_cityTextField.text.length > 0) ||
        (_sitenameTextField.text.length > 0)) {
        NSURL *url = [NSURL URLWithString:[sportzServerInit getSiteList:_stateTextField.text Zip:_zipcodeTextField.text
                                                                       City:_cityTextField.text SiteName:_sitenameTextField.text
                                                                       Sportname: thesport]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse* response;
        NSError *error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        if ([(NSHTTPURLResponse*)response statusCode] == 200) {
            NSArray *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            siteList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [serverData count]; i++) {
                NSDictionary *items = [serverData objectAtIndex:i];
                Sport *asport = [[Sport alloc] initWithDictionary:items];
                
                if ((asport.approved) && ([[items objectForKey:@"teamcount"] intValue] > 0))
                    [siteList addObject:asport];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Retrieving Site List" delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
    [_siteTableView reloadData];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath =[bundle pathForResource:@"USStateAbbreviations" ofType:@"plist"];
    stateDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * keys = [stateDictionary allKeys];
    stateList = [keys sortedArrayUsingSelector:@selector(compare:)];
    return stateList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [stateList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    _stateTextField.text = [stateDictionary objectForKey:[stateList objectAtIndex:row]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _stateTextField) {
        [textField resignFirstResponder];
        _stateListPicker.hidden = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _zipcodeTextField) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        if (myStringMatchesRegEx)
            return YES;
        else
            return NO;
    } else
        return YES;
}

@end
