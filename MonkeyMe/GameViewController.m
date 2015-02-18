//
//  GameViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "GameViewController.h"
#define ORIGIN_X 33
#define ORIGIN_Y 32
#define BOXHEIGHT 30

@implementation GameViewController 
@synthesize expBoxFill;
@synthesize expPercent;
@synthesize percent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.expBoxFill setTransform:CGAffineTransformMakeScale(1.0, 12.0)];
    percent = 33;
    expPercent.text = [NSString stringWithFormat:@"%d\%%",percent];
    CGFloat curPercent = (CGFloat)self.percent/100;
    [self.expBoxFill setProgress:curPercent];
    
}
@end
