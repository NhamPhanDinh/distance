//
//  AppDelegate.h
//  PupilsDistance
//
//  Created by Trinh Van Duong on 2/12/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasureViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UITabBarController *_tabBar;
    MeasureViewController *_measureView;
}

+(AppDelegate *)shareApp;

@property (assign, nonatomic) int typeColor;
@property (assign, nonatomic) int typeTargetSize;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;


@end

