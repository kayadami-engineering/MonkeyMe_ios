//
//  NetworkController.h
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 22..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NetworkController : NSObject<NSXMLParserDelegate, NSURLConnectionDataDelegate> {
    
}

- (void)initNetwork;
- (void)loginRequest:(NSString*)email Password:(NSString*)password;
- (void)updateMainRequest;
- (void)getProfileGameListRequest;
- (void)updateProfile:(NSString*)name Id:(NSString*)myID;
- (void)postToServer:(NSString *)postString;
- (void)getMonkeyFriendList;
- (void)uploadGameData:(NSData*)data;
+ (NetworkController *)sharedInstance;

@property (assign, nonatomic) NSInteger myMemberNumber;
@property (strong, nonatomic) NSURL *serverURL;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSXMLParser *myParser;
@property (strong, nonatomic) NSMutableString *currentElementValue;
@property (strong, nonatomic) NSString *currentCommand;
@property (strong, nonatomic) NSString *currentElementName;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;
@property (strong, nonatomic) NSMutableDictionary *tempDictionary;
@property (strong, nonatomic) NSMutableArray *tempArray;
@property (strong, nonatomic) NSMutableArray *tempArray2;
@end
