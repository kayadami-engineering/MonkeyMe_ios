//
//  EditPhotoViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "ProfileImageItemCell.h"

@interface EditPhotoViewController : UIViewController {
    UIImage *currentImage;
}

@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) WYPopoverController *popoverController;
@property (strong, nonatomic) ProfileImageItemCell *item;
@end
