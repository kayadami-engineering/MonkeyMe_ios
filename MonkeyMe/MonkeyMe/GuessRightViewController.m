//
//  GuessRightViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "GuessRightViewController.h"

@implementation GuessRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(dismiss)withObject:nil afterDelay:3.0];
    
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
