//
//  photoViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "PhotoViewController.h"
#import "ProfileImageItemCell.h"

@implementation PhotoViewController
@synthesize imageListArray;
@synthesize delegate;

- (void)viewDidLoad
{
    [self setCollection];
    [super viewDidLoad];
}

- (void)setCollection {
    
    imageListArray = [[NSMutableArray alloc]init];
    
    ProfileImageItemCell *ky = [[ProfileImageItemCell alloc]init];
    
    ky.imageName = @"ky.png";
    ky.content = @"Kaya";
    
    ProfileImageItemCell *yong = [[ProfileImageItemCell alloc]init];
    
    yong.imageName = @"yong.jpg";
    yong.content = @"Developer of Majesty";
    
    ProfileImageItemCell *medic = [[ProfileImageItemCell alloc]init];
    
    medic.imageName = @"medic.jpg";
    medic.content = @"Medic";
    
    ProfileImageItemCell *chole = [[ProfileImageItemCell alloc]init];
    
    chole.imageName = @"chole.jpg";
    chole.content = @"Chole Moretz";
    
    [imageListArray addObject:ky];
    [imageListArray addObject:yong];
    [imageListArray addObject:medic];
    [imageListArray addObject:chole];
    [imageListArray addObject:ky];
    [imageListArray addObject:yong];
    [imageListArray addObject:medic];
    [imageListArray addObject:chole];
    
    [imageListArray addObject:ky];
    [imageListArray addObject:yong];
    [imageListArray addObject:medic];
    [imageListArray addObject:chole];
    [imageListArray addObject:ky];
    [imageListArray addObject:yong];
    [imageListArray addObject:medic];
    [imageListArray addObject:chole];
    
}


#pragma mark Collection View Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageListArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ProfileImageItemCell *gList = [imageListArray objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:gList.imageName];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
    imageView.image = image;
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileImageItemCell *gList = [imageListArray objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:gList.imageName];

    [self.delegate selectImage:image];
}


@end
