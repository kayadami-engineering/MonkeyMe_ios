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
- (void)loginRequest:(NSString*)email Password:(NSString*)password;
- (void)updateMainRequest;
- (void)postToServer:(NSString *)postString;
+ (NetworkController *)sharedInstance;

@property (assign, nonatomic) NSInteger myMemberIndex;
@property (strong, nonatomic) NSURL *serverURL;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSXMLParser *myParser;
@property (strong, nonatomic) NSMutableString *currentElementValue;
@property (strong, nonatomic) NSString *currentCommand;
@property (strong, nonatomic) NSString *currentElementName;
@property (strong, nonatomic) NSMutableData *responseData;
@end
