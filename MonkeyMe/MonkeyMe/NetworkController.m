//
//  NetworkController.m
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 22..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController
@synthesize currentElementValue;
@synthesize serverURL;
@synthesize myParser;
@synthesize request;
@synthesize responseData;

-(void)initNetwork {
    
    serverURL = [NSURL URLWithString:@"http://www.happinuss.com/happinus_app_server/RequestHandleServer.php"];
    request = [[NSMutableURLRequest alloc]init];
    [request setURL:serverURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
}

-(void)postToServer:(NSString *)postString {
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma Parser Delegate
-(void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"Books"]) {
        //Initialize the array.
    }
    else if([elementName isEqualToString:@"Book"]) {
        
        //Initialize the book.
        
        //Extract the attribute here.
        
        NSLog(@"Reading id value :%i", [[attributeDict objectForKey:@"id"] integerValue]);
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
    
    if([elementName isEqualToString:@"Books"]) {
        
        
    }
    
    if([elementName isEqualToString:@"Book"]) {
        
    }
    else {
        
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
