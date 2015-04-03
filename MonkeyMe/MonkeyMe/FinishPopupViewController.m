//
//  FinishPopupViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "FinishPopupViewController.h"

@implementation FinishPopupViewController
@synthesize delegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)okBtnPressed:(id)sender {
    [delegate closePopup:self];
}

- (IBAction)sendToFriend:(id)sender {
    [delegate sendToFriend:self];
}

- (IBAction)addToRandom:(id)sender {
    [delegate addToRandom:self];
}


@end
