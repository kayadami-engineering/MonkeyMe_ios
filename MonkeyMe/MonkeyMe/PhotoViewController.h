//
//  photoViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileImageItemCell.h"
#import "NetworkController.h"

@protocol PhotoViewDelegate;

@interface PhotoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageListArray;
@property (weak, nonatomic) id<PhotoViewDelegate> delegate;
@property (strong, nonatomic) NSString *friendNumber;
@property (strong, nonatomic) NetworkController *networkController;
@end

@protocol PhotoViewDelegate <NSObject>

@optional
- (void)selectItem:(ProfileImageItemCell*)item;
- (void)setPhotoCountValue:(NSInteger)count;

@end