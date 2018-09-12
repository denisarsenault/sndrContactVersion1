//
//  sndrEncrypt.h
//  sndrContact
//
//  Created by Denis Arsenault on 9/11/18.
//  Copyright © 2018 sndr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNCryptor iOS.h"

@interface sndrEncrypt : NSObject

- (NSString*)RNEncrypt:(NSString *)dataString;
- (NSString*)RNDecrypt:(NSString*)dataString;

@end
