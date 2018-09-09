//
//  ContactViewController.m
//  sndrContact
//
//  Created by Denis Arsenault on 9/8/18.
//  Copyright (c) 2018 Sndr LLC All rights reserved.
//

#import "ContactViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Entity+CoreDataClass.h"

@interface ContactViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ContactViewController;


@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UITextView *dataTextView;


@end

@implementation ContactViewController
{
    NSArray *tableData;
}

#pragma mark - TableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize table data
    

    
    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Networking

- (IBAction)fetchData:(id)sender
{
//    self.dataTextView.text = @"";
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//    manager.securityPolicy = policy;
//
//    // optional
//    NSString *pathToCert = [[NSBundle mainBundle]pathForResource:@"github.com" ofType:@"cer"];
//    NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCert];
//    manager.securityPolicy.pinnedCertificates = @[localCertificate];
//
//    [self.activityIndicator startAnimating];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:self.urlField.text parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.activityIndicator stopAnimating];
//        NSLog(@"Response: %@", responseObject);
//
//        self.dataTextView.text = operation.responseString;
//        self.dataTextView.textColor = [UIColor darkTextColor];
//
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self.activityIndicator stopAnimating];
//        NSLog(@"Error: %@", error);
//
//        self.dataTextView.text = error.localizedDescription;
//        self.dataTextView.textColor = [UIColor redColor];
//    }];
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self.urlField resignFirstResponder];
    return YES;
}

@end
