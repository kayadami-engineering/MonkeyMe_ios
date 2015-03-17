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
#import "NetworkController.h"

@interface MainViewController : UIViewController <SlideNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stateCount_light;
@property (weak, nonatomic) IBOutlet UILabel *stateCount_banana;
@property (weak, nonatomic) IBOutlet UILabel *stateCount_leaf;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UILabel *myLevel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *gameListArray;
@property (nonatomic, strong) NetworkController *networkController;
@end
