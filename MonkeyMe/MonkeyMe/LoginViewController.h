//
//  LoginViewController.h
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 9..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginPopupViewController.h"
#import "WYPopoverController.h"

@interface LoginViewController : UIViewController{
   
}

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) WYPopoverController *popoverController;
@end


