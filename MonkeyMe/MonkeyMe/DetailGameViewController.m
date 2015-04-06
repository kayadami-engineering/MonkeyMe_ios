//
//  EditPhotoViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "DetailGameViewController.h"
#import "SharePopupViewController.h"
#import "WYStoryboardPopoverSegue.h"

@interface DetailGameViewController() <SharePopupDelegate,WYPopoverControllerDelegate>

@end
@implementation DetailGameViewController
@synthesize popoverController;
@synthesize item;
@synthesize userStateInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGameInfo];
    [self setNavigationItem];
    
}

- (void)setGameInfo {
    
    NSString *name = (NSString*)userStateInfo[@"name"];
    UIImage *image = (UIImage*)userStateInfo[@"profileImage"];
    
    [self.gameImage setImage:[[UIImage alloc]initWithData:item.imageData]];
    
    //set profile image
    [self.profileImage setImage:image];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    self.name.text = name;
    self.replyCount.text = item.replyCount;
    self.rate.text = item.rate;
    self.playCount.text = item.playCount;
    
    self.navigationItem.title = item.keyword;
}

- (void)setNavigationItem {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SharePopupSegue"])
    {
        SharePopupViewController *sharePopupViewController = segue.destinationViewController;
        sharePopupViewController.delegate = self;
        
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionUp
                                                             animated:YES
                                                              options:WYPopoverAnimationOptionFadeWithScale
                                                                 mode:2];
        popoverController.delegate = self;
    }
}

@end
