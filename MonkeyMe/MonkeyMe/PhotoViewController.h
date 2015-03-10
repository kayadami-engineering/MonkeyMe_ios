//
//  photoViewController.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoViewDelegate;

@interface PhotoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageListArray;
@property (weak, nonatomic) id<PhotoViewDelegate> delegate;
@end

@protocol PhotoViewDelegate <NSObject>

@optional
- (void)selectImage:(UIImage*)selectedImage;

@end