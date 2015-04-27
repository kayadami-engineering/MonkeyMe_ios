//
//  EditProfileViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "EditProfileViewController.h"
#import "NetworkController.h"
#import "SVProgressHUD.h"

#define MAXNAMELEN  10
#define MAXIDLEN    12
#define OBSERVERNAME @"updateProfileProcess"

@implementation EditProfileViewController
@synthesize userStateInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self registerNotification];
    [self setProfile];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"remove");
}

- (void)setProfile {
    
    NSString *memberID = (NSString*)userStateInfo[@"memberID"];
    NSString *name = (NSString*)userStateInfo[@"name"];
    NSString *email = (NSString*)userStateInfo[@"email"];
    UIImage *image = (UIImage*)userStateInfo[@"profileImage"];
    
    [self.profileImage setImage:image];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    self.myName.text = name;
    self.myID.text = memberID;
    self.myEmail.text = email;
    
}

- (void)setNavigationItem {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [buttonLeft setTitle:@"취소" forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *buttonRight  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [buttonRight setTitle:@"완료" forState:UIControlStateNormal];
    [buttonRight addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ok {
    
    if([self checkLength]) {
        NetworkController *networkController = [NetworkController sharedInstance];
        [networkController updateProfile:self.myName.text Id:self.myID.text ObserverName:OBSERVERNAME];
        [SVProgressHUD setViewForExtension:self.view];
        [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
        [SVProgressHUD show];
    }
    
}

- (BOOL)checkLength {
    
    UIAlertView *alert;
    if(self.myName.text.length > MAXNAMELEN) {
        alert = [[UIAlertView alloc]initWithTitle:@"길이초과" message:@"이름은 10글자를 넘을 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil];
        [alert show];
        return FALSE;
    }
    else if(self.myID.text.length > MAXIDLEN) {
        alert = [[UIAlertView alloc]initWithTitle:@"길이초과" message:@"아이디는 12글자를 넘을 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil];
        [alert show];
        return FALSE;
    }
    else {
        return TRUE;
    }
}
- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(updateProcess:) name:OBSERVERNAME object:nil];
}

- (void)updateProcess:(NSNotification *)notification {
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        [SVProgressHUD dismiss];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
    
}

- (IBAction)photoEditPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진 촬영",@"사진 앨범", nil];
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}
@end
