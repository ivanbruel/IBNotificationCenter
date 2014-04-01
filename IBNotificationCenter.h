//
//  IBNotificationCenter.h
//
//  Created by Ivan Bruel on 31/03/14.
//  Copyright (c) 2014 Ivan Bruel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBNotificationCenter : NSObject<UIGestureRecognizerDelegate>

+(IBNotificationCenter*)sharedInstance;

-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImage:(UIImage*)image;
-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImage:(UIImage*)image clicked:(void (^)(void))clicked;
-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImage:(UIImage*)image clicked:(void (^)(void))clicked vibrate:(BOOL)vibrate;
-(void)showNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImage:(UIImage*)image clicked:(void (^)(void))clicked vibrate:(BOOL)vibrate showLocalNotificationWhenInBackground:(BOOL)showLocalNotificationWhenInBackground withNotificationUserInfo:(NSDictionary*)notificationUserInfo;

-(void)hideNotifications;
-(void)hideNotificationsAnimated:(BOOL)animated;
-(BOOL)isVisible;
@end
