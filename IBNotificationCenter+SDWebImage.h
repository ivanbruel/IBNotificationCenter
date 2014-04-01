//
//  IBNotificationCenter+SDWebImage.h
//
//  Created by Ivan Bruel on 01/04/14.
//  Copyright (c) 2014 Ivan Bruel. All rights reserved.
//

#import "IBNotificationCenter.h"

@interface IBNotificationCenter (SDWebImage)

-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImageURL:(NSURL*)imageURL;
-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImageURL:(NSURL*)imageURL withPlaceholder:(UIImage*)placeholder;
-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImageURL:(NSURL*)imageURL withPlaceholder:(UIImage*)placeholder clicked:(void (^)(void))clicked;
-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImageURL:(NSURL*)imageURL withPlaceholder:(UIImage*)placeholder clicked:(void (^)(void))clicked vibrate:(BOOL)vibrate;
-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImageURL:(NSURL*)imageURL withPlaceholder:(UIImage*)placeholder clicked:(void (^)(void))clicked vibrate:(BOOL)vibrate showLocalNotificationWhenInBackground:(BOOL)showLocalNotificationWhenInBackground withNotificationUserInfo:(NSDictionary*)userInfo;

@end
