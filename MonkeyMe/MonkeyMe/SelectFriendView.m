//
//  SelectFriendView.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 18..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "SelectFriendView.h"
#import "ProfileImageItemCell.h"

@implementation SelectFriendView
@synthesize imageListArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItem];
    [self setCollection];
}

- (void)setCollection {
    
    imageListArray = [[NSMutableArray alloc]init];
    
    ProfileImageItemCell *ky = [[ProfileImageItemCell alloc]init];
    
    ky.imageName = @"ky.png";
    ky.content = @"Kaya";
    
    ProfileImageItemCell *yong = [[ProfileImageItemCell alloc]init];
    
    yong.imageName = @"yong.jpg";
    yong.content = @"Developer";
    
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
- (void)setNavigationItem {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

#pragma Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.imageListArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    ProfileImageItemCell *gList = [imageListArray objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:gList.imageName];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
    imageView.image = image;
    
    imageView.layer.cornerRadius = imageView.frame.size.height /2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0;
    
    UILabel *title = (UILabel*)[cell viewWithTag:101];
    title.text = gList.content;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"SelectWordSegue" sender:self];
}

@end
