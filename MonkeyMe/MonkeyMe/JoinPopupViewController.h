//
//  JoinPopupViewController.h
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@protocol JoinViewControllerDelegate;

@interface JoinPopupViewController : UIViewController

- (IBAction)joinBtnPressed:(id)sender;
- (IBAction)closeBtnPressed:(id)sender;
@property (weak, nonatomic) id<JoinViewControllerDelegate> delegate;

@end

@protocol JoinViewControllerDelegate <NSObject>

@optional

- (void)closePopupJoin:(JoinPopupViewController *)controller;
- (void)joinRequest:(JoinPopupViewController *)controller;

@end