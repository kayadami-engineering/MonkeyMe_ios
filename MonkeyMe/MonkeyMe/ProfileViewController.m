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
@synthesize slidLabel;
@synthesize profileImage;
@synthesize currentTabImageText;
@synthesize currentTabBtn;
@synthesize photoView;
@synthesize gameView;
@synthesize scrollView;
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
    self.currentTabImageText = @"photog";
    [self.currentTabBtn setSelected:true];

    
}
- (void)setNavigationItem {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    photoView = (PhotoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PhotoViewController"];
    gameView = (GameViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"GameViewController"];
    achieveView = (AchieveViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"AchieveViewController"];
    self.currentView = gameView.view;
    [scrollView addSubview:self.currentView];
    
    
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

- (void) photoViewButtonAction
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    slidLabel.frame = CGRectMake(0, 229, 106, 10);
    //[nibScrollView setContentOffset:CGPointMake(320*0, 0)];
    
    [UIView commitAnimations];
}

- (void) gameViewButtonAction
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    slidLabel.frame = CGRectMake(107, 229, 106, 10);
    //[nibScrollView setContentOffset:CGPointMake(320*1, 0)];
    
    [UIView commitAnimations];
}
- (void) achieveViewButtonAction
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    slidLabel.frame = CGRectMake(214, 229, 106, 10);
    //[nibScrollView setContentOffset:CGPointMake(320*1, 0)];
    
    [UIView commitAnimations];
    
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
    
    [self.currentTabBtn setSelected:false];
    self.currentTabBtn = self.photoBtn;
    self.currentTabImageText = @"photog";
    [self.currentTabBtn setSelected:true];
    [self photoViewButtonAction];
}

- (IBAction)gameBtnTouch:(id)sender {
    
    [self.currentTabBtn setSelected:false];
    self.currentTabBtn = self.gameBtn;
    self.currentTabImageText = @"gameg";
    [self.currentTabBtn setSelected:true];
    [self gameViewButtonAction];
}

- (IBAction)achieveBtnTouch:(id)sender {
    
    [self.currentTabBtn setSelected:false];
    self.currentTabBtn = self.achieveBtn;
    self.currentTabImageText = @"achieveg";
    [self.currentTabBtn setSelected:true];
    [self achieveViewButtonAction];
}
@end

