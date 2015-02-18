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
    NSString *imageName;
    NSString *content;
}

@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *content;

@end
