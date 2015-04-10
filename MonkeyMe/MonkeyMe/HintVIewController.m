//
//  HintVIewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "HintVIewController.h"
#import "FinishPopupViewController.h"
#import "SelectFriendView.h"
#import "SVProgressHUD.h"

#define OBSERVERNAME @"uploadGameDataProcess"

@interface HintVIewController() <UploadGameDelegate>

@end
@implementation HintVIewController
@synthesize gameInfo;
@synthesize networkController;
@synthesize keyboardHeight;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    networkController = [NetworkController sharedInstance];
    [self registerNotification];
    [self registKeyboardNotification];
    
    [self setNavigationItemLeft];
    
    [self performSelector:@selector(showCameraView) withObject:nil afterDelay:0.5f];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unregistKeyboardNotification];
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
    [self sendGameToServer];
}

- (void)sendGameToServer {
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 90);

    [gameInfo setValue:imageData forKey:@"imageData"];
    [gameInfo setValue:self.hintText.text forKey:@"hint"];
    
    [networkController uploadGameData:imageData Keyword:[gameInfo objectForKey:@"keyword"] Hint:self.hintText.text GameNumber:[gameInfo objectForKey:@"gameNumber"] TargetNumber:[gameInfo objectForKey:@"targetNumber"] BananaCount:[gameInfo objectForKey:@"b_count"] Round:[gameInfo objectForKey:@"round"] ObserverName:OBSERVERNAME];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void) transferOkProcess:(NSNotification*)notification { //network notify the result of update request
    
    [SVProgressHUD dismiss];
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
        
        NSString *gameNo = (NSString*)dict[@"gameNo"];
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
        FinishPopupViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FinishPopupViewController"];
        vc.delegate = self;
        vc.g_no = gameNo;
        
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:vc animated:YES completion:nil];
        vc.view.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            vc.view.alpha = 1;
        }];
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
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"sendToFriendSegue"]) {
        
        SelectFriendView *friendView = (SelectFriendView*)segue.destinationViewController;
        friendView.gameInfo = gameInfo;
    }
}


#pragma mark KEYBOARD settings
- (void)registKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void) unregistKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];
    keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self setViewMovedUp:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    [self setViewMovedUp:NO];
}

- (void)keyboardHide {
    [self.view endEditing:YES];
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        
        rect.origin.y -= keyboardHeight.height;
        rect.size.height += keyboardHeight.height;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += keyboardHeight.height;
        rect.size.height -= keyboardHeight.height;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
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

#pragma mark HintViewControlle Delegate

- (void)closePopup:(FinishPopupViewController *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
- (void)sendToFriend:(FinishPopupViewController *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"sendToFriendSegue" sender:self];
}

- (void)addToRandom:(FinishPopupViewController *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    
}

@end
