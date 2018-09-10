//
//  AppDelegate.m
//  sndrContact
//
//  Created by Denis Arsenault on 9/8/18.
//  Copyright (c) 2018 Sndr LLC All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Entity+CoreDataClass.h"
#import "Entity+CoreDataProperties.h"

@interface AppDelegate () //<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    bool success = true;
    // Get the core data path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", [paths objectAtIndex:0]);
    return success;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Save Managed Object Context
    [self saveContext];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save Managed Object Context
    [self saveContext];
    
    /*
     NSError *error = nil;
     
     if (![self.managedObjectContext save:&error]) {
     if (error) {
     NSLog(@"Unable to save changes.");
     NSLog(@"%@, %@", error, error.localizedDescription);
     }
     }
     */
}

#pragma mark - Get data

- (bool)getData
{
    bool success = NO;
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://sndr.com/wp-content/uploads/2018/09/testDataJson.txt"];
    NSData *jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *cleanJSONData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *cleanJson = [NSJSONSerialization JSONObjectWithData: cleanJSONData options:kNilOptions error:nil];
    
    NSError *err = nil;
    
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
        
        NSDictionary *contactDictionary = [json objectAtIndex:0];
        
        //{
        //    "First_name": "Josephine",
        //    "last_name": "Darakjy",
        //    "company_name": "effrey A Chanay Esq",
        //    "address": "4 B Blue Ridge Blvd",
        //    "city": "Brighton",
        //    "county": "Livingston",
        //    "state": "MI",
        //    "zip": 48116,
        //    "phone1": "810-292-9388",
        //    "phone2": "810-374-9840",
        //    "email": "josephine_darakjy@darakjy.org",
        //    "web": "http://www.chanayjeffreyaesq.com",
        //    "jpg": ""
        //}
        
        //NSLog(@"contactDictionary:==== %@ ====", contactDictionary);
        
        // Populate Record
        [record setValue:[contact objectForKey:@"First_name"] forKey:@"first_name"];
        [record setValue:[contact objectForKey:@"last_name"]  forKey:@"last_name"];
        [record setValue:[[contact objectForKey:@"company_name"] description] forKey:@"company_name"];
        [record setValue:[[contact objectForKey:@"address"]  description] forKey:@"address"];
        [record setValue:[[contact objectForKey:@"city"] description] forKey:@"city"];
        [record setValue:[[contact objectForKey:@"county"] description] forKey:@"county"];
        [record setValue:[[contact objectForKey:@"state"]  description] forKey:@"state"];
        [record setValue:[[contact objectForKey:@"zip"] description] forKey:@"zip"];
        [record setValue:[[contact objectForKey:@"phone1"] description] forKey:@"phone1"];
        [record setValue:[[contact objectForKey:@"phone2"] description] forKey:@"phone2"];
        [record setValue:[[contact objectForKey:@"email"]  description] forKey:@"email"];
        [record setValue:[[contact objectForKey:@"web"]  description] forKey:@"web"];
        [record setValue:[[contact objectForKey:@"jpg"]   description] forKey:@"jpg"];
        NSLog(@"record:==== %@ ====", record);
        
        // Save Record
        [self saveContext];
        
    }
    
    return success;
}


#pragma mark - Core Data stack

- (NSURL*)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mybrightzone.CoreDataSample" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel*)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sndrContact" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSManagedObjectContext*)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
    {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    // Persistant Data Store
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"sndrContact.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // This would have a better error handling strategy in a shipping application
        // abort() would generate a crash log and terminate.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}
 



@end
