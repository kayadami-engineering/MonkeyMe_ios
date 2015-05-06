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
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DetailGameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UIImage *currentImage;
}

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *gameImage;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *replyCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)showAllClick:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *userStateInfo;
@property (strong, nonatomic) WYPopoverController *popoverController;
@property (strong, nonatomic) ProfileImageItemCell *gameItem;
@property (strong, nonatomic) NSMutableArray *replyList;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@end
