//
//  ReplyItemCell.h
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 8..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameItemObject.h"

@interface ReplyItemCell : GameItemObject {
    NSString *r_no;
    NSString *contents;
    NSString *date;
    NSNumber *likeCount;
    NSNumber *friendCount;
}
@property (nonatomic, copy)NSString *r_no;
@property (nonatomic, copy)NSString *contents;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSNumber *likeCount;
@property (nonatomic, copy)NSNumber *friendCount;
@end
