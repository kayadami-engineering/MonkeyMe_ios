//
//  GiveUpPopupVIewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 3. 12..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "GiveUpPopupVIewController.h"

@implementation GiveUpPopupVIewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)giveupPressed:(id)sender {

    [self.delegate giveupProcess];
}
@end
