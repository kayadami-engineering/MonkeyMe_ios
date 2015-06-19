//
//  GameItemObject.h
//  MonkeyMe
//
//  Created by Imac on 2015. 6. 1..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameItemObject : NSObject {
    
    NSString *memberNo;
    NSString *name;
    NSString *memberID;
    NSString *gameNo;
    NSString *keyword;
    NSString *hint;
    NSString *imageUrl;
    NSString *profileUrl;
    NSData *imageData;
    NSString *level;
}

@property (copy, nonatomic) NSString *memberNo;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *memberID;
@property (copy, nonatomic) NSString *gameNo;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *hint;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *profileUrl;
@property (copy, nonatomic) NSString *level;
@property (copy, nonatomic) NSData *imageData;
@end
