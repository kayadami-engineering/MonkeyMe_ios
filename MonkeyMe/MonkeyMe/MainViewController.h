//
//  MainViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 7..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "MainTableViewCell.h"

@interface MainViewController : UIViewController <SlideNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *gameListArray;

@end
