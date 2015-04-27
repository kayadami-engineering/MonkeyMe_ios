//
//  ReplyItemCell.h
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 8..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyItemCell : NSObject {
    NSString *memberNo;
    NSString *memberID;
    NSString *r_no;
    NSString *name;
    NSString *contents;
    NSString *date;
    NSNumber *likeCount;
    NSNumber *friendCount;
    NSString *profileUrl;
    NSString *level;
}
@property (copy, nonatomic) NSString *memberNo;
@property (nonatomic, copy)NSString *r_no;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *contents;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSNumber *likeCount;
@property (nonatomic, copy)NSNumber *friendCount;
@property (nonatomic, copy)NSString *memberID;
@property (nonatomic, copy)NSString *level;
@property (nonatomic, copy)NSString *profileUrl;
@end
