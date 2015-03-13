//
//  GiveUpPopupVIewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 3. 12..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuessViewController.h"
@protocol GiveUpPopupDelegate;

@interface GiveUpPopupVIewController : UIViewController

@property (weak, nonatomic) id<GiveUpPopupDelegate> delegate;
- (IBAction)giveupPressed:(id)sender;
@end

@protocol GiveUpPopupDelegate <NSObject>

@optional

- (void)giveupProcess;

@end