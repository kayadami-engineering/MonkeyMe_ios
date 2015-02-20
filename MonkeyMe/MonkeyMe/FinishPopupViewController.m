//
//  FinishPopupViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "FinishPopupViewController.h"

@implementation FinishPopupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)okBtnPressed:(id)sender {
    
    [UIView animateWithDuration:1 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL b){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        self.view.alpha = 1;
    }];
}
@end
