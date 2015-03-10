//
//  EditPhotoViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "SharePopupViewController.h"
#import "WYStoryboardPopoverSegue.h"

@interface EditPhotoViewController() <SharePopupDelegate,WYPopoverControllerDelegate>

@end
@implementation EditPhotoViewController
@synthesize popoverController;
@synthesize currentImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self.profileImage setImage:currentImage];
    self.answerView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.answerView.layer.borderWidth = 1.0f;
}

- (void)setNavigationItem {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
//    UIButton *buttonRight  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    [buttonRight setImage:[UIImage imageNamed:@"phoedic.png"] forState:UIControlStateNormal];
//    [buttonRight addTarget:self action:@selector(sharePopover) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
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
