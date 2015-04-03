//
//  GuessGiveupViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 3. 13..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "GuessGiveupViewController.h"

@implementation GuessGiveupViewController
@synthesize gameItem;

- (void)viewDidLoad {
    [super viewDidLoad];

    //set profile image
    [self.profile setImage:[[UIImage alloc]initWithData:gameItem.imageData]];
    self.profile.layer.cornerRadius = self.profile.frame.size.height /2;
    self.profile.layer.masksToBounds = YES;
    self.profile.layer.borderWidth = 0;
    
    self.name.text = gameItem.name;
}
- (IBAction)goMyTurn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake(320, 1136);
    self.scrollView.scrollEnabled = TRUE;
}

@end
