//
//  GuessViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 23..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SlideNavigationController.h"
#import "WYPopoverController.h"
#import "MainTableViewCell.h"
#import "NetworkController.h"

@interface GuessViewController : UIViewController <SlideNavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *HintView;
@property (weak, nonatomic) IBOutlet UIView *WordView;
@property (weak, nonatomic) IBOutlet UITextField *answerText;
@property (weak, nonatomic) IBOutlet UIView *AgainView;
@property (weak, nonatomic) IBOutlet UIView *WordViewFrame;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *hintText;
@property (weak, nonatomic) IBOutlet UIButton *optionBtn;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *textWordCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *underBarCollection;

@property (assign, nonatomic) BOOL isProfileGame;
@property (assign, nonatomic) int hintCount;
@property (assign, nonatomic) CGSize keyboardHeight;
@property (strong, nonatomic) WYPopoverController *popoverController;
@property (strong, nonatomic) MainTableViewCell *gameItem;
@property (strong, nonatomic) NSNumber *resultType;
@property (assign, nonatomic) int currentMode;
@property (strong, nonatomic) NSString *rndNumber;
@property (strong, nonatomic) NetworkController *networkController;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
- (IBAction)okbtnPressed:(id)sender;
- (IBAction)hintbtnPressed:(id)sender;


@end
