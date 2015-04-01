//
//  LoginViewController.m
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 9..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginPopupViewController.h"
#import "JoinPopupViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "SVProgressHUD.h"
#import "NetworkController.h"

#define OBSERVERNAME @"loginProcess"

@interface LoginViewController () <LoginViewControllerDelegate, JoinViewControllerDelegate, WYPopoverControllerDelegate> {
   
}
@end
@implementation LoginViewController
@synthesize loginBtn;
@synthesize popoverController;
@synthesize networkController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotification];
    
    networkController = [NetworkController sharedInstance];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginPopupSegue"])
    {
        LoginPopupViewController *loginPopupViewController = segue.destinationViewController;
        loginPopupViewController.delegate = self;

        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                                    permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                    animated:YES
                                                                     options:WYPopoverAnimationOptionFadeWithScale
                                                                 mode:0];
        popoverController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"JoinPopupSegue"])
    {
        JoinPopupViewController *joinPopupViewController = segue.destinationViewController;
        joinPopupViewController.delegate = self;
        
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                                  permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                  animated:YES
                                                                   options:WYPopoverAnimationOptionFadeWithScale
                                                                 mode:1];
        popoverController.delegate = self;
        
    }
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(loginProcess:) name:OBSERVERNAME object:nil];
}

- (void)loginProcess:(NSNotification *)notification { //network notify the result of login request
    
    //do something..
    [SVProgressHUD dismiss];
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if login failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        NSString *index = (NSString*)dict[@"memberIndex"];
        NSLog(@"index=%@",index);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self performSegueWithIdentifier:@"MainViewSegue" sender:self];
    }
}

- (void)joinOk {
    
    //do something..
    [SVProgressHUD dismiss];
}

- (void)closePopup {
    [popoverController dismissPopoverAnimated:YES];
    popoverController.delegate = nil;
    popoverController = nil;
}

#pragma mark - Login popup View Delegate

- (void)closePopupLogin:(LoginPopupViewController *)controller {
    
    controller.delegate = nil;
    
    [self closePopup];
}

- (void)loginRequest:(LoginPopupViewController *)controller Email:(NSString*)email Password:(NSString*)password; {
    
    [self closePopupLogin:controller];
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    [networkController loginRequest:email Password:(NSString*)password ObserverName:OBSERVERNAME]; //request login
    
    //[self performSelector:@selector(loginOk)withObject:nil afterDelay:1.0];
}

#pragma mark - Join popup View Delegate

- (void)closePopupJoin:(JoinPopupViewController *)controller {
    
    controller.delegate = nil;
    
    [self closePopup];
}

- (void)joinRequest:(JoinPopupViewController *)controller {
    [self closePopupJoin:controller];
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    [self performSelector:@selector(joinOk)withObject:nil afterDelay:1.0];
    
}

@end
