//
//  ReplyViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 10..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "NetworkController.h"

@interface ReplyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (IBAction)okBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *replyList;
@property (strong, nonatomic) WYPopoverController *popoverController;
@property (strong, nonatomic) NetworkController *networkController;
@property (strong, nonatomic) NSString *g_no;
@property (weak, nonatomic) IBOutlet UITextField *replyText;
@property (assign, nonatomic) CGSize keyboardHeight;
@property (strong, nonatomic) NSMutableDictionary *userStateInfo;
@end
