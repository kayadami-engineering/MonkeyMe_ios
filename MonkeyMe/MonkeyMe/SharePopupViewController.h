//
//  SharePopupViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditPhotoViewController.h"
@protocol SharePopupDelegate;

@interface SharePopupViewController : UIViewController

@property (weak, nonatomic) id<SharePopupDelegate> delegate;
@end

@protocol SharePopupDelegate <NSObject>

@optional


@end
