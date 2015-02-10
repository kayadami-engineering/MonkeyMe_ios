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
    NSString *imageName;
    NSString *name;
    NSString *roundName;
    NSString *level;
}

@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *roundName;
@property (copy, nonatomic) NSString *level;



@end
