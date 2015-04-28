//
//  CommonSharedObject.m
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 28..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "CommonSharedObject.h"

@implementation CommonSharedObject
@synthesize storyboardName;

static CommonSharedObject *singletonInstance;

#pragma mark - Initialization -

+ (CommonSharedObject *)sharedInstance
{
    if (!singletonInstance) {
        NSLog(@"NetworkController has not been initialized. Either place one in your storyboard or initialize one in code");
        singletonInstance = [[CommonSharedObject alloc]init];
    }
    
    return singletonInstance;
}

-(void)setStoryboardName:(NSString*)name {
    
    storyboardName = name;
}

@end
