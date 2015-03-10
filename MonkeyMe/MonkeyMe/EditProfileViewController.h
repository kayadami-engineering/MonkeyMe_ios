//
//  EditProfileViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController<UIActionSheetDelegate> {
    
}

- (IBAction)photoEditPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@end
