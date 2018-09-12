//
//  ContactViewController.h
//  sndrContact
//
//  Created by Denis Arsenault on 9/8/18.
//  Copyright (c) 2018 Sndr LLC All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "sndrEncrypt.h"

@interface ContactViewController :UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSManagedObject *record;

- (NSString*)RNEncrypt:(NSString *)dataString;
- (NSString*)RNDecrypt:(NSString*)dataString;

@end
