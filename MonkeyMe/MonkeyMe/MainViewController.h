//
//  MainViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 7..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface MainViewController : UIViewController <SlideNavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end
