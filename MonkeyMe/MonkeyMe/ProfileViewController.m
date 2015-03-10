//
//  ProfileViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditPhotoViewController.h"

@interface ProfileViewController() <PhotoViewDelegate>
@end

@implementation ProfileViewController
@synthesize profileImage;
@synthesize currentTabImageText;
@synthesize currentTabBtn;
@synthesize photoView;
@synthesize gameView;
@synthesize myView;
@synthesize achieveView;
@synthesize currentView;
@synthesize curImage;

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
    photoView.delegate = self;
    gameView = (GameViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"GameViewController"];
    achieveView = (AchieveViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"AchieveViewController"];
    self.currentView = photoView.view;
    [myView addSubview:self.currentView];
    
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *buttonRight  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    //[buttonRight addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditPhotoSegue"])
    {
        EditPhotoViewController *vc = [segue destinationViewController];
        vc.currentImage = curImage;
    }

}


#pragma tab bar tocuh event
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

#pragma mark - PhotoView Delegate

- (void)selectImage:(UIImage*)selectedImage {
    self.curImage = selectedImage;
    [self performSegueWithIdentifier:@"EditPhotoSegue" sender:self];
}

@end

