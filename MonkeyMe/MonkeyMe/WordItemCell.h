//
//  WordItemCell.h
//  MonkeyMe
//
//  Created by Imac on 2015. 3. 30..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordItemCell : NSObject {
    NSString *difficulty;
    NSString *keyword;
    NSString *b_count;
}

@property (copy, nonatomic) NSString *difficulty;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *b_count;

@end
