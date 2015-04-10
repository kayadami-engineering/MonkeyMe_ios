//
//  GuessGiveupViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 3. 13..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
@interface GuessGiveupViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *replyBg;
@property (weak, nonatomic) IBOutlet UITextField *replyText;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) MainTableViewCell *gameItem;
- (IBAction)goMyTurn:(id)sender;


@end
