//
//  ProfileViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "ProfileViewController.h"
#import "DetailGameViewController.h"
#import "EditProfileViewController.h"
#import "NetworkController.h"
#import "CommonSharedObject.h"
#import "GuessViewController.h"


#define OBSERVERNAME @"checkGameProcess"
#define NOTSOLVED   0
#define SOLVED      1
#define PVPMODE     1

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
@synthesize selectedItem;
@synthesize userStateInfo;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setProfile];
    [self setNavigationItem];
    [self registerNotification];
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(checkGameProcess:) name:OBSERVERNAME object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setProfile {
    
    NSString *memberID = (NSString*)userStateInfo[@"memberID"];
    NSString *name = (NSString*)userStateInfo[@"name"];
    NSString *level = (NSString*)userStateInfo[@"level"];
    UIImage *image = (UIImage*)userStateInfo[@"profileImage"];
    NSString *lightCount = (NSString*)userStateInfo[@"lightCount"];
    NSString *bananaCount = (NSString*)userStateInfo[@"bananaCount"];
    NSString *leafCount = (NSString*)userStateInfo[@"leafCount"];
    NSString *friends = (NSString*)userStateInfo[@"friendCount"];
    NSString *friendNumber = (NSString*)userStateInfo[@"friendNumber"];
    
    //show friend profile
    if(friendNumber) {
        
        self.friendNumber = friendNumber;
        self.editBtn.hidden = true;
        self.friendBtn.hidden = false;
        self.playBtn.hidden = false;
    }
    else {
        self.friendNumber = @"0";
    }
    
    [self.profileImage setImage:image];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    self.myName.text = name;
    self.myID.text = memberID;
    self.myLevel.text = level;
    self.friendCount.text = friends;
    self.stateCount_banana.text = bananaCount;
    self.stateCount_leaf.text = leafCount;
    self.stateCount_light.text = lightCount;
    
    self.currentTabBtn = self.photoBtn;
    [self.currentTabBtn setSelected:true];
    
}
- (void)setNavigationItem {
    
    CommonSharedObject *commonSharedObject = [CommonSharedObject sharedInstance];
    NSString *storyboardName = commonSharedObject.storyboardName;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboardName
                                                             bundle: nil];
    
    photoView = (PhotoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PhotoViewController"];
    photoView.delegate = self;
    photoView.friendNumber = self.friendNumber;
    
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
    if ([segue.identifier isEqualToString:@"DetailGameSegue"])
    {
        DetailGameViewController *vc = [segue destinationViewController];
        vc.gameItem = selectedItem;
        vc.userStateInfo = self.userStateInfo;
    }
    else if([segue.identifier isEqualToString:@"EditProfileSegue"]) {
        EditProfileViewController *vc = [segue destinationViewController];
        vc.userStateInfo = self.userStateInfo;
    }
    else if([segue.identifier isEqualToString:@"GuessViewSegue"]) {
        
        GuessViewController *guessView = (GuessViewController*)segue.destinationViewController;
        MainTableViewCell *gameItem = [[MainTableViewCell alloc]init];
        
        gameItem.name = (NSString*)userStateInfo[@"name"];
        gameItem.profileUrl = (NSString*)userStateInfo[@"profileUrl"];
        gameItem.imageUrl = self.selectedItem.imageUrl;
        gameItem.hint = self.selectedItem.hint;
        gameItem.keyword = self.selectedItem.keyword;
        gameItem.gameNo = self.selectedItem.g_no;
        gameItem.b_count = @"-1";
        
        guessView.gameItem = gameItem;
        guessView.currentMode = PVPMODE;
        guessView.isProfileGame = TRUE;
    }
}

- (void)checkGameProcess:(NSNotification *)notification {
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        
        NSNumber *isSolved = (NSNumber*)dict[@"isSolved"];

        if([isSolved intValue]==NOTSOLVED) {
            [self performSegueWithIdentifier:@"GuessViewSegue" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"DetailGameSegue" sender:self];
        }
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

- (void)selectItem:(ProfileImageItemCell *)item{
    
    self.selectedItem = item;

    NSString *friendNumber = (NSString*)userStateInfo[@"friendNumber"];
    
    //other's profile

    if(friendNumber) {
        
        NetworkController *networkController = [NetworkController sharedInstance];
        [networkController checkIsGameSolved:item.g_no ObserverName:OBSERVERNAME];
    }
    
    //my profile
    else {
        [self performSegueWithIdentifier:@"DetailGameSegue" sender:self];
    }
}

- (void)setPhotoCountValue:(NSInteger)count {
    
    self.photoCount.text = [NSString stringWithFormat:@"%d",count];
    
}

- (IBAction)playBtnPressed:(id)sender {
    
}
- (IBAction)friendBtnPressed:(id)sender {
    
}
@end

