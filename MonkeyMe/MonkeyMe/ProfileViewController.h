//
//  ProfileViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewController.h"
#import "GameViewController.h"
#import "AchieveViewController.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) UIButton *currentTabBtn;
@property (strong, nonatomic) NSString *currentTabImageText;
@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) IBOutlet UIButton *photoBtn;
@property (strong, nonatomic) IBOutlet UIButton *gameBtn;
@property (strong, nonatomic) IBOutlet UIButton *achieveBtn;
@property (strong, nonatomic) PhotoViewController *photoView;
@property (strong, nonatomic) GameViewController *gameView;
@property (strong, nonatomic) AchieveViewController *achieveView;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) UIImage *curImage;


- (IBAction)photoBtnTouch:(id)sender;
- (IBAction)gameBtnTouch:(id)sender;
- (IBAction)achieveBtnTouch:(id)sender;


@end
