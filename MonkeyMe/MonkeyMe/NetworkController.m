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
    
    myMemberNumber = 1;
    
}

-(void)postToServer:(NSString *)postString {
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:fileData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    responseData = [[NSMutableData alloc] init];
    [responseData appendData:returnData];
    
    myParser = [[NSXMLParser alloc]initWithData:responseData];
    myParser.delegate = self;
    
    [myParser parse];
    
}

#pragma mark - Request Command Methods-

-(void)joinRequest {
    
}

-(void)loginRequest:(NSString*)email Password:(NSString*)password ObserverName:(NSString *)observerName {
    
    currentCommand = @"login";
    currentObserverName = observerName;
    NSString *string = [NSString stringWithFormat:@"command=%@&email=%@",currentCommand,email];
    [self postToServer:string];
}

-(void)updateMainRequest:(NSString *)observerName{
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"updateMain";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i",currentCommand,myMemberNumber];
        [self postToServer:string];
    }
}

-(void)getProfileGameListRequest:(NSString *)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"pastList";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i",currentCommand,myMemberNumber];
        [self postToServer:string];
    }
}

-(void)updateProfile:(NSString*)name Id:(NSString*)myID ObserverName:(NSString *)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"updateProfile";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i&name=%@&id=%@",currentCommand,myMemberNumber,name,myID];
        [self postToServer:string];
    }
}

-(void)getMonkeyFriendList:(NSString *)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"friendlist_monkey";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i",currentCommand,myMemberNumber];
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
- (void)solveTheMonkey:(NSString*)g_no GameLevel:(NSString*)level ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"solveTheMonkey";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i&g_no=%@&level=%@",currentCommand,myMemberNumber,g_no,level];
        [self postToServer:string];
    }
}
-(void)sendGameEval:(NSString*)g_no ReplyText:(NSString*)reply Rate:(NSNumber*)rate ObserverName:(NSString*)observerName {
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"gameEvaluate";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i&g_no=%@&reply=%@&rate=%@",currentCommand,myMemberNumber,g_no,reply,rate];
        [self postToServer:string];
    }
}
-(void)uploadGameData:(NSData*)imageData Keyword:(NSString*)keyword Hint:(NSString*)hint
           GameNumber:(NSString*)g_no TargetNumber:(NSString*)targetNumber BananaCount:(NSString*)b_count Round:(NSString*)round ObserverName:(NSString *)observerName{
    
    if(myMemberNumber) {
        currentObserverName = observerName;
        currentCommand = @"uploadGameData";
        NSDictionary *params = @{@"command":currentCommand, @"memberNumber":[NSString stringWithFormat:@"%i",myMemberNumber],
                                 @"keyword":keyword,@"hint":hint,@"g_no":g_no,@"targetNumber":targetNumber,
                                 @"b_count":b_count,@"round":round};
        [self postToServerWithData:imageData Filename:@"file.jpeg" Data:params];
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
        NSNumber *isSolved = [attributeDict objectForKey:@"isSolved"];
        
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
        
        [list setValue:game_no forKey:@"gameNo"];
        [list setValue:imageUrl forKey:@"imageUrl"];
        [list setValue:keyword forKey:@"keyword"];
        [list setValue:hint forKey:@"hint"];
        [list setValue:date forKey:@"date"];
        [tempArray addObject:list];
    }
    
    else if([elementName isEqualToString:@"friendinfo"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSString *memberNo = [attributeDict objectForKey:@"m_no"];
        NSString *name = [attributeDict objectForKey:@"name"];
        NSString *profileUrl = [attributeDict objectForKey:@"profile"];
        
        [list setValue:memberNo forKey:@"memberNo"];
        [list setValue:name forKey:@"name"];
        [list setValue:profileUrl forKey:@"profileUrl"];
        
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
