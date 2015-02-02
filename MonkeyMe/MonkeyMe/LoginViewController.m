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

@interface LoginViewController () <LoginViewControllerDelegate, JoinViewControllerDelegate, WYPopoverControllerDelegate> {
   
}
@end
@implementation LoginViewController
@synthesize loginBtn;
@synthesize popoverController;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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

- (void)loginOk {
    
    //do something..
    [SVProgressHUD dismiss];
    [self performSegueWithIdentifier:@"TabViewSegue" sender:self];
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

- (void)loginRequest:(LoginPopupViewController *)controller {
    
    [self closePopupLogin:controller];
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    [self performSelector:@selector(loginOk)withObject:nil afterDelay:1.0];
    
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
