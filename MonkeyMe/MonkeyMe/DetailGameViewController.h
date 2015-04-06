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

@interface DetailGameViewController : UIViewController {
    UIImage *currentImage;
}
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *gameImage;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *replyCount;
@property (strong, nonatomic) NSMutableDictionary *userStateInfo;

@property (strong, nonatomic) WYPopoverController *popoverController;
@property (strong, nonatomic) ProfileImageItemCell *item;
@end
