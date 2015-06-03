//
//  CommonSharedObject.h
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 28..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonSharedObject : NSObject

+ (CommonSharedObject *)sharedInstance;

@property (nonatomic, strong) NSString *storyboardName;
@property (nonatomic, strong) NSString *tokenString;


@end
