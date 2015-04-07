//
//  FinishPopupViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HintVIewController.h"

@protocol UploadGameDelegate;

@interface FinishPopupViewController : UIViewController
- (IBAction)okBtnPressed:(id)sender;
- (IBAction)sendToFriend:(id)sender;
- (IBAction)addToRandom:(id)sender;
@property (weak, nonatomic) id<UploadGameDelegate> delegate;
@property (strong, nonatomic) NSString *g_no;

@end

@protocol UploadGameDelegate <NSObject>

@optional

- (void)closePopup:(FinishPopupViewController *)controller;
- (void)sendToFriend:(FinishPopupViewController *)controller;
- (void)addToRandom:(FinishPopupViewController *)controller;

@end
