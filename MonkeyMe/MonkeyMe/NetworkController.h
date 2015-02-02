//
//  NetworkController.h
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 22..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject<NSXMLParserDelegate, NSURLConnectionDataDelegate> {
    
}

- (void)initNetwork;
- (void)postToServer:(NSString *)postString;

@property (strong, nonatomic) NSURL *serverURL;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSXMLParser *myParser;
@property (strong, nonatomic) NSMutableString *currentElementValue;
@property (strong, nonatomic) NSMutableData *responseData;
@end
