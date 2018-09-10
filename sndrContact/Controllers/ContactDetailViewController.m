//
//  NSURLConnectionViewController.m
//  sndrContact
//
//  Created by Denis Arsenault on 9/8/18.
//  Copyright (c) 2018 Sndr LLC All rights reserved.
//

#import "ContactDetailViewController.h"

@interface ContactDetailViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *ContactDetailViewController;

- (IBAction)Back:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Back;


@end

@implementation ContactDetailViewController

- (IBAction)Back:(id)sender
{
    //[self dismissController: nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    if (self.record)
    {
        // Update Text Field
        [self.first_name setText:[self.record valueForKey:@"first_name"]];
        [self.last_name setText:[self.record valueForKey:@"last_name"]];
        [self.company_name setText:[self.record valueForKey:@"company_name"]];
        [self.address setText:[self.record valueForKey:@"address"]];
        [self.city setText:[self.record valueForKey:@"city"]];
        [self.state setText:[self.record valueForKey:@"state"]];
        [self.county setText:[self.record valueForKey:@"county"]];
        [self.zip setText:[self.record valueForKey:@"zip"]];
        [self.phone1 setText:[self.record valueForKey:@"phone1"]];
        [self.phone2 setText:[self.record valueForKey:@"phone2"]];
        [self.email setText:[self.record valueForKey:@"email"]];
        [self.web setText:[self.record valueForKey:@"web"]];
        
        
        NSString* str = [self.record valueForKey:@"jpg"];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        UIImage* image = [UIImage imageWithData: data];
        
        if ([UIImage imageWithData:data])
        {
            [self.jpg setImage:[UIImage imageWithData:data]];
        }else
        {
            //[self.jpg setImage:@"button-done-normal.png"];
        }
    }
    [self.activityIndicator stopAnimating];
}

#pragma mark - NSURLSession delegate


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // was this the cancel button?
    if (sender == self.Back) return;
    // do any preparation here when the segue is called
}

- (IBAction)first_name:(id)sender
{
    self.first_name.userInteractionEnabled = YES;
}
@end
