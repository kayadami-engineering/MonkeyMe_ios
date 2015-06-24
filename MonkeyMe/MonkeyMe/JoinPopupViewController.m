//
//  JoinPopupViewController.m
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "JoinPopupViewController.h"


@implementation JoinPopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)joinBtnPressed:(id)sender {
    
    if(self.passwordText.text!=nil && self.emailText.text!=nil && self.nameText.text!=nil) {
        if([self.passwordText.text isEqualToString:self.passwordText2.text]) {
            [self.delegate joinRequest:self Email:self.emailText.text Password:self.passwordText.text Name:self.nameText.text];
        }
        else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"비밀번호 오류"
                                                              message:@"비밀번호를 확인해주세요."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"공백 오류"
                                                          message:@"공백값을 입력할 수 없습니다."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
}

- (IBAction)closeBtnPressed:(id)sender {
    [self.delegate closePopup];
}

@end
