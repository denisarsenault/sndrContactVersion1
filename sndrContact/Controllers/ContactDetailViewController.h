//
//  NSURLConnectionViewController.h
//  sndrContact
//
//  Created by Denis Arsenault on 9/8/18.
//  Copyright (c) 2018 Sndr LLC All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDetailViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
