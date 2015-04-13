//
//  PuzzelRightViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 14..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"

@interface PuzzelRightViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *expBar;
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) MainTableViewCell *gameItem;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *replyCount;
@property (strong, nonatomic) NSMutableArray *replyList;
@property (assign, nonatomic) int percent;
- (IBAction)nextGame:(id)sender;
- (IBAction)showAllClick:(id)sender;

@end
