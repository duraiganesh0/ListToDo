//
//  UIPlaceHolderTextView.h
//  ListTodo
//
//  Created by Ganesh on 20/01/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


IB_DESIGNABLE
@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
