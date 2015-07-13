//
//  LoginViewController.m
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 9..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "LoginViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "SVProgressHUD.h"
#import "NetworkController.h"
#import "CommonSharedObject.h"
#import "KeychainItemWrapper.h"


#define OBSERVERNAME1 @"loginProcess"
#define OBSERVERNAME2 @"joinProcess"

@interface LoginViewController () <LoginViewControllerDelegate, JoinViewControllerDelegate, WYPopoverControllerDelegate> {
   
    LoginPopupViewController *loginPopupViewController;
    JoinPopupViewController *joinPopupViewController;
}
@end
@implementation LoginViewController
@synthesize loginBtn;
@synthesize popoverController;
@synthesize networkController;
@synthesize myEmail;
@synthesize myPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotification];
    
    networkController = [NetworkController sharedInstance];
    
    self.facebookBtn.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginPopupSegue"])
    {
        loginPopupViewController = segue.destinationViewController;
        loginPopupViewController.delegate = self;

        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                                    permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                    animated:YES
                                                                     options:WYPopoverAnimationOptionFadeWithScale
                                                                 mode:0];
        popoverController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"JoinPopupSegue"])
    {
        joinPopupViewController = segue.destinationViewController;
        joinPopupViewController.delegate = self;
        
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                                  permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                  animated:YES
                                                                   options:WYPopoverAnimationOptionFadeWithScale
                                                                 mode:1];
        popoverController.delegate = self;
        
    }
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(loginProcess:) name:OBSERVERNAME1 object:nil];
    [sendNotification addObserver:self selector:@selector(joinProcess:) name:OBSERVERNAME2 object:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 사용자가 Yes를 선택한 경우
    if (buttonIndex == 1) {
        NSLog(@"yes");
    }
}

- (void)loginProcess:(NSNotification *)notification { //network notify the result of login request
    
    //do something..
    [SVProgressHUD dismiss];
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if login failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
        
        if([message isEqualToString:@"errmsg_2"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"로그인 실패"
                                                          message:@"아이디/비밀번호를 확인해 주세요."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [message show];
        }
        else if([message isEqualToString:@"errmsg_2-2"]) { //facebook login failed
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"가입된 계정이 없습니다."
                                                              message:@"페이스북 계정으로 회원 가입하시겠습니까?"
                                                             delegate:self
                                                    cancelButtonTitle:@"NO"
                                                    otherButtonTitles:@"YES",nil];
            [message show];
            
        }
    }
    else {
        
        [self closePopup];
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"monkeymeLogin" accessGroup:nil];
        
        
        NSString *index = (NSString*)dict[@"memberNo"];
        
        [wrapper setObject:index forKey:(__bridge id)kSecAttrAccount];
        
        networkController.myMemberNumber = index;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self performSegueWithIdentifier:@"MainViewSegue" sender:self];
    }
}

- (void)joinProcess:(NSNotification *)notification { //network notify the result of login request
    
    //do something..
    [SVProgressHUD dismiss];
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if login failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"회원가입 실패"
                                                          message:@"사용 불가한 이메일입니다."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    else {
        
        
        [self closePopup];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"회원가입 완료"
                                                          message:@"로그인 해주세요."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

    }
}


- (void)closePopup {
    
    joinPopupViewController.delegate = nil;
    loginPopupViewController.delegate = nil;
    
    [popoverController dismissPopoverAnimated:YES];
    popoverController.delegate = nil;
    popoverController = nil;
}

#pragma mark - Login popup View Delegate


- (void)loginRequest:(LoginPopupViewController *)controller Email:(NSString*)email Password:(NSString*)password; {
    
    loginPopupViewController = controller;
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    CommonSharedObject *commonObject = [CommonSharedObject sharedInstance];
    
    [networkController loginRequest:email Password:(NSString*)password DevToken:commonObject.tokenString FacebookFlag:FALSE ObserverName:OBSERVERNAME1]; //request login
    
}

#pragma mark - Join popup View Delegate


- (void)joinRequest:(JoinPopupViewController *)controller Email:(NSString*)email Password:(NSString*)password Name:(NSString*)name  {
    
    joinPopupViewController = controller;
    
    myEmail = email;
    myPassword = password;
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    [networkController joinRequest:email Password:password Name:name ObserverName:OBSERVERNAME2];
    
}

#pragma mark Facebook

-(void)fetchUserInfo {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);
             NSString *email = result[@"email"];
             CommonSharedObject *commonObject = [CommonSharedObject sharedInstance];
             [networkController loginRequest:email Password:@"" DevToken:commonObject.tokenString FacebookFlag:TRUE ObserverName:OBSERVERNAME1]; //request login
         }
     }];
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    NSLog(@"LOGGED IN TO FACEBOOK");
    [self fetchUserInfo];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
    NSLog(@"logout");
}

@end
