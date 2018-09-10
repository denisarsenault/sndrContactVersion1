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


@end

@implementation ContactDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    }
    
//    UIImage *image = [UIImage imageNamed:@"imageName.jpg"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//
//    self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
}

- (IBAction)loadDataHandler:(id)sender
{
    [self.activityIndicator startAnimating];
//
//    [[self.urlSession dataTaskWithURL:[NSURL URLWithString:self.textField.text] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.activityIndicator stopAnimating];
//            if (!error) {
//                self.textView.text = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
//                self.textView.textColor = [UIColor blackColor];
//            } else {
//                self.textView.text = error.description;
//                self.textView.textColor = [UIColor redColor];
//            }
//        });
//    }] resume];
}

#pragma mark - NSURLSession delegate

//-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
//
//    // Get remote certificate
//    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
//    SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
//
//    // Set SSL policies for domain name check
//    NSMutableArray *policies = [NSMutableArray array];
//    [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)challenge.protectionSpace.host)];
//    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
//
//    // Evaluate server certificate
//    SecTrustResultType result;
//    SecTrustEvaluate(serverTrust, &result);
//    BOOL certificateIsValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
//
//    // Get local and remote cert data
//    NSData *remoteCertificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
//    NSString *pathToCert = [[NSBundle mainBundle]pathForResource:@"github.com" ofType:@"cer"];
//    NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCert];
//
//    // The pinnning check
//    if ([remoteCertificateData isEqualToData:localCertificate] && certificateIsValid) {
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
//        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
//    } else {
//        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
//    }
//}

@end
