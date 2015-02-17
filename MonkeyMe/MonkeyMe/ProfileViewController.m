//
//  ProfileViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "ProfileViewController.h"
#import "RightViewController.h"



@implementation ProfileViewController
@synthesize profileImage;
@synthesize currentTabImageText;
@synthesize currentTabBtn;
@synthesize photoView;
@synthesize gameView;
@synthesize myView;
@synthesize achieveView;
@synthesize currentView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItem];
    
    [self.profileImage setImage:[UIImage imageNamed:@"ky"]];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    self.currentTabBtn = self.photoBtn;
    [self.currentTabBtn setSelected:true];

    
}
- (void)setNavigationItem {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    photoView = (PhotoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PhotoViewController"];
    gameView = (GameViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"GameViewController"];
    achieveView = (AchieveViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"AchieveViewController"];
    self.currentView = photoView.view;
    [myView addSubview:self.currentView];
    
    
    RightViewController *rightMenu = (RightViewController*)[mainStoryboard
                                                            instantiateViewControllerWithIdentifier: @"RightViewController"];
    
    [SlideNavigationController sharedInstance].rightMenu = rightMenu;
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"friendslist"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

- (IBAction)photoBtnTouch:(id)sender {
    
    [currentView removeFromSuperview];
    [self.currentTabBtn setSelected:false];
    self.currentTabBtn = self.photoBtn;
    [self.currentTabBtn setSelected:true];

    currentView = photoView.view;
    [myView addSubview:currentView];
}

- (IBAction)gameBtnTouch:(id)sender {
    [currentView removeFromSuperview];
    [self.currentTabBtn setSelected:false];
    self.currentTabBtn = self.gameBtn;
    [self.currentTabBtn setSelected:true];

    currentView = gameView.view;
    [myView addSubview:currentView];
    
}

- (IBAction)achieveBtnTouch:(id)sender {
    [currentView removeFromSuperview];
    [self.currentTabBtn setSelected:false];
    self.currentTabBtn = self.achieveBtn;
    [self.currentTabBtn setSelected:true];
    
    currentView = achieveView.view;
    [myView addSubview:currentView];
}
@end

