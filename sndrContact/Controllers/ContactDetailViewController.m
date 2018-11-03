//
//  NSURLConnectionViewController.m
//  sndrContact
//
//  Created by Denis Arsenault on 9/8/18.
//  Copyright (c) 2018 Sndr LLC All rights reserved.
//

#import "ContactDetailViewController.h"
#import "RNCryptor iOS.h"
#import "RNDecryptor.h"
#import "UIView+FormScroll.h"

@interface ContactDetailViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *ContactDetailViewController;

- (IBAction)Back:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Back;


@end

@implementation ContactDetailViewController

UIGestureRecognizer *tapper;
BOOL moved = NO;

- (IBAction)Back:(id)sender
{
    //[self dismissController: nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view scrollToView:textField];
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.view scrollToY:0];
    [textField resignFirstResponder];
}


//- (bool)textFieldShouldReturn:textField
//{
//
//    [self.view endEditing:YES];
//
//    return true;
//
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    self.first_name.delegate = self;
    self.last_name.delegate = self;
    self.company_name.delegate = self;
    self.address.delegate = self;
    self.city.delegate = self;
    self.state.delegate = self;
    self.county.delegate = self;
    self.zip.delegate = self;
    self.phone1.delegate = self;
    self.phone2.delegate = self;
    self.email.delegate = self;
    self.web.delegate = self;
    
    
    if (self.record)
    {

        // Update Text Field
        NSString* test = [self RNDecrypt:[self.record valueForKey:@"first_name"]];
        NSLog(@"============================== %@", test);
        
        [self.first_name setText:[self RNDecrypt:[self.record valueForKey:@"first_name"]]];
        [self.last_name setText:[self RNDecrypt:[self.record valueForKey:@"last_name"]]];
        [self.company_name setText:[self RNDecrypt:[self.record valueForKey:@"company_name"]]];
        [self.address setText:[self RNDecrypt:[self.record valueForKey:@"address"]]];
        [self.city setText:[self RNDecrypt:[self.record valueForKey:@"city"]]];
        [self.state setText:[self RNDecrypt:[self.record valueForKey:@"state"]]];
        [self.county setText:[self RNDecrypt:[self.record valueForKey:@"county"]]];
        [self.zip setText:[self RNDecrypt:[self.record valueForKey:@"zip"]]];
        [self.phone1 setText:[self RNDecrypt:[self.record valueForKey:@"phone1"]]];
        [self.phone2 setText:[self RNDecrypt:[self.record valueForKey:@"phone2"]]];
        [self.email setText:[self RNDecrypt:[self.record valueForKey:@"email"]]];
        [self.web setText:[self RNDecrypt:[self.record valueForKey:@"web"]]];
        
        NSString* str = [self RNDecrypt:[self.record valueForKey:@"jpg"]];
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
    
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    [self.activityIndicator stopAnimating];
}

- (IBAction)save:(id)sender
{
    // Helpers
    NSString *name = self.first_name.text;
    if (name && name.length)
    {
        // Populate Record
        [self.record setValue:[self RNEncrypt:self.first_name.text] forKey:@"first_name"];
        [self.record setValue:[self RNEncrypt:self.last_name.text] forKey:@"last_name"];
        [self.record setValue:[self RNEncrypt:self.company_name.text] forKey:@"company_name"];
        [self.record setValue:[self RNEncrypt:self.address.text] forKey:@"address"];
        [self.record setValue:[self RNEncrypt:self.city.text] forKey:@"city"];
        [self.record setValue:[self RNEncrypt:self.state.text] forKey:@"state"];
        [self.record setValue:[self RNEncrypt:self.county.text] forKey:@"county"];
        [self.record setValue:[self RNEncrypt:self.zip.text] forKey:@"zip"];
        [self.record setValue:[self RNEncrypt:self.phone1.text] forKey:@"phone1"];
        [self.record setValue:[self RNEncrypt:self.phone2.text] forKey:@"phone2"];
        [self.record setValue:[self RNEncrypt:self.email.text] forKey:@"email"];
        [self.record setValue:[self RNEncrypt:self.web.text] forKey:@"web"];
        
        // Save Record
        NSError *error = nil;
        
        if ([self.managedObjectContext save:&error])
        {
            // Pop View Controller
            [self.navigationController popViewControllerAnimated:YES];
            
        } else
        {
            if (error)
            {
                NSLog(@"Unable to save record.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            // Show Alert View
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your contacts could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    } else {
        // Show Alert View
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your contact needs a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

//- (void)keyboardDidShow: (NSNotification *) notif
//{
//    //Keyboard becomes visible
//    ContactScrollView.frame = CGRectMake(scrollView.frame.origin.x,
//                                  scrollView.frame.origin.y - 220,
//                                  scrollView.frame.size.width,
//                                  scrollView.frame.size.height);   //move up
//}
//
//- (void)keyboardDidHide: (NSNotification *) notif
//{
//    //keyboard will hide
//    scrollView.frame = CGRectMake(scrollView.frame.origin.x,
//                                  scrollView.frame.origin.y + 220,
//                                  scrollView.frame.size.width,
//                                  scrollView.frame.size.height);   //move down
//}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if(!moved)
//    {
//        [self animateViewToPosition:self.view directionUP:YES];
//        moved = YES;
//    }
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//}
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    if(moved)
//    {
//        [self animateViewToPosition:self.view directionUP:NO];
//    }
//    moved = NO;
//    return YES;
//}


-(void)animateViewToPosition:(UIView *)viewToMove directionUP:(BOOL)up
{
    
    const int movementDistance = -60; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
    [UIView commitAnimations];
}

//-(bool)textFieldShouldReturn:textField
//{
//    [textField setReturnKeyType:UIReturnKeyDone];
//    [textField resignFirstResponder];
//    return true;
//}

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

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

@end

