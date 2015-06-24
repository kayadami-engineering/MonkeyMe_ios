//
//  LoginViewController.h
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 9..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginPopupViewController.h"
#import "JoinPopupViewController.h"
#import "WYPopoverController.h"
#import "NetworkController.h"

@interface LoginViewController : UIViewController{
   
}

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) WYPopoverController *popoverController;
@property (strong, nonatomic) NetworkController *networkController;

@end


