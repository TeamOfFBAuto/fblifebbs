//
//  AppDelegate.m
//  fblifebbs
//
//  Created by szk on 14-10-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "AppDelegate.h"

#import "BBSViewController.h"

#import "MainViewController.h"

#import "FindViewController.h"

#import "MessageViewController.h"

#import "MineViewController.h"

#import "LogInViewController.h"


#import "ComprehensiveViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //设置状态栏(如果整个app是统一的状态栏，其他地方不用再设置)
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    NSLog(@"登陆没有呢 ----  %d",isLogIn);
    if (isLogIn)
    {
        [self showRootViewWith:@"root"];
    }else
    {
        [self showRootViewWith:@"login"];
    }
    
    
    //[self setTabbarViewcontroller];
    
    
    
    
    return YES;
}


-(void)showRootViewWith:(NSString *)type
{
    if ([type isEqualToString:@"login"])///登陆
    {
        LogInViewController * logIn = [LogInViewController sharedManager];
        self.window.rootViewController = logIn;
        
    }else///主视图
    {
        [self setTabbarViewcontroller];
    }
}

#pragma mark-设置tabbarViewC

-(void)setTabbarViewcontroller{

   
    ComprehensiveViewController * mainVC = [[ComprehensiveViewController alloc] init];
    
    BBSViewController * microBBSVC = [[BBSViewController alloc] init];
    
    FindViewController * messageVC = [[FindViewController alloc] init];
    
    MessageViewController * foundVC = [[MessageViewController alloc] init];
    
    MineViewController * mineVC = [[MineViewController alloc] init];
    
    UINavigationController * navc1 = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    UINavigationController * navc2 = [[UINavigationController alloc] initWithRootViewController:microBBSVC];
    
    UINavigationController * navc3 = [[UINavigationController alloc] initWithRootViewController:messageVC];
    
    UINavigationController * navc4 = [[UINavigationController alloc] initWithRootViewController:foundVC];
    
    UINavigationController * navc5 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    
    navc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"home-1.png"] selectedImage:[UIImage imageNamed:@"home-1.png"]];
    
    navc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"版块" image:[UIImage imageNamed:@"bankuai-1.png"] selectedImage:[UIImage imageNamed:@"bankuai-1.png"]];
    
    navc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"find-1.png"] selectedImage:[UIImage imageNamed:@"find-1.png"]];
    
    navc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"xiaoxi-1"] selectedImage:[UIImage imageNamed:@"xiaoxi-1.png"]];
    
    navc5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"me-1.png"] selectedImage:[UIImage imageNamed:@"me-1.png"]];
    
    
    UITabBarController * tabbarVC = [[UITabBarController alloc] init];
    
    tabbarVC.viewControllers = [NSArray arrayWithObjects:navc1,navc2,navc3,navc4,navc5,nil];
    
    tabbarVC.selectedIndex = 0;
    
    tabbarVC.tabBar.tintColor=[UIColor blackColor];
    
    
    tabbarVC.tabBar.backgroundImage = [UIImage imageNamed:@""];
    
    
    
    
    
    //    [MobClick startWithAppkey:@"5368ab4256240b6925029e29"];
    
    //微信
    
    
    self.window.rootViewController = tabbarVC;


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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.fblife.fblifebbs" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"fblifebbs" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"fblifebbs.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
