//
//  IBNotificationCenter.m
//
//  Created by Ivan Bruel on 31/03/14.
//  Copyright (c) 2014 Ivan Bruel. All rights reserved.
//
#import "IBNotificationCenter.h"

#import <AudioToolbox/AudioServices.h>

CGFloat const IBNotificationHeight = 70.0f;
CGFloat const IBNotificationImageSize = 44.0f;
CGFloat const IBNotificationMargin = 10.0f;
CGFloat const IBNotificationLabelHeight = 16.0f;
CGFloat const IBNotificationButtonSize = 40.0f;
CGFloat const IBNotificationAnimationDuration = 0.35f;
CGFloat const IBNotificationHideTimer = 5.0f;

@interface IBNotificationCenter ()

@property(nonatomic,strong) UIWindow* notificationWindow;
@property(nonatomic,strong) UILabel* notificationTitleLabel;
@property(nonatomic,strong) UILabel* notificationSubtitleLabel;
@property(nonatomic,strong) UIImageView* notificationImageView;
@property(nonatomic,strong) UIButton* notificationCloseButton;

@property(nonatomic,strong) dispatch_queue_t serialDispatchQueue;

@property(nonatomic,readwrite) BOOL isNotificationVisible;

@property(nonatomic,strong) UIWindow* primaryWindow;

@property (copy) void (^clickedBlock) (void);

@end

@implementation IBNotificationCenter



#pragma mark - Shared Instance
+(IBNotificationCenter *)sharedInstance{
    
    static IBNotificationCenter *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IBNotificationCenter alloc] init];
        [sharedInstance commonInit];
    });
    
    return sharedInstance;
}

#pragma mark - Initializer
-(void)commonInit{
    CGFloat screenWidth = [[UIScreen mainScreen]bounds].size.width;
    
    // Init the main window
    self.notificationWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, screenWidth, IBNotificationHeight)];
    self.notificationWindow.windowLevel = UIWindowLevelStatusBar+1.0f;
    [self.notificationWindow setBackgroundColor:[UIColor clearColor]];
    
    // Init the blur background
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:self.notificationWindow.frame];
    [toolbar setBarStyle:UIBarStyleBlack];
    [self.notificationWindow addSubview:toolbar];
    
    // Init the image view
    self.notificationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(IBNotificationMargin, (IBNotificationHeight - IBNotificationImageSize)/2.0f, IBNotificationImageSize, IBNotificationImageSize)];
    [self.notificationImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.notificationImageView setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5]];
    
    // Round the imageView
    self.notificationImageView.layer.cornerRadius = self.notificationImageView.frame.size.height/2.0f;
    self.notificationImageView.layer.masksToBounds = YES;
    
    // Add imageView to the main window
    [self.notificationWindow addSubview:self.notificationImageView];
    
    // Init close button
    CGFloat buttonOriginX = screenWidth - IBNotificationButtonSize - IBNotificationMargin;
    self.notificationCloseButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonOriginX, (IBNotificationHeight - IBNotificationButtonSize)/2.0f , IBNotificationButtonSize, IBNotificationButtonSize)];
    [self.notificationCloseButton addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Customize button
    [self.notificationCloseButton setImage:[UIImage imageNamed:@"IBNotificationCenter.bundle/close"] forState:UIControlStateNormal];
    
    // Add the button to the main window
    [self.notificationWindow addSubview:self.notificationCloseButton];
    
    
    // Init the title label
    CGFloat labelOriginX = (IBNotificationMargin * 2) + IBNotificationImageSize;
    self.notificationTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelOriginX, self.notificationImageView.center.y - IBNotificationLabelHeight - IBNotificationMargin/2.0f, screenWidth - labelOriginX - IBNotificationButtonSize - IBNotificationMargin, IBNotificationLabelHeight)];
    
    // Customize title label
    [self.notificationTitleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [self.notificationTitleLabel setTextColor:[UIColor whiteColor]];
    
    // Add title label to the main window
    [self.notificationWindow addSubview:self.notificationTitleLabel];
    
    // Init the subtitle label
    self.notificationSubtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelOriginX, self.notificationImageView.center.y + IBNotificationMargin/2.0f, screenWidth - labelOriginX - IBNotificationButtonSize - IBNotificationMargin, IBNotificationLabelHeight)];
    
    // Customize subtitle label
    [self.notificationSubtitleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.notificationSubtitleLabel setTextColor:[UIColor whiteColor]];
    
    // Add subtitle label to the main window
    [self.notificationWindow addSubview:self.notificationSubtitleLabel];
    
    // Add Tap gesture
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notificationClick:)];
    tapGestureRecognizer.delegate = self;
    [self.notificationWindow addGestureRecognizer:tapGestureRecognizer];
    
    // Add Swipe gesture
    UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeClick:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.notificationWindow addGestureRecognizer:swipeGestureRecognizer];
    
    // Force hidden at start
    [self hideNotificationCenterAnimated:NO];
    
    // Init the dispatch queue
    self.serialDispatchQueue = dispatch_queue_create([@"IBNotificationCenter" UTF8String], DISPATCH_QUEUE_SERIAL);
}

#pragma mark - IBActions
-(IBAction)closeClick:(id)sender{
    [self hideNotificationCenterAnimated:YES];
}

-(IBAction)notificationClick:(id)sender{
    if(self.clickedBlock != nil)
        self.clickedBlock();
    [self hideNotificationCenterAnimated:YES];
}

#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

#pragma mark - UI Changes
-(void)hideNotificationCenterAnimated:(BOOL)animated{
    [UIView animateWithDuration:animated?IBNotificationAnimationDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.notificationWindow.frame;
        frame.origin.y = -IBNotificationHeight;
        self.notificationWindow.frame = frame;
        self.isNotificationVisible = NO;
        self.primaryWindow = [[UIApplication sharedApplication]keyWindow];
        [self.notificationWindow makeKeyAndVisible];
        
    } completion:nil];
}

-(void)showNotificationCenterAnimated:(BOOL)animated{
    [UIView animateWithDuration:animated?IBNotificationAnimationDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.notificationWindow.frame;
        frame.origin.y = 0;
        self.notificationWindow.frame = frame;
        self.isNotificationVisible = YES;
        [self.primaryWindow makeKeyWindow];
        self.primaryWindow = nil;
    } completion:nil];
}

-(void)updateNotificationWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle withImage:(UIImage*)image clicked:(void (^)(void))clicked{
    [self.notificationTitleLabel setText:title];
    [self.notificationSubtitleLabel setText:subtitle];
    [self.notificationImageView setImage:image];
    self.clickedBlock = clicked;
}

#pragma mark - Public API
-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImage:(UIImage *)image{
    [self showNotificationWithTitle:title withSubtitle:subtitle withImage:image clicked:nil];
}

-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImage:(UIImage *)image clicked:(void (^)(void))clicked{
    [self showNotificationWithTitle:title withSubtitle:subtitle withImage:image clicked:clicked vibrate:NO];
}

-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImage:(UIImage *)image clicked:(void (^)(void))clicked vibrate:(BOOL)vibrate{
    [self showNotificationWithTitle:title withSubtitle:subtitle withImage:image clicked:clicked vibrate:vibrate showLocalNotificationWhenInBackground:NO withNotificationUserInfo:nil];
}

-(void)showNotificationWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImage:(UIImage *)image clicked:(void (^)(void))clicked vibrate:(BOOL)vibrate showLocalNotificationWhenInBackground:(BOOL)showLocalNotificationWhenInBackground withNotificationUserInfo:(NSDictionary *)notificationUserInfo{
    if([[UIApplication sharedApplication]applicationState] == UIApplicationStateActive){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideNotifications) object:nil];
        dispatch_async(self.serialDispatchQueue, ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(vibrate){
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                [self updateNotificationWithTitle:title withSubtitle:subtitle withImage:image clicked:clicked];
                if(!self.isNotificationVisible)
                    [self showNotificationCenterAnimated:YES];
                [self performSelector:@selector(hideNotifications) withObject:nil afterDelay:IBNotificationHideTimer];
            });
        });
    }else{
        if(showLocalNotificationWhenInBackground){
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            [notification setAlertBody:[NSString stringWithFormat:@"%@\n%@",title,subtitle]];
            [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            [notification setTimeZone:[NSTimeZone defaultTimeZone]];
            [notification setUserInfo:notificationUserInfo];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

-(void)hideNotifications{
    [self hideNotificationsAnimated:YES];
}

-(void)hideNotificationsAnimated:(BOOL)animated{
    [self hideNotificationCenterAnimated:animated];
}

-(BOOL)isVisible{
    return self.isNotificationVisible;
}

@end
