//
//  LoginPopupViewController.h
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@protocol LoginViewControllerDelegate;

@interface LoginPopupViewController : UIViewController {
}
- (IBAction)loginBtnTouch:(id)sender;
- (IBAction)closeBtnTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;
@end

@protocol LoginViewControllerDelegate <NSObject>

@optional

- (void)closePopupLogin:(LoginPopupViewController *)controller;
- (void)loginRequest:(LoginPopupViewController *)controller Email:(NSString*)email Password:(NSString*)password;

@end
