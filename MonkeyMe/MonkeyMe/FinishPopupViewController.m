//
//  FinishPopupViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "FinishPopupViewController.h"
#import "NetworkController.h"
#import "SVProgressHUD.h"

#define OBSERVERNAME @"addToRandomProcess"

@implementation FinishPopupViewController
@synthesize delegate;
@synthesize g_no;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self registerNotification];

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(transferOkProcess:) name:OBSERVERNAME object:nil];
}

- (IBAction)okBtnPressed:(id)sender {
    [delegate closePopup:self];
}

- (IBAction)sendToFriend:(id)sender {
    [delegate sendToFriend:self];
}

- (IBAction)addToRandom:(id)sender {
    
    NetworkController *networkController = [NetworkController sharedInstance];
    [networkController addToRandomMode:g_no ObserverName:OBSERVERNAME];
}

- (void) transferOkProcess:(NSNotification*)notification { //network notify the result of update request
    
    //do something..
    NSLog(@"received somthing");
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        [delegate addToRandom:self];
    }
}


@end
