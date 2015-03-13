//
//  GuessViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 23..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "WYPopoverController.h"

@interface GuessViewController : UIViewController <SlideNavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *HintView;
@property (weak, nonatomic) IBOutlet UIView *WordView;
@property (weak, nonatomic) IBOutlet UITextField *answerText;
@property (weak, nonatomic) IBOutlet UIView *AgainView;
@property (weak, nonatomic) IBOutlet UIView *WordViewFrame;
@property (assign, nonatomic) int hintCount;
@property (assign, nonatomic)CGSize keyboardHeight;
@property (strong, nonatomic) WYPopoverController *popoverController;
- (IBAction)okbtnPressed:(id)sender;
- (IBAction)hintbtnPressed:(id)sender;

@end
