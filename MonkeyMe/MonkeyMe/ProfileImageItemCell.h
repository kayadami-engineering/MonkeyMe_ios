//
//  ProfileImageItemCell.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 18..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameItemObject.h"
#import <UIKit/UIKit.h>

@interface ProfileImageItemCell : GameItemObject
{
    NSString *date;
    NSString *rate;
    NSString *playCount;
    NSString *replyCount;
    CGImageRef videoRef;
}

@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *rate;
@property (copy, nonatomic) NSString *playCount;
@property (copy, nonatomic) NSString *replyCount;
@property (assign, nonatomic) CGImageRef videoRef;

@end
