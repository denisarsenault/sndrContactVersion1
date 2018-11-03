//
//  ContactViewController.m
//  sndrContact
//
//  Created by Denis Arsenault on 9/8/18.
//  Copyright (c) 2018 Denis Arsenault All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactViewController.h"
#import "ContactCell.h"
#import <AFNetworking/AFNetworking.h>
#import "ContactDetailViewController.h"
#import "AppDelegate.h"



@interface ContactViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ContactViewController;
@property (weak, nonatomic) IBOutlet UIButton *loaddata;
@property (weak, nonatomic) IBOutlet UIButton *DeleteAllRecords;

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

//UIGestureRecognizer *tapper;

#pragma mark - TableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    if (![self.fetchedResultsController performFetch:&error])
    {
        // Show Alert View
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"New Data Fetched"
                                     preferredStyle:UIAlertControllerStyleAlert];
        //Add Buttons
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
        
        
        //Add your buttons to alert controller
        
        [alert addAction:okButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    if (error)
    {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    if ([[self.fetchedResultsController sections] count] == 0)
    {
        // Show Alert View
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning"
                                     message:@"Error was encountered, Check network connection"
                                     preferredStyle:UIAlertControllerStyleAlert];
        //Add Buttons
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
        
        
        //Add your buttons to alert controller
        
        [alert addAction:okButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
//    tapper = [[UITapGestureRecognizer alloc]
//              initWithTarget:self action:@selector(handleSingleTap:)];
//    tapper.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapper];

}

#pragma mark - Networking

- (IBAction)fetchData:(id)sender
{

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

            if (record)
            {
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
    [cell.nameLabel setText:[self RNDecrypt:[record valueForKey:@"first_name"]]];
    [cell.lastNameLabel setText:[self RNDecrypt:[record valueForKey:@"last_name"]]];
    
    NSString* str = [self RNDecrypt:[record valueForKey:@"jpg"]];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];

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
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc]  initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sndrContact" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
     }
    
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"sndrContact.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
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

#pragma mark - Get data

- (bool)getData
{
    [self.activityIndicator startAnimating];
    
    bool success = NO;
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://sndr.com/wp-content/uploads/2018/09/testDataJson.txt"];
    NSData *jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *cleanJSONData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *cleanJson = [NSJSONSerialization JSONObjectWithData: cleanJSONData options:kNilOptions error:nil];
    
    NSDictionary *contactDictionary = [cleanJson objectAtIndex:0];
    NSString *test = [contactDictionary objectForKey:@"First_name"];
    NSLog(@"Test is %@",test);
    //NSLog(@"json: %@", json);
    
    if (json)
    {
        success = YES;
    }
    
    // Load Json into core data
    
    NSArray *contacts = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    for(NSDictionary *contact in contacts)
    {
        // Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];
        
        // Initialize Record
        NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];

        // Populate Record
//        [record setValue:[contact objectForKey:@"First_name"] forKey:@"first_name"];
//        [record setValue:[contact objectForKey:@"last_name"]  forKey:@"last_name"];
//        [record setValue:[[contact objectForKey:@"company_name"] description] forKey:@"company_name"];
//        [record setValue:[[contact objectForKey:@"address"]  description] forKey:@"address"];
//        [record setValue:[[contact objectForKey:@"city"] description] forKey:@"city"];
//        [record setValue:[[contact objectForKey:@"county"] description] forKey:@"county"];
//        [record setValue:[[contact objectForKey:@"state"]  description] forKey:@"state"];
//        [record setValue:[[contact objectForKey:@"zip"] description] forKey:@"zip"];
//        [record setValue:[[contact objectForKey:@"phone1"] description] forKey:@"phone1"];
//        [record setValue:[[contact objectForKey:@"phone2"] description] forKey:@"phone2"];
//        [record setValue:[[contact objectForKey:@"email"]  description] forKey:@"email"];
//        [record setValue:[[contact objectForKey:@"web"]  description] forKey:@"web"];
//        [record setValue:[[contact objectForKey:@"jpg"]   description] forKey:@"jpg"];
        
        // Populate Record
        NSLog(@"contact:==== %@ ====", contact);
        [record setValue:[self RNEncrypt:[contact objectForKey:@"First_name"]] forKey:@"first_name"];
        [record setValue:[self RNEncrypt:[contact objectForKey:@"last_name"]] forKey:@"last_name"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"company_name"] description]] forKey:@"company_name"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"address"]  description]]  forKey:@"address"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"city"] description]] forKey:@"city"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"state"]  description]] forKey:@"state"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"county"] description]] forKey:@"county"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"zip"] description]] forKey:@"zip"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"phone1"] description]] forKey:@"phone1"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"phone2"] description]] forKey:@"phone2"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"email"]  description]] forKey:@"email"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"web"]  description]] forKey:@"web"];
        [record setValue:[self RNEncrypt:[[contact objectForKey:@"jpg"]  description]] forKey:@"jpg"];
        NSLog(@"record:==== %@ ====", record);
        
        // Save Record
        [self saveContext];
        
    }
    [self.activityIndicator stopAnimating];
    return success;
}

#pragma mark - Core Data support

- (void)saveContext
{
    NSManagedObjectContext*managedObjectContext = self.managedObjectContext;
    
    if(managedObjectContext != nil)
    {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // This would have a better error handling strategy in a shipping application
            // abort() would generate a crash log and terminate.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)Delete
{
    [self.activityIndicator startAnimating];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
    
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [_persistentStoreCoordinator executeRequest:delete withContext:_managedObjectContext error:&deleteError];
    
    [self.activityIndicator stopAnimating];
    
}

#pragma mark -
#pragma mark Return Segue

- (IBAction)backToTheStart:(UIStoryboardSegue *)segue
{
    
    // grab a reference
    //ContactDetailViewController *contactViewController = segue.sourceViewController;

}

- (NSString*)RNEncrypt:(NSString *)dataString
{
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:@"sndr"
                                               error:&error];
    if (error)
    {
        NSLog(@"Decrypt error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSString * encryptedString = [encryptedData base64EncodedStringWithOptions:0];
    
    return encryptedString;
}

- (NSString*)RNDecrypt:(NSString*)dataString
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:dataString options:0];

    NSError *error;
    NSData *decryptedData = [RNDecryptor decryptData:data
                                        withPassword:@"sndr"
                                               error:&error];
    if (error)
    {
        NSLog(@"Decrypt error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSString * decryptedString = [[NSString alloc] initWithData:decryptedData
                                                       encoding:NSUTF8StringEncoding];
    return decryptedString;
}


#pragma mark -
#pragma mark Button Methods

- (IBAction)loaddata:(id)sender
{
    [self Delete];
    [self getData];
}

- (IBAction)deleteAll:(id)sender
{

    [self Delete];
    // Save Record
    [self saveContext];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}


@end
