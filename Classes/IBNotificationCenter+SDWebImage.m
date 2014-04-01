//
//  IBNotificationCenter+SDWebImage.m
//
//  Created by Ivan Bruel on 01/04/14.
//  Copyright (c) 2014 Ivan Bruel. All rights reserved.
//

#import "IBNotificationCenter+SDWebImage.h"
#import "IBNotificationCenter+Private.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation IBNotificationCenter (SDWebImage)

-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImageURL:(NSURL *)imageURL{
    [self showNotificationWithTitle:title withSubtitle:subtitle withImageURL:imageURL withPlaceholder:nil];
}

-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImageURL:(NSURL *)imageURL withPlaceholder:(UIImage *)placeholder{
    [self showNotificationWithTitle:title withSubtitle:subtitle withImageURL:imageURL withPlaceholder:placeholder clicked:nil];
}

-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImageURL:(NSURL *)imageURL withPlaceholder:(UIImage *)placeholder clicked:(void (^)(void))clicked{
    [self showNotificationWithTitle:title withSubtitle:subtitle withImageURL:imageURL withPlaceholder:placeholder clicked:nil vibrate:NO];
}

-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImageURL:(NSURL *)imageURL withPlaceholder:(UIImage *)placeholder clicked:(void (^)(void))clicked vibrate:(BOOL)vibrate{
    [self showNotificationWithTitle:title withSubtitle:subtitle withImageURL:imageURL withPlaceholder:placeholder clicked:clicked vibrate:vibrate showLocalNotificationWhenInBackground:NO withNotificationUserInfo:nil];
}

-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImageURL:(NSURL *)imageURL withPlaceholder:(UIImage *)placeholder clicked:(void (^)(void))clicked vibrate:(BOOL)vibrate showLocalNotificationWhenInBackground:(BOOL)showLocalNotificationWhenInBackground withNotificationUserInfo:(NSDictionary *)userInfo{
    [self showNotificationWithTitle:title withSubtitle:subtitle withImage:placeholder clicked:clicked vibrate:vibrate showLocalNotificationWhenInBackground:showLocalNotificationWhenInBackground withNotificationUserInfo:userInfo];
    if([[UIApplication sharedApplication]applicationState] == UIApplicationStateActive){
        dispatch_async(self.serialDispatchQueue, ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.notificationImageView setImageWithURL:imageURL placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                }];
            });
        });
    }
}



@end
