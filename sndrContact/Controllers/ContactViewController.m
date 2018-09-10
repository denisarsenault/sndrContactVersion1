//
//  ContactViewController.m
//  sndrContact
//
//  Created by Denis Arsenault on 9/8/18.
//  Copyright (c) 2018 Sndr LLC All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactViewController.h"
#import "ContactCell.h"
#import <AFNetworking/AFNetworking.h>
#import "ContactDetailViewController.h"


@interface ContactViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ContactViewController;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UITextView *dataTextView;
@property (strong, nonatomic) NSIndexPath *selection;

@end

@implementation ContactViewController
{
    NSArray *tableData;
}

#pragma mark - TableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([ContactViewController isKindOfClass:[ContactViewController class]])
//    {
//        [ContactViewController setManagedObjectContext:self.managedObjectContext];
//    }
    // Initialize table data
    
    // Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"last_name" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    // Add all the values for display

    

    
    //tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [tableData count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"SimpleTableItem";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//
//    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
//    return cell;
//}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ContactDetailSeque"])
    {
        // Obtain Reference to View Controller
        UINavigationController *navigationController = (UINavigationController *)[segue destinationViewController];
        ContactDetailViewController *contactDetailViewController = (ContactDetailViewController *)[navigationController topViewController];
        
        // Configure View Controller
        [contactDetailViewController setManagedObjectContext:self.managedObjectContext];

        // Configure View Controller
        [contactDetailViewController setManagedObjectContext:self.managedObjectContext];

        if (self.selection)
        {
            // Fetch Record
            NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:self.selection];

            if (record) {
                [contactDetailViewController setRecord:record];
            }

            // Reset Selection
            [self setSelection:nil];
        }
    }
}

#pragma mark -
#pragma mark Fetched Results Controller Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self configureCell:(ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
        
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ContactCell *cell = (ContactCell *)[[tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    // Configure Table View Cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Fetch Record
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Update Cell
    [cell.nameLabel setText:[record valueForKey:@"first_name"]];
    [cell.lastNameLabel setText:[record valueForKey:@"last_name"]];
    
    NSString* str = [record valueForKey:@"jpg"];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];

    UIImage* image = [UIImage imageWithData: data];

    if ([UIImage imageWithData:data])
    {
        [cell.picture setImage:[UIImage imageWithData:data]];
    }else
    {
        //[cell.picture setImage:@"button-done-normal.png"];
    }

     
     [cell setDidTapButtonBlock:^{
        BOOL isDone = [[record valueForKey:@"done"] boolValue];
        
        // Update Record
        [record setValue:@(!isDone) forKey:@"done"];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (record)
        {
            [self.fetchedResultsController.managedObjectContext deleteObject:record];
        }
    }
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Store Selection
    [self setSelection:indexPath];
    
    // Perform Segue
    [self performSegueWithIdentifier:@"ContactDetailSeque" sender:self];
}

#pragma mark -
#pragma mark Core Data Stack
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sndrContact" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"sndrContact.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Helper Methods
- (void)saveManagedObjectContext
{
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error])
    {
        if (error)
        {
            NSLog(@"Unable to save changes.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
}

- (IBAction)backToTheStart:(UIStoryboardSegue *)segue
{
    
    // grab a reference
    ContactDetailViewController *contactViewController = segue.sourceViewController;

}


@end
