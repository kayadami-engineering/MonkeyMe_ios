//
//  SelectWordView.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "WordItemCell.h"
#import "NetworkController.h"

@interface SelectWordView : UIViewController <SlideNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *wordItemList;
@property (nonatomic, strong) NSMutableDictionary *gameInfo;
@property (nonatomic, strong) WordItemCell *selectedItem;
@property (nonatomic, strong) NetworkController *networkController;
@end
