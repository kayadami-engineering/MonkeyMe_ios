//
//  photoViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 16..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "PhotoViewController.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>

#define OBSERVERNAME1 @"profileGameListProcess"

@implementation PhotoViewController
@synthesize imageListArray;
@synthesize delegate;
@synthesize friendNumber;
@synthesize networkController;

- (void)viewDidLoad
{
    //[self setCollection];
    [super viewDidLoad];
    [self registerNotification];
    
    networkController = [NetworkController sharedInstance];
    
    [networkController getProfileGameListRequest:friendNumber ObserverName:OBSERVERNAME1];
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(updateList:) name:OBSERVERNAME1 object:nil];
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
            
            NSString *g_no = (NSString*)item[@"gameNo"];
            NSString *imageUrl = (NSString*)item[@"imageUrl"];
            NSString *keyword = (NSString*)item[@"keyword"];
            NSString *hint = (NSString*)item[@"hint"];
            NSString *date = (NSString*)item[@"date"];
            NSString *rate = (NSString*)item[@"rate"];
            NSString *playCount = (NSString*)item[@"playCount"];
            NSString *replyCount = (NSString*)item[@"replyCount"];
            
            ProfileImageItemCell *listItem = [[ProfileImageItemCell alloc]init];
            
            listItem.g_no = g_no;
            listItem.imageUrl = imageUrl;
            listItem.keyword = keyword;
            listItem.hint = hint;
            listItem.date = date;
            listItem.playCount = playCount;
            listItem.replyCount = replyCount;
            listItem.rate = rate;

            [imageListArray addObject:listItem];
        }
        [self.delegate setPhotoCountValue:[imageListArray count]];
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
    UIImageView *playBtn = (UIImageView*)[cell viewWithTag:101];
    
    dispatch_async(kBgQueue, ^{
        
        NSData *data;
        
        NSURL *url = [NSURL URLWithString:gList.imageUrl];
        NSString *ext = [[gList.imageUrl componentsSeparatedByString:@"."] lastObject];
        
        //image
        if([ext isEqualToString:@"jpeg"] || [ext isEqualToString:@"bmp"]) {
            
            if(gList.imageData) {
                data = gList.imageData;
            }
            else {
                data = [NSData dataWithContentsOfURL:url];
                gList.imageData = data;
            }
            
            if(data) {
                UIImage *image = [[UIImage alloc]initWithData:data];
                
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UICollectionViewCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                        
                        if (updateCell) {
                            imageView.image = image;
                            playBtn.hidden = TRUE;
                            
                        }
                    });
                }
            }
        }
        // video
        else {
            
            UIImage *thumbnail;
            CGImageRef imageRef;
            
            if(gList.videoRef) {
                imageRef = gList.videoRef;
            }
            else {
                
                AVAsset *asset = [AVAsset assetWithURL:url];
                AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
                CMTime time = CMTimeMake(1, 1);
                imageRef= [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
                gList.videoRef = imageRef;
            }
            
            thumbnail = [UIImage imageWithCGImage:imageRef];
            
            if (thumbnail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UICollectionViewCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    
                    if (updateCell) {
                        
                        playBtn.hidden = FALSE;
                        imageView.image = thumbnail;
                        
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
