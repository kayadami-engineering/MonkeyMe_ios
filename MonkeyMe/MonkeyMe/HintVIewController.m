//
//  HintVIewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "HintVIewController.h"
#import "FinishPopupViewController.h"
#import "NetworkController.h"

#define OBSERVERNAME @"uploadGameDataProcess"

@implementation HintVIewController
@synthesize wordItem;
@synthesize gameInfo;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItemLeft];
    
    [self performSelector:@selector(showCameraView) withObject:nil afterDelay:0.5f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotification];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) showCameraView {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    [imagePickerController setDelegate:self];
    [imagePickerController setAllowsEditing:YES];
    
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)setNavigationItemLeft {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)setNavigationItemRight {
    
    UIButton *buttonRight  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [buttonRight addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)back {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(transferOkProcess:) name:OBSERVERNAME object:nil];
}
- (void)ok {
    [self.view endEditing:YES];
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 90);
    
    NetworkController *networkController = [NetworkController sharedInstance];
    
    [networkController uploadGameData:imageData Keyword:wordItem.keyword Hint:self.hintText.text GameNumber:[gameInfo objectForKey:@"gameNumber"] TargetNumber:[gameInfo objectForKey:@"targetNumber"] BananaCount:wordItem.b_count Round:[gameInfo objectForKey:@"round"] ObserverName:OBSERVERNAME];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
        UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FinishPopupViewController"];
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:vc animated:YES completion:nil];
        vc.view.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            vc.view.alpha = 1;
        }];
    
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

- (UIImage*) ImageResize:(UIImage*)image Size:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage*scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self setNavigationItemRight];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
