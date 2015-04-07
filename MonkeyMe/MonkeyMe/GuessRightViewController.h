//
//  GuessRightViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
@interface GuessRightViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *expBar;
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *replyBg;
@property (weak, nonatomic) IBOutlet UITextField *replyText;
@property (assign, nonatomic) int percent;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) MainTableViewCell *gameItem;
- (IBAction)goMyTurn:(id)sender;

@end
