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
- (void)loginRequest:(NSString*)email Password:(NSString*)password ObserverName:(NSString*)observerName;
- (void)updateMainRequest:(NSString*)observerName;
- (void)getProfileGameListRequest:(NSString*)name ;
- (void)updateProfile:(NSString*)name Id:(NSString*)myID ObserverName:(NSString*)observerName;
- (void)postToServer:(NSString *)postString ObserverName:(NSString*)observerName;
- (void)getMonkeyFriendList:(NSString*)observerName;
- (void)getWordList:(NSString*)observerName;

- (void)uploadGameData:(NSData*)imageData Keyword:(NSString*)keyword Hint:(NSString*)hint
            GameNumber:(NSString*)g_no TargetNumber:(NSString*)targetNumber BananaCount:(NSString*)b_count Round:(NSString*)round
          ObserverName:(NSString*)observerName ;
+ (NetworkController *)sharedInstance;

@property (assign, nonatomic) NSInteger myMemberNumber;
@property (strong, nonatomic) NSURL *serverURL;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSXMLParser *myParser;
@property (strong, nonatomic) NSString *currentObserverName;
@property (strong, nonatomic) NSString *currentCommand;
@property (strong, nonatomic) NSString *currentElementName;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;
@property (strong, nonatomic) NSMutableDictionary *tempDictionary;
@property (strong, nonatomic) NSMutableArray *tempArray;
@property (strong, nonatomic) NSMutableArray *tempArray2;

@end
