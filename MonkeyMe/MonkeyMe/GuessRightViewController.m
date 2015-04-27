//
//  GuessRightViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "GuessRightViewController.h"
#import "NetworkController.h"
#import "SVProgressHUD.h"

#define MAXREPLYLEN 40
#define OBSERVERNAME @"sendReplyFinishProcess"
@implementation GuessRightViewController
@synthesize percent;
@synthesize gameItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    
    [self.expBar setTransform:CGAffineTransformMakeScale(1.0, 12.0)];
    percent = 33;
    CGFloat curPercent = (CGFloat)self.percent/100;
    [self.expBar setProgress:curPercent];
    
    //set profile image
    [self.profile setImage:[[UIImage alloc]initWithData:gameItem.imageData]];
    self.profile.layer.cornerRadius = self.profile.frame.size.height /2;
    self.profile.layer.masksToBounds = YES;
    self.profile.layer.borderWidth = 0;
    
    self.name.text = gameItem.name;

    [self registerNotification];
    
}

-(void) hideKeyBoard:(UIGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake(320, 1136);
    self.scrollView.scrollEnabled = TRUE;
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(replyListProcess:) name:OBSERVERNAME object:nil];
    
}

- (void)replyListProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..
    [SVProgressHUD dismiss];
    NSLog(@"receive ok");
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (BOOL)checkLength {
    
    UIAlertView *alert;
    if(self.replyText.text.length > MAXREPLYLEN) {
        alert = [[UIAlertView alloc]initWithTitle:@"길이초과" message:@"댓글은 40글자를 넘을 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil];
        [alert show];
        return FALSE;
    }
    else {
        return TRUE;
    }
}
- (IBAction)goMyTurn:(id)sender {
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    if ([self.replyText.text length] > 0 || self.replyText.text != nil || [self.replyText.text isEqual:@""] == FALSE) {
        
        if([self checkLength]) {
            NetworkController *networkController = [NetworkController sharedInstance];
            [networkController sendReply:gameItem.gameNo Contents:self.replyText.text ObserverName:OBSERVERNAME];
        }
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
