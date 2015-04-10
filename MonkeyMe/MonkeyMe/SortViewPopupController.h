//
//  SortViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 10..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortPopupDelegate;
@interface SortViewPopupController : UIViewController

@property (weak, nonatomic) id<SortPopupDelegate> delegate;

@end

@protocol SortPopupDelegate <NSObject>

@optional


@end