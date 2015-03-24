//
//  MainTableViewCell.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 10..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MainTableViewCell : NSObject
{
    NSString *memberNo;
    NSString *profileUrl;
    NSString *name;
    NSString *memberID;
    NSString *roundName;
    NSString *level;
    NSData *imageData;
}

@property (copy, nonatomic) NSString *memberNo;
@property (copy, nonatomic) NSString *profileUrl;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *roundName;
@property (copy, nonatomic) NSString *level;
@property (copy, nonatomic) NSString *memberID;
@property (copy, nonatomic) NSData *imageData;

@end
