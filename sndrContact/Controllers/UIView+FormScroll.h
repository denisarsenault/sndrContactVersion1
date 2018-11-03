//
//  UIView+FormScroll.h
//  sndrContact
//
//  Created by Denis Arsenault on 11/2/18.
//  Copyright © 2018 sndr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface UIView (FormScroll)

-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view;
-(void)scrollElement:(UIView *)view toPoint:(float)y;

@end
