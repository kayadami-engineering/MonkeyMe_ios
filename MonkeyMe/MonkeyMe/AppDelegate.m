//
//  AppDelegate.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 2..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonSharedObject.h"
#import "NetworkController.h"
#import "KeychainItemWrapper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define OBSERVERNAME @"registerDev"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)registerProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        NSLog(@"regist ok");
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        CommonSharedObject *commonSharedObject = [CommonSharedObject sharedInstance];
        
        UIStoryboard *storyBoard;
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        //iPhone 5
        if(result.height == 1136){
            [commonSharedObject setStoryboardName:@"Main"];
            storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        //iPhone 6
        else if(result.height == 1334) {
            [commonSharedObject setStoryboardName:@"iPhone6"];
            storyBoard = [UIStoryboard storyboardWithName:@"iPhone6" bundle:nil];
            
        }
        
        //[[UIApplication sharedApplication] unregisterForRemoteNotifications];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                // use registerUserNotificationSettings
                UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            } else {
                // use registerForRemoteNotifications
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            }
        }
        else {
        // use registerForRemoteNotifications
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
        
        NSString *identifier;
        
        if([self isUserLogged]) {
            identifier = @"SlideNavigationController";
            
        }
        else {
            identifier = @"LoginViewController";
            [FBSDKLoginButton class];
        }
        
        UIViewController *initViewController = [storyBoard instantiateViewControllerWithIdentifier:identifier];
        [self.window setRootViewController:initViewController];

    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    

#if !TARGET_IPHONE_SIMULATOR
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSUInteger rntypes;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        rntypes = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    }
    else {
        rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
    
    
    NSString *pushBadge = @"disabled";
    NSString *pushAlert = @"disabled";
    NSString *pushSound = @"disabled";
    
    if (rntypes == UIRemoteNotificationTypeBadge) {
        pushBadge = @"enabled";
    }
    
    else if (rntypes == UIRemoteNotificationTypeAlert) {
        pushAlert = @"enabled";
    }
    
    else if (rntypes == UIRemoteNotificationTypeSound) {
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)) {
        pushAlert = @"enabled";
        pushBadge = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)) {
        pushBadge = @"enabled";
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
        pushBadge = @"enabled";
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = [[NSUUID UUID] UUIDString];
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    
    NSString *devToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Build URL String for Registration

    NSString *urlString = @"";
    urlString = [urlString stringByAppendingFormat:@"&appname=%@", appName];
    urlString = [urlString stringByAppendingFormat:@"&appversion=%@", appVersion];
    urlString = [urlString stringByAppendingFormat:@"&deviceuid=%@", deviceUuid];
    urlString = [urlString stringByAppendingFormat:@"&devicetoken=%@", devToken];
    urlString = [urlString stringByAppendingFormat:@"&devicename=%@", deviceName];
    urlString = [urlString stringByAppendingFormat:@"&devicemodel=%@", deviceModel];
    urlString = [urlString stringByAppendingFormat:@"&deviceversion=%@", deviceSystemVersion];
    urlString = [urlString stringByAppendingFormat:@"&pushbadge=%@", pushBadge];
    urlString = [urlString stringByAppendingFormat:@"&pushalert=%@", pushAlert];
    urlString = [urlString stringByAppendingFormat:@"&pushsound=%@", pushSound];
    
    NSLog(@"token = %@",deviceToken);
    //Regist after join
    CommonSharedObject *commonSharedObject = [CommonSharedObject sharedInstance];
    commonSharedObject.tokenString = urlString;
    
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Error in registration. Error: %@", error);
    
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Remote Notification: %@", [userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Did receive a Remote Notification", nil)
                                                            message:[apsInfo objectForKey:@"alert"]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        NSString *alert = [apsInfo objectForKey:@"alert"];
        NSLog(@"Received Push Alert: %@", alert);
        
        NSString *badge = [apsInfo objectForKey:@"badge"];
        NSLog(@"Received Push Badge: %@", badge);
        
        NSString *sound = [apsInfo objectForKey:@"sound"];
        NSLog(@"Received Push Sound: %@", sound);
        NSLog(@"userinfo: %@", userInfo);
    }
    
    
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
#endif
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


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)isUserLogged {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"monkeymeLogin" accessGroup:nil];
    
    NSString *userIndex = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    NetworkController *networkController = [NetworkController sharedInstance];
    networkController.myMemberNumber = userIndex;
    
    BOOL isLogged = ([userIndex length] > 0);
    
    return isLogged;
    
}

@end
