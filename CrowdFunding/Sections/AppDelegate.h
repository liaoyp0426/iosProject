//
//  AppDelegate.h
//  CrowdFunding
//
//  Created by liaoyp on 15/1/21.
//  Copyright (c) 2015年 CF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootViewController;

+ (AppDelegate *)getAppDelegate;

@end

