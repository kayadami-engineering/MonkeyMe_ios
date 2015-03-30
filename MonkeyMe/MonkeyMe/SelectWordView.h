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

@interface SelectWordView : UIViewController <SlideNavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *targetNumber;
@property (nonatomic, strong) NSMutableArray *wordItemList;
@property (nonatomic, strong) WordItemCell *selectedItem;
@end
