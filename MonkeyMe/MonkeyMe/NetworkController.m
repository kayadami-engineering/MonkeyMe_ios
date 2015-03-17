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

@synthesize myID;

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
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    notificationCenter = [NSNotificationCenter defaultCenter];
    tempDictionary = [[NSMutableDictionary alloc] init];
    tempArray = [[NSMutableArray alloc]init];
    tempArray2 = [[NSMutableArray alloc]init];
    
}

-(void)postToServer:(NSString *)postString {
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - Request Command Methods-

-(void)joinRequest {
    
}

-(void)loginRequest:(NSString*)email Password:(NSString*)password {
    
    NSString *string = [NSString stringWithFormat:@"command=login&email=%@",email];
    [self postToServer:string];
}

-(void)updateMainRequest {
    
    myID = @"damee.yoon";
    
    if(myID) {
        NSString *string = [NSString stringWithFormat:@"command=updateMain&memberID=%@",myID];
        [self postToServer:string];
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
        }
    }
    
    else if([elementName isEqualToString:@"state"]) { //My state
        
        if([currentCommand isEqualToString:@"login"]) { //if login succeeed
            NSString *index = [attributeDict objectForKey:@"idx"];
            NSString *memberID = [attributeDict objectForKey:@"id"];
            
            [tempDictionary setValue:index forKey:@"memberIndex"];
            [tempDictionary setValue:memberID forKey:@"memberID"];
            
            [notificationCenter postNotificationName:@"loginProcess" object:self userInfo:tempDictionary];
        }
        else if([currentCommand isEqualToString:@"updateMain"]) { //if update main succeed
            NSString *index = [attributeDict objectForKey:@"idx"];
            NSString *memberID = [attributeDict objectForKey:@"id"];
            NSString *name = [attributeDict objectForKey:@"name"];
            NSString *level = [attributeDict objectForKey:@"level"];
            NSString *profileUrl = [attributeDict objectForKey:@"profile"];
            NSString *lightCount = [attributeDict objectForKey:@"light"];
            NSString *bananaCount = [attributeDict objectForKey:@"banana"];
            NSString *leafCount = [attributeDict objectForKey:@"leaf"];
            
            [tempDictionary setValue:index forKey:@"memberIndex"];
            [tempDictionary setValue:memberID forKey:@"memberID"];
            [tempDictionary setValue:name forKey:@"name"];
            [tempDictionary setValue:level forKey:@"level"];
            [tempDictionary setValue:lightCount forKey:@"lightCount"];
            [tempDictionary setValue:bananaCount forKey:@"bananaCount"];
            [tempDictionary setValue:leafCount forKey:@"leafCount"];
            [tempDictionary setValue:profileUrl forKey:@"profileUrl"];
            
            
            
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
            
        NSString *memberID = [attributeDict objectForKey:@"id"];
        NSString *name = [attributeDict objectForKey:@"name"];
        NSString *level = [attributeDict objectForKey:@"level"];
        NSString *profileUrl = [attributeDict objectForKey:@"profile"];
        NSString *round = [attributeDict objectForKey:@"round"];
        
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
    
    NSLog(@"Processing Element: %@", elementName);
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
    
    NSLog(@"Processing Value: %@", currentElementValue);
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
    }
    
    if([elementName isEqualToString:@"xml"]) {
        
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
    NSLog(@"error received = %@", error);
}

@end
