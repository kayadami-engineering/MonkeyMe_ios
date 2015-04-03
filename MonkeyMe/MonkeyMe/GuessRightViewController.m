//
//  GuessRightViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "GuessRightViewController.h"

@implementation GuessRightViewController
@synthesize percent;
@synthesize gameItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.expBar setTransform:CGAffineTransformMakeScale(1.0, 12.0)];
    percent = 33;
    CGFloat curPercent = (CGFloat)self.percent/100;
    [self.expBar setProgress:curPercent];
    
    //set profile image
    [self.profile setImage:[[UIImage alloc]initWithData:gameItem.imageData]];
    self.profile.layer.cornerRadius = self.profile.frame.size.height /2;
    self.profile.layer.masksToBounds = YES;
    self.profile.layer.borderWidth = 0;
    
    self.name.text = gameItem.name;
    
}
- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake(320, 1136);
    self.scrollView.scrollEnabled = TRUE;
}
- (IBAction)goMyTurn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
