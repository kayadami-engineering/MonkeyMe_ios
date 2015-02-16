//
//  ProfileViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "PhotoViewController.h"
#import "GameViewController.h"
#import "AchieveViewController.h"

@interface ProfileViewController : UIViewController<SlideNavigationControllerDelegate> 
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *slidLabel;
@property (weak, nonatomic) UIButton *currentTabBtn;
@property (weak, nonatomic) NSString *currentTabImageText;
@property (weak, nonatomic) UIView *currentView;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameBtn;
@property (weak, nonatomic) IBOutlet UIButton *achieveBtn;
@property (weak, nonatomic) PhotoViewController *photoView;
@property (weak, nonatomic) GameViewController *gameView;
@property (weak, nonatomic) AchieveViewController *achieveView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)photoBtnTouch:(id)sender;
- (IBAction)gameBtnTouch:(id)sender;
- (IBAction)achieveBtnTouch:(id)sender;


@end
