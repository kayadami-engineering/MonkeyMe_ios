//
//  SelectFriendView.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 18..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "NetworkController.h"
#import "WordItemCell.h"

@interface SelectFriendView : UIViewController<SlideNavigationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *friendList;
@property (nonatomic, strong) NetworkController *networkController;
@property (nonatomic, strong) NSString *targetNumber;
@property (strong, nonatomic) NSMutableDictionary* gameInfo;

@end
