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
@synthesize currentElementValue;
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
    NSString *postLength = [NSString stringWithFormat:@"%i", [postData length]];
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
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

-(void)loginRequest:(NSString*)email Password:(NSString*)password {
    
    currentCommand = @"login";
    NSString *string = [NSString stringWithFormat:@"command=%@&email=%@",currentCommand,email];
    [self postToServer:string];
}

-(void)updateMainRequest {
    
    if(myMemberNumber) {
        currentCommand = @"updateMain";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i",currentCommand,myMemberNumber];
        [self postToServer:string];
    }
}

-(void)getProfileGameListRequest {
    
    if(myMemberNumber) {
        currentCommand = @"pastList";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i",currentCommand,myMemberNumber];
        [self postToServer:string];
    }
}

-(void)updateProfile:(NSString*)name Id:(NSString*)myID {
    
    if(myMemberNumber) {
        currentCommand = @"updateProfile";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i&name=%@&id=%@",currentCommand,myMemberNumber,name,myID];
        [self postToServer:string];
    }
}

-(void)getMonkeyFriendList {
    
    if(myMemberNumber) {
        currentCommand = @"friendlist_monkey";
        NSString *string = [NSString stringWithFormat:@"command=%@&memberNumber=%i",currentCommand,myMemberNumber];
        [self postToServer:string];
    }
}

-(void)uploadGameData:(NSData*)data {
    
    if(myMemberNumber) {
        currentCommand = @"uploadGameData";
        NSDictionary *params = @{@"command":currentCommand, @"memberNumber":[NSString stringWithFormat:@"%i",myMemberNumber]};
        [self postToServerWithData:data Filename:@"file.jpeg" Data:params];
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
       
        if([result isEqualToString:@"error"]) { //when error encountered
            
            if([currentCommand isEqualToString:@"login"]) { //if login failed
                [notificationCenter postNotificationName:@"loginProcess" object:self userInfo:tempDictionary];
            }
            else if([currentCommand isEqualToString:@"updateMain"]) {
                [notificationCenter postNotificationName:@"updateMainProcess" object:self userInfo:tempDictionary];
            }
            else if([currentCommand isEqualToString:@"uploadGameData"]) {

                [notificationCenter postNotificationName:@"uploadGameDataProcess" object:self userInfo:tempDictionary];
            }
        }
        else { //success
            
            if([currentCommand isEqualToString:@"uploadGameData"]) {

                [notificationCenter postNotificationName:@"uploadGameDataProcess" object:self userInfo:tempDictionary];
            }
        }
    }
    
    else if([elementName isEqualToString:@"state"]) { //My state
        
        if([currentCommand isEqualToString:@"login"]) { //if login succeeed
            NSString *memberNo = [attributeDict objectForKey:@"m_no"];
            NSString *memberID = [attributeDict objectForKey:@"id"];
            
            [tempDictionary setValue:memberNo forKey:@"memberNo"];
            [tempDictionary setValue:memberID forKey:@"memberID"];
            
            [notificationCenter postNotificationName:@"loginProcess" object:self userInfo:tempDictionary];
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
    
    else if([elementName isEqualToString:@"friend"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSString *memberNo = [attributeDict objectForKey:@"m_no"];
        NSString *memberID = [attributeDict objectForKey:@"id"];
        NSString *name = [attributeDict objectForKey:@"name"];
        NSString *level = [attributeDict objectForKey:@"level"];
        NSString *profileUrl = [attributeDict objectForKey:@"profile"];
        NSString *round = [attributeDict objectForKey:@"round"];
        
        [list setValue:memberNo forKey:@"memberNo"];
        [list setValue:memberID forKey:@"memberID"];
        [list setValue:name forKey:@"name"];
        [list setValue:level forKey:@"level"];
        [list setValue:profileUrl forKey:@"profileUrl"];
        [list setValue:round forKey:@"round"];
        
        if([currentCommand isEqualToString:@"updateMain_myturn"])
            [tempArray addObject:list];
        else if([currentCommand isEqualToString:@"updateMain_friendsturn"])
            [tempArray2 addObject:list];
    }
    
    else if([elementName isEqualToString:@"item"]) {
        
        NSMutableDictionary *list = [[NSMutableDictionary alloc]init];
        
        NSString *game_no = [attributeDict objectForKey:@"no"];
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
    //NSLog(@"Processing Element: %@", elementName);
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
    
    //NSLog(@"Processing Value: %@", currentElementValue);
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"list"]) {
        if([currentCommand isEqualToString:@"updateMain_myturn"]) {
            [tempDictionary setValue:tempArray forKey:@"gamelist_myturn"];
            
        }
        
        else if([currentCommand isEqualToString:@"updateMain_friendsturn"]) {
            [tempDictionary setValue:tempArray2 forKey:@"gamelist_friendsturn"];
            [notificationCenter postNotificationName:@"updateMainProcess" object:self userInfo:tempDictionary];
        }
        
        else if([currentCommand isEqualToString:@"pastList"]) {
            [tempDictionary setValue:tempArray forKey:@"items"];
            [notificationCenter postNotificationName:@"profileGameListProcess" object:self userInfo:tempDictionary];
        }
        
        else if([currentCommand isEqualToString:@"friendlist_monkey"]) {
            [tempDictionary setValue:tempArray forKey:@"friendList"];
            [notificationCenter postNotificationName:@"m_friendListProcess" object:self userInfo:tempDictionary];
        }
    }

    else if([elementName isEqualToString:@"data"]) {
        
        if([currentCommand isEqualToString:@"updateProfile"]) {
            
            [notificationCenter postNotificationName:@"updateProfileProcess" object:self userInfo:tempDictionary];
        }
    }
    
    else if([elementName isEqualToString:@"xml"]) {
        
        //empty all temporary container objects
        [tempDictionary removeAllObjects];
        [tempArray removeAllObjects];
        [tempArray2 removeAllObjects];
        
        currentCommand = @"";
    }
    
    currentElementValue = nil;
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
}

@end
