//
//  ProfileImageItemCell.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 18..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ProfileImageItemCell : NSObject
{
    NSString *g_no;
    NSString *imageUrl;
    NSString *keyword;
    NSString *hint;
    NSString *date;
    NSData *imageData;
    NSString *rate;
    NSString *playCount;
    NSString *replyCount;
    CGImageRef videoRef;
}

@property (copy, nonatomic) NSString *g_no;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *hint;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSData *imageData;
@property (copy, nonatomic) NSString *rate;
@property (copy, nonatomic) NSString *playCount;
@property (copy, nonatomic) NSString *replyCount;
@property (assign, nonatomic) CGImageRef videoRef;

@end
