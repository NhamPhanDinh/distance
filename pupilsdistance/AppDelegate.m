//
//  AppDelegate.m
//  PupilsDistance
//
//  Created by Trinh Van Duong on 2/12/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate (){
    NSTimer *timer;
}

@end

@implementation AppDelegate

static AppDelegate *shared;

+ (AppDelegate*)shareApp
{
    if (shared==nil) {
        return (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return shared;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.typeColor = 3;
    self.typeTargetSize = 0;
    
    _measureView = [[MeasureViewController alloc]initWithNibName:@"MeasureViewController" bundle:nil];
    UINavigationController *firstNav = [[UINavigationController alloc]initWithRootViewController:_measureView];
    firstNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Measure" image:[UIImage imageNamed:@"2.png"] selectedImage:[UIImage imageNamed:@"2.png"]];
    [firstNav.navigationBar setClipsToBounds:YES];
    firstNav.navigationBar.hidden = YES;
    
//    _historyView = [[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:nil];
//    UINavigationController *secondNav = [[UINavigationController alloc]initWithRootViewController:_historyView];
//    secondNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"History" image:[UIImage imageNamed:@"3.png"] selectedImage:[UIImage imageNamed:@"3.png"]];
//    [secondNav.navigationBar setClipsToBounds:YES];
//    secondNav.navigationBar.hidden = YES;
//    
//    _settingView = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
//    UINavigationController *thirdNav = [[UINavigationController alloc]initWithRootViewController:_settingView];
//    thirdNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"4.png"] selectedImage:[UIImage imageNamed:@"4.png"]];
//    [thirdNav.navigationBar setClipsToBounds:YES];
//    thirdNav.navigationBar.hidden = YES;
    
    //setup UITabController
//    _tabBar = [[UITabBarController alloc]init];
//    [_tabBar setViewControllers:[[NSArray alloc] initWithObjects:firstNav,secondNav,thirdNav, nil]];
//    _tabBar.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_selected.png"];
//    _tabBar.tabBar.tintColor = [UIColor whiteColor];
//    _tabBar.tabBar.backgroundColor = [UIColor blackColor];
    
    [self.window setRootViewController:firstNav];
    [self.window makeKeyAndVisible];
    [self customTabBar];

    return YES;
}

- (void)customTabBar{
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f]];
    
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0f green:175/255.0f blue:181/255.0f alpha:1.0f], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f] } forState:UIControlStateNormal ];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Noteworthy-Bold" size:17.0f] } forState:UIControlStateSelected ];
    
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    //Nav
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar_back.png"] forBarMetrics:UIBarMetricsDefault];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
