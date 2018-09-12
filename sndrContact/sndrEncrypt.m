//
//  sndrEncrypt.m
//  sndrContact
//
//  Created by Denis Arsenault on 9/11/18.
//  Copyright © 2018 sndr. All rights reserved.
//

#import "sndrEncrypt.h"

@implementation sndrEncrypt

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


@end
