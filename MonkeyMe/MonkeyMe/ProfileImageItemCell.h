//
//  ProfileImageItemCell.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 18..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileImageItemCell : NSObject
{
    NSString *imageUrl;
    NSString *keyword;
    NSString *hint;
    NSString *date;
    NSData *imageData;
}

@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *hint;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSData *imageData;

@end
