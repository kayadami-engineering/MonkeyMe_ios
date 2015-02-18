//
//  GameViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *expBoxFill;
@property (weak, nonatomic) IBOutlet UILabel *expPercent;
@property (assign, nonatomic) int percent;

@end
