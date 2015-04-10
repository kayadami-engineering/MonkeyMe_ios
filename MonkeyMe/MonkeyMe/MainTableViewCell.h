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
    NSString *gameNo;
    NSString *keyword;
    NSString *hint;
    NSString *imageUrl;
    NSString *profileUrl;
    NSString *name;
    NSString *memberID;
    NSString *round;
    NSString *level;
    NSString *b_count;
    NSString *isSolved;
    NSString *friendCount;
    NSData *imageData;
}

@property (copy, nonatomic) NSString *memberNo;
@property (copy, nonatomic) NSString *gameNo;
@property (copy, nonatomic) NSString *profileUrl;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *round;
@property (copy, nonatomic) NSString *level;
@property (copy, nonatomic) NSString *memberID;
@property (copy, nonatomic) NSData *imageData;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *hint;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *b_count;
@property (copy, nonatomic) NSString *isSolved;
@property (copy, nonatomic) NSString *friendCount;


@end
