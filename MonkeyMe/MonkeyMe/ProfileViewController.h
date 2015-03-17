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
#import "ProfileImageItemCell.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) UIButton *currentTabBtn;
@property (strong, nonatomic) NSString *currentTabImageText;
@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) IBOutlet UIButton *photoBtn;
@property (strong, nonatomic) IBOutlet UIButton *gameBtn;
@property (strong, nonatomic) IBOutlet UIButton *achieveBtn;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) ProfileImageItemCell *selectedItem;
@property (strong, nonatomic) NSMutableDictionary *userStateInfo;
@property (strong, nonatomic) PhotoViewController *photoView;
@property (strong, nonatomic) GameViewController *gameView;
@property (strong, nonatomic) AchieveViewController *achieveView;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *myID;
@property (weak, nonatomic) IBOutlet UILabel *friendCount;
@property (weak, nonatomic) IBOutlet UILabel *photoCount;
@property (weak, nonatomic) IBOutlet UILabel *stateCount_light;
@property (weak, nonatomic) IBOutlet UILabel *stateCount_banana;
@property (weak, nonatomic) IBOutlet UILabel *stateCount_leaf;
@property (weak, nonatomic) IBOutlet UILabel *myLevel;

- (IBAction)photoBtnTouch:(id)sender;
- (IBAction)gameBtnTouch:(id)sender;
- (IBAction)achieveBtnTouch:(id)sender;


@end
