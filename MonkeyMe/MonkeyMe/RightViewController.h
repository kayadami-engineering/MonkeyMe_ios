//
//  RIghtViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 7..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationContorllerAnimator.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "NetworkController.h"

@interface RightViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchBar *headerSearch;
@property (nonatomic, strong) NSMutableSet *collapsedSections;
@property (nonatomic, strong) NSMutableArray *facebookFriendList;
@property (nonatomic, strong) NSMutableArray *monkeyFriendList;
@property (nonatomic, strong) NetworkController *networkController;
@property (nonatomic, assign) bool blockUpdate;

@end
