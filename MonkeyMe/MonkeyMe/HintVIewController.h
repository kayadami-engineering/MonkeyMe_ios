//
//  HintVIewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordItemCell.h"
#import "FinishPopupViewController.h"
#import "NetworkController.h"

@interface HintVIewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *hintText;
@property (strong, nonatomic) NSMutableDictionary* gameInfo;
@property (strong, nonatomic) NetworkController *networkController;
@property (assign, nonatomic) CGSize keyboardHeight;
@end


