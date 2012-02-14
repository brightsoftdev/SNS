//
//  AppDelegate.m
//  SNS
//
//  Created by  on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "SettingController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController;


- (void)dealloc
{
    [_window release];
    [tabBarController release];
    
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    HomeController *homeController = [[[HomeController alloc] init] autorelease];
    UINavigationController *homeNavigation = [[[UINavigationController alloc] 
                                                initWithRootViewController:homeController] autorelease];
    homeNavigation.navigationBar.barStyle = UIBarStyleBlack;
    homeNavigation.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"信息流"
                                                               image:[UIImage imageNamed:@"home.png"]
                                                                 tag:0] autorelease];
    
    SettingController *settingController = [[[SettingController alloc] init] autorelease];
    UINavigationController *settingNavigation = [[[UINavigationController alloc] 
                                                 initWithRootViewController:settingController] autorelease];
    settingNavigation.navigationBar.barStyle = UIBarStyleBlack;
    settingNavigation.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"设置"
                                                                  image:[UIImage imageNamed:@"setting.png"]
                                                                    tag:2] autorelease];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             homeNavigation,
                                             settingNavigation,
                                             nil];
    
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   
}
@end
