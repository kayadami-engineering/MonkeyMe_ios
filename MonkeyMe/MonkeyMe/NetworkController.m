//
//  NetworkController.m
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 22..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "NetworkController.h"

#define JOIN    0
#define LOGIN   1

@implementation NetworkController
@synthesize serverURL;
@synthesize myParser;
@synthesize request;
@synthesize responseData;
@synthesize currentCommand;
@synthesize currentElementName;
@synthesize notificationCenter;
@synthesize tempDictionary;
@synthesize tempArray;
@synthesize tempArray2;
@synthesize myMemberNumber;
@synthesize currentObserverName;

static NetworkController *singletonInstance;

#pragma mark - Initialization -

+ (NetworkController *)sharedInstance
{
    if (!singletonInstance) {
        NSLog(@"NetworkController has not been initialized. Either place one in your storyboard or initialize one in code");
        singletonInstance = [[NetworkController alloc]init];
        [singletonInstance initNetwork];
    }
    
    return singletonInstance;
}

-(void)initNetwork {
    
    serverURL = [NSURL URLWithString:@"http://175.211.100.229/monkeyme/monkeyme_server/RequestHandleServer.php"];
    request = [[NSMutableURLRequest alloc]init];
    [request setURL:serverURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    
    notificationCenter = [NSNotificationCenter defaultCenter];
    tempDictionary = [[NSMutableDictionary alloc] init];
    tempArray = [[NSMutableArray alloc]init];
    tempArray2 = [[NSMutableArray alloc]init];
    
}

-(void)postToServerSynch:(NSString *)postString {
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSError * error = nil;
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    
    if(error == nil) {
        
        responseData = [[NSMutableData alloc] init];
        [responseData appendData:data];
        
        myParser = [[NSXMLParser alloc]initWithData:responseData];
        myParser.delegate = self;
        
        [myParser parse];
    }
    
}

-(void)postToServer:(NSString *)postString {
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)postToServerWithData:(NSData *)fileData Filename:(NSString*)filename Data:(NSDictionary*)params {
    
    request = [[NSMutableURLRequest alloc]init];
    [request setURL:serverURL];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";  // important!!!
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in params) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",param]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]]dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:fileData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    //NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]
                                                completionHandler:^(NSURLResponse *response,
                                                                    NSData *returnData,
                                                                    NSError *error)
    {
        if ([returnData length] >0 && error == nil)
        {
            
            // DO YOUR WORK HERE
            responseData = [[NSMutableData alloc] init];
            [responseData appendData:returnData];
            
            myParser = [[NSXMLParser alloc]initWithData:responseData];
            myParser.delegate = self;
            
            [myParser parse];
            
        }
        else if ([returnData length] == 0 && error == nil)
        {
            NSLog(@"Nothing was downloaded.");
        }
        else if (error != nil){
            NSLog(@" Asynch Error = %@", error);
        }
    }];
}

#pragma mark - Request Command Methods-

- (void)joinRequest:(NSString*)email Password:(NSString*)password Name:(NSString*)name ObserverName:(NSString*)observerName {
    
    currentCommand = @"join";
    currentObserverName = observerName;
    NSString *string = [NSString stringWithFormat:@"command=%@&email=%@&password=%@&name=%@",currentCommand,email,password,name];
    [self postToServer:string];
}

-(void)loginRequest:(NSString*)email Password:(NSString*)password DevToken:(NSString*)token FacebookFlag:(BOOL)flag ObserverName:(NSString *)observerName {
    
    currentCommand = @"login";
    currentObserverName = observerName;
    NSString *string = [NSString stringWithFormat:@"command=%@&email=%@&devicetoken=%@&osType=1&isFacebookLogin=%d",currentCommand,email,token,flag];
    [self postToServer:string];
}

-(void)updateMainRequest:(NSString *)observerName{
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"updateMain";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@",currentCommand,myMemberNumber];
        [self postToServer:string];
    }
}

-(void)getProfileGameListRequest:(NSString*)friendNumber ObserverName:(NSString *)observerName {
    
    NSString* memberNumber = [friendNumber isEqualToString:@"0"] ? myMemberNumber:friendNumber;

    if(memberNumber) {
        currentObserverName = observerName;
        currentCommand = @"pastList";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@",currentCommand,memberNumber];
        [self postToServer:string];
    }
}

-(void)updateProfile:(NSString*)name Id:(NSString*)myID ObserverName:(NSString *)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"updateProfile";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@&name=%@&id=%@",currentCommand,myMemberNumber,name,myID];
        [self postToServer:string];
    }
}

-(void)getMonkeyFriendList:(NSString *)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"friendlist_monkey";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@",currentCommand,myMemberNumber];
        [self postToServer:string];
    }
}

-(void)getWordList:(NSString *)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"wordList";
        NSString *string = [NSString stringWithFormat:@"command=%@",currentCommand];
        [self postToServer:string];
    }
}
- (void)solveTheMonkey:(NSString*)g_no BananaCount:(NSString*)b_count ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"solveTheMonkey";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@&g_no=%@&b_count=%@",currentCommand,myMemberNumber,g_no,b_count];
        [self postToServer:string];
    }
}
- (void)solveTheRandom:(NSString*)rnd_no ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"solveTheRandom";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@&rnd_no=%@",currentCommand,myMemberNumber,rnd_no];
        [self postToServer:string];
    }
}
-(void)sendGameEval:(NSString*)g_no ReplyText:(NSString*)reply Rate:(NSString*)rate ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"gameEvaluate";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@&g_no=%@&reply=%@&rate=%@",currentCommand,myMemberNumber,g_no,reply,rate];
        [self postToServer:string];
    }
}
-(void)uploadGameData:(NSData*)imageData Keyword:(NSString*)keyword Hint:(NSString*)hint
           GameNumber:(NSString*)g_no TargetNumber:(NSString*)targetNumber BananaCount:(NSString*)b_count Round:(NSString*)round ObserverName:(NSString *)observerName FileName:(NSString*)filename{
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"uploadGameData";
        NSDictionary *params = @{@"command":currentCommand, @"memberNumber":[NSString stringWithFormat:@"%@",myMemberNumber],
                                 @"keyword":keyword,@"hint":hint,@"g_no":g_no,@"targetNumber":targetNumber,
                                 @"b_count":b_count,@"round":round};
        [self postToServerWithData:imageData Filename:filename Data:params];
    }
}
- (void)addToRandomMode:(NSString*)g_no ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"addToRandom";
        NSString *string = [NSString stringWithFormat:@"command=%@&g_no=%@&memberNumber=%@",currentCommand,g_no,myMemberNumber];
        [self postToServer:string];
    }
}
- (void)addToRandomModeNew:(NSData*)imageData Keyword:(NSString*)keyword Hint:(NSString*)hint ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"addToRandomNew";
        NSDictionary *params = @{@"command":currentCommand, @"memberNumber":[NSString stringWithFormat:@"%@",myMemberNumber],
                                 @"keyword":keyword,@"hint":hint};
        [self postToServerWithData:imageData Filename:@"file.jpeg" Data:params];
    }
}

- (void)getReplyList:(NSString*)g_no Count:(int)replyCount Sort:(int)sort ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        
        if(replyCount==0)
            currentCommand = @"replyList";
        else
            currentCommand = @"topReply";
        
        NSString *string = [NSString stringWithFormat:@"command=%@&g_no=%@&memberNumber=%@&sort=%d",currentCommand,g_no,myMemberNumber,sort];
        [self postToServer:string];
    }
}
- (void)sendReply:(NSString*)g_no Contents:(NSString*)contents  ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"sendReply";
        
        NSString *string = [NSString stringWithFormat:@"command=%@&g_no=%@&memberNumber=%@&contents=%@",currentCommand,g_no,myMemberNumber,contents];
        [self postToServer:string];
    }
}
- (void)getRandomItem:(NSString *)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"randomItem";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@",currentCommand,myMemberNumber];
        [self postToServer:string];
    }
}

- (void)deleteGameItem:(NSString*)g_no ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"deleteGame";
        NSString *string = [NSString stringWithFormat:@"command=%@&g_no=%@&memberNumber=%@",currentCommand,g_no,myMemberNumber];
        [self postToServer:string];
    }
}

- (void)checkIsGameSolved:(NSString*)g_no ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"checkGame";
        NSString *string = [NSString stringWithFormat:@"command=%@&g_no=%@&memberNumber=%@",currentCommand,g_no,myMemberNumber];
        [self postToServer:string];
    }
}

- (void)registerDevice:(NSString*)token ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"registerDev";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%@&osType=%@%@",currentCommand,myMemberNumber,@"0",token];
        [self postToServerSynch:string];
    }
}
#pragma mark Parser Delegate
-(void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    currentElementName = [NSString stringWithString:elementName];
    
    if([elementName isEqualToString:@"infohead"]) { //information header
        //Initialize the array.
        currentCommand = [attributeDict objectForKey:@"command"];
        NSString *result = [attributeDict objectForKey:@"result"];
        NSString *message = [attributeDict objectForKey:@"message"];
        
        [tempDictionary setValue:result forKey:@"result"];
        [tempDictionary setValue:message forKey:@"message"];
    }
    
    else if([elementName isEqualToString:@"state"]) { //My state
        
        if([currentCommand isEqualToString:@"login"]) { //if login succeeed
            NSString *memberNo = [attributeDict objectForKey:@"m_no"];
            NSString *memberID = [attributeDict objectForKey:@"id"];
            
            [tempDictionary setValue:memberNo forKey:@"memberNo"];
            [tempDictionary setValue:memberID forKey:@"memberID"];
            
        }
        else if([currentCommand isEqualToString:@"updateMain"]) { //if update main succeed
            NSString *memberNo = [attributeDict objectForKey:@"m_no"];
            NSString *memberID = [attributeDict objectForKey:@"id"];
            NSString *name = [attributeDict objectForKey:@"name"];
            
            NSString *level = [attributeDict objectForKey:@"level"];
            NSString *email = [attributeDict objectForKey:@"email"];
            NSString *profileUrl = [attributeDict objectForKey:@"profile"];
            NSString *lightCount = [attributeDict objectForKey:@"light"];
            NSString *bananaCount = [attributeDict objectForKey:@"banana"];
            NSString *leafCount = [attributeDict objectForKey:@"leaf"];
            NSString *friendCount = [attributeDict objectForKey:@"friends"];
            
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            
            [userInfo setValue:memberNo forKey:@"memberNo"];
            [userInfo setValue:memberID forKey:@"memberID"];
            [userInfo setValue:name forKey:@"name"];
            [userInfo setValue:level forKey:@"level"];
            [userInfo setValue:email forKey:@"email"];
            [userInfo setValue:lightCount forKey:@"lightCount"];
            [userInfo setValue:bananaCount forKey:@"bananaCount"];
            [userInfo setValue:leafCount forKey:@"leafCount"];
            [userInfo setValue:friendCount forKey:@"friendCount"];
            [userInfo setValue:profileUrl forKey:@"profileUrl"];
            
            [tempDictionary setValue:userInfo forKey:@"userInfo"];
            
        }
        else if([currentCommand isEqualToString:@"uploadGameData"]) {
            NSString *gameNo = [attributeDict objectForKey:@"g_no"];
            [tempDictionary setValue:gameNo forKey:@"gameNo"];
        }
        else if([currentCommand isEqualToString:@"checkGame"]) {
            
            NSNumber *isSolved = [attributeDict objectForKey:@"isSolved"];
            
            [tempDictionary setValue:isSolved forKey:@"isSolved"];
        }
    }
    else if([elementName isEqualToString:@"list"]) {
   
        if([[attributeDict objectForKey:@"id"] isEqualToString:@"myturn"]) {
            currentCommand = @"updateMain_myturn";
        }
        else if([[attributeDict objectForKey:@"id"] isEqualToString:@"friendsturn"]) {
            currentCommand = @"updateMain_friendsturn";
        }
    }
    
    else if([elementName isEqualToString:@"friendgame"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSString *memberNo = [attributeDict objectForKey:@"m_no"];
        NSString *gameNo = [attributeDict objectForKey:@"g_no"];
        NSString *memberID = [attributeDict objectForKey:@"id"];
        NSString *name = [attributeDict objectForKey:@"name"];
        NSString *level = [attributeDict objectForKey:@"level"];
        NSString *profileUrl = [attributeDict objectForKey:@"profile"];
        NSString *round = [attributeDict objectForKey:@"round"];
        NSString *keyword = [attributeDict objectForKey:@"keyword"];
        NSString *hint = [attributeDict objectForKey:@"hint"];
        NSString *imageUrl = [attributeDict objectForKey:@"imageUrl"];
        NSString *b_count = [attributeDict objectForKey:@"b_count"];
        NSString *isSolved = [attributeDict objectForKey:@"isSolved"];
        
        [list setValue:memberNo forKey:@"memberNo"];
        [list setValue:gameNo forKey:@"gameNo"];
        [list setValue:memberID forKey:@"memberID"];
        [list setValue:name forKey:@"name"];
        [list setValue:level forKey:@"level"];
        [list setValue:profileUrl forKey:@"profileUrl"];
        [list setValue:round forKey:@"round"];
        [list setValue:keyword forKey:@"keyword"];
        [list setValue:hint forKey:@"hint"];
        [list setValue:imageUrl forKey:@"imageUrl"];
        [list setValue:b_count forKey:@"b_count"];
        [list setValue:isSolved forKey:@"isSolved"];
        
        if([currentCommand isEqualToString:@"updateMain_myturn"])
            [tempArray addObject:list];
        else if([currentCommand isEqualToString:@"updateMain_friendsturn"])
            [tempArray2 addObject:list];
        
    }
    
    else if([elementName isEqualToString:@"item"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSString *game_no = [attributeDict objectForKey:@"g_no"];
        NSString *imageUrl = [attributeDict objectForKey:@"imageUrl"];
        NSString *keyword = [attributeDict objectForKey:@"keyword"];
        NSString *hint = [attributeDict objectForKey:@"hint"];
        NSString *date = [attributeDict objectForKey:@"date"];
        NSString *rate = [attributeDict objectForKey:@"rate"];
        NSString *playCount = [attributeDict objectForKey:@"playCount"];
        NSString *replyCount = [attributeDict objectForKey:@"replyCount"];
        
        [list setValue:game_no forKey:@"gameNo"];
        [list setValue:imageUrl forKey:@"imageUrl"];
        [list setValue:keyword forKey:@"keyword"];
        [list setValue:hint forKey:@"hint"];
        [list setValue:date forKey:@"date"];
        [list setValue:rate forKey:@"rate"];
        [list setValue:playCount forKey:@"playCount"];
        [list setValue:replyCount forKey:@"replyCount"];
        [tempArray addObject:list];
    }
    
    else if([elementName isEqualToString:@"friendinfo"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSString *memberNo = [attributeDict objectForKey:@"m_no"];
        NSString *name = [attributeDict objectForKey:@"name"];
        NSString *profileUrl = [attributeDict objectForKey:@"profile"];
        NSString *memberID = [attributeDict objectForKey:@"id"];
        NSString *level = [attributeDict objectForKey:@"level"];
        NSString *friendCount = [attributeDict objectForKey:@"friends"];
        
        [list setValue:memberNo forKey:@"memberNo"];
        [list setValue:name forKey:@"name"];
        [list setValue:profileUrl forKey:@"profileUrl"];
        [list setValue:memberID forKey:@"memberID"];
        [list setValue:level forKey:@"level"];
        [list setValue:friendCount forKey:@"friendCount"];
        
        [tempArray addObject:list];
    }
    
    else if([elementName isEqualToString:@"wordinfo"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSNumber *level = [attributeDict objectForKey:@"level"];
        NSString *keyword = [attributeDict objectForKey:@"keyword"];
        
        [list setValue:level forKey:@"level"];
        [list setValue:keyword forKey:@"keyword"];
        
        [tempArray addObject:list];
    }
    
    else if([elementName isEqualToString:@"replyinfo"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSString *memberNo = [attributeDict objectForKey:@"m_no"];
        NSString *memberID = [attributeDict objectForKey:@"id"];
        NSString *name = [attributeDict objectForKey:@"name"];
        NSString *replyNo = [attributeDict objectForKey:@"r_no"];
        NSString *contents = [attributeDict objectForKey:@"contents"];
        NSString *date = [attributeDict objectForKey:@"date"];
        NSNumber *likeCount = [attributeDict objectForKey:@"likeCount"];
        NSNumber *friendCount = [attributeDict objectForKey:@"friendCount"];
        NSString *profileUrl = [attributeDict objectForKey:@"profile"];
        NSString *level = [attributeDict objectForKey:@"level"];
        
        [list setValue:replyNo forKey:@"r_no"];
        [list setValue:name forKey:@"name"];
        [list setValue:date forKey:@"date"];
        [list setValue:contents forKey:@"contents"];
        [list setValue:likeCount forKey:@"likeCount"];
        [list setValue:profileUrl forKey:@"profileUrl"];
        [list setValue:memberID forKey:@"memberID"];
        [list setValue:memberNo forKey:@"memberNo"];
        [list setValue:friendCount forKey:@"friendCount"];
        [list setValue:level forKey:@"level"];
        [tempArray addObject:list];
    }
    
    else if([elementName isEqualToString:@"randominfo"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSString *rndNo = [attributeDict objectForKey:@"rnd_no"];
        NSString *name = [attributeDict objectForKey:@"name"];
        NSString *gameNo = [attributeDict objectForKey:@"g_no"];
        NSString *memberNo = [attributeDict objectForKey:@"m_no"];
        NSString *profileUrl = [attributeDict objectForKey:@"profile"];
        NSString *keyword = [attributeDict objectForKey:@"keyword"];
        NSString *hint = [attributeDict objectForKey:@"hint"];
        NSString *imageUrl = [attributeDict objectForKey:@"image"];
        
        [list setValue:memberNo forKey:@"memberNo"];
        [list setValue:gameNo forKey:@"gameNo"];
        [list setValue:name forKey:@"name"];
        [list setValue:profileUrl forKey:@"profileUrl"];
        [list setValue:keyword forKey:@"keyword"];
        [list setValue:hint forKey:@"hint"];
        [list setValue:imageUrl forKey:@"imageUrl"];
        [list setValue:rndNo forKey:@"rnd_no"];
        [list setValue:name forKey:@"name"];
        
        [tempArray addObject:list];
    }
    //NSLog(@"Processing Element: %@", elementName);
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"list"]) {
        
        if([currentCommand isEqualToString:@"updateMain_myturn"]) {
            [tempDictionary setValue:tempArray forKey:@"gamelist_myturn"];
        }
        
        else if([currentCommand isEqualToString:@"updateMain_friendsturn"]) {
            [tempDictionary setValue:tempArray2 forKey:@"gamelist_friendsturn"];
        }
        
        else if([currentCommand isEqualToString:@"pastList"]) {
            [tempDictionary setValue:tempArray forKey:@"items"];
        }
        
        else if([currentCommand isEqualToString:@"friendlist_monkey"]) {
            [tempDictionary setValue:tempArray forKey:@"friendList"];
        }
        else if([currentCommand isEqual:@"wordList"]) {
            [tempDictionary setValue:tempArray forKey:@"wordList"];
        }
        else if([currentCommand isEqual:@"replyList"]) {
            [tempDictionary setValue:tempArray forKey:@"replyList"];
        }
        else if([currentCommand isEqual:@"randomItem"]) {
            [tempDictionary setValue:tempArray forKey:@"gameItem"];
        }
    }
    
    else if([elementName isEqualToString:@"xml"]) {
        
        //notify the observer
        if(currentObserverName.length>0) {
            [notificationCenter postNotificationName:currentObserverName object:self userInfo:tempDictionary];
        }
        //empty all temporary container objects
        [tempDictionary removeAllObjects];
        [tempArray removeAllObjects];
        [tempArray2 removeAllObjects];
        
        currentObserverName = @"";
        currentCommand = @"";
    }
}

#pragma URL Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
    NSLog(@"received data");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    myParser = [[NSXMLParser alloc]initWithData:responseData];
    myParser.delegate = self;
    
    [myParser parse];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Network Error received = %@", error);
    
    //notify the observer
    if(currentObserverName.length>0) {
        
        NSString *result = @"error";
        NSString *message = @"Connection Error";
        
        [tempDictionary setValue:result forKey:@"result"];
        [tempDictionary setValue:message forKey:@"message"];
        [notificationCenter postNotificationName:currentObserverName object:self userInfo:tempDictionary];
    }
}

@end
