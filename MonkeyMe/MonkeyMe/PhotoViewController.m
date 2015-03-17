//
//  photoViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "PhotoViewController.h"

#import "NetworkController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation PhotoViewController
@synthesize imageListArray;
@synthesize delegate;

- (void)viewDidLoad
{
    //[self setCollection];
    [super viewDidLoad];
    [self registerNotification];
    
    NetworkController *networkController = [NetworkController sharedInstance];
    [networkController getProfileGameListRequest];
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(updateList:) name:@"profileGameListProcess" object:nil];
}
- (void)updateList:(NSNotification *)notification {

    imageListArray = [[NSMutableArray alloc]init];
    
    NSDictionary* dict = notification.userInfo;
    
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        
        NSMutableArray *items = (NSMutableArray*)dict[@"items"];
        // Get user profile info
    
        for(int i=0;i<[items count];i++) {
            
            NSMutableDictionary *item = (NSMutableDictionary*)[items objectAtIndex:i];
            
            NSString *imageUrl = (NSString*)item[@"imageUrl"];
            NSString *keyword = (NSString*)item[@"keyword"];
            NSString *hint = (NSString*)item[@"hint"];
            NSString *date = (NSString*)item[@"date"];
            
            ProfileImageItemCell *listItem = [[ProfileImageItemCell alloc]init];
            
            listItem.imageUrl = imageUrl;
            listItem.keyword = keyword;
            listItem.hint = hint;
            listItem.date = date;

            [imageListArray addObject:listItem];
        }
        [self.collectionView reloadData];
    }

    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark Collection View Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageListArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ProfileImageItemCell *gList = [imageListArray objectAtIndex:indexPath.row];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
    
    dispatch_async(kBgQueue, ^{
        
        NSURL *url = [NSURL URLWithString:gList.imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        gList.imageData = data;
        
        if(data) {
            UIImage *image = [[UIImage alloc]initWithData:data];
            
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UICollectionViewCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    
                    if (updateCell) {
                        imageView.image = image;
                        
                    }
                });
            }
        }
    });
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileImageItemCell *gList = [imageListArray objectAtIndex:indexPath.row];
    
    [self.delegate selectItem:gList];
}


@end
