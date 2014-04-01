//
//  IBNotificationCenter+Private.h
//
//  Created by Ivan Bruel on 01/04/14.
//  Copyright (c) 2014 Ivan Bruel. All rights reserved.
//

#import "IBNotificationCenter.h"

@interface IBNotificationCenter (Private)

@property(nonatomic,strong) UIWindow* notificationWindow;
@property(nonatomic,strong) UILabel* notificationTitleLabel;
@property(nonatomic,strong) UILabel* notificationSubtitleLabel;
@property(nonatomic,strong) UIImageView* notificationImageView;
@property(nonatomic,strong) UIButton* notificationCloseButton;

@property(nonatomic,strong) dispatch_queue_t serialDispatchQueue;

@end

