//
//  SelectFriendView.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 18..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "SelectFriendView.h"
#import "SelectWordView.h"
#import "MainTableViewCell.h"
#import "FinishPopupViewController.h"
#import "NetworkController.h"
#import "CommonSharedObject.h"

#define OBSERVERNAME_1 @"m_friendListProcess"
#define OBSERVERNAME_2 @"f_friendListProcess"
#define OBSERVERNAME_3 @"uploadGameDataProcess2"

@interface SelectFriendView() <UploadGameDelegate>

@end

@implementation SelectFriendView
@synthesize friendList;
@synthesize networkController;
@synthesize targetNumber;
@synthesize gameInfo;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItem];

    networkController = [NetworkController sharedInstance];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self registerNotification];
    friendList = [[NSMutableArray alloc]init];
    
    [self.networkController getMonkeyFriendList:OBSERVERNAME_1];
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(monkeyFriendListUpdate:) name:OBSERVERNAME_1 object:nil];
    [sendNotification addObserver:self selector:@selector(transferOkProcess:) name:OBSERVERNAME_3 object:nil];
}



- (void)monkeyFriendListUpdate:(NSNotification *)notification {
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        
        NSMutableArray *list = (NSMutableArray*)dict[@"friendList"];
        
        //get game list my turn
        
        for(int i=0;i<[list count];i++) {
            dict = [list objectAtIndex:i];
            
            MainTableViewCell *listItem = [[MainTableViewCell alloc]init];
            
            listItem.memberNo = (NSString*)dict[@"memberNo"];
            listItem.profileUrl = (NSString*)dict[@"profileUrl"];
            listItem.name = (NSString*)dict[@"name"];
            [friendList addObject:listItem];
        }
        
        [self.collectionView reloadData];
    }
}

- (void) transferOkProcess:(NSNotification*)notification { //network notify the result of update request
    
    //do something..
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        
        CommonSharedObject *commonSharedObject = [CommonSharedObject sharedInstance];
        NSString *storyboardName = commonSharedObject.storyboardName;
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboardName
                                                                 bundle: nil];
        FinishPopupViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FinishPopupViewController"];
        vc.delegate = self;
        
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:vc animated:YES completion:nil];
        vc.view.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            vc.view.alpha = 1;
        }];
    }
}

- (void)setNavigationItem {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)back {
    
    if(![gameInfo objectForKey:@"keyword"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"SelectWordSegue"]) {
        
        SelectWordView *wordView = (SelectWordView*)segue.destinationViewController;
        gameInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  targetNumber, @"targetNumber",
                                  @"0",@"gameNumber",
                                  @"1",@"round",
                                  nil];
        wordView.gameInfo = gameInfo;
    }
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
    
    return [self.friendList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MainTableViewCell *gList = [friendList objectAtIndex:indexPath.row];

    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];

    dispatch_async(kBgQueue, ^{
        
        NSURL *url;
        NSData *data;
        
        if(gList.imageData) {
            data = gList.imageData;
        }
        else {
            url = [NSURL URLWithString:gList.profileUrl];
            data = [NSData dataWithContentsOfURL:url];
            gList.imageData = data;
        }
        
        if(data) {
            UIImage *image = [[UIImage alloc]initWithData:data];
            
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITableViewCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    
                    if (updateCell) {
                        imageView.image = image;
                    }
                });
            }
        }
    });
    
    imageView.layer.cornerRadius = imageView.frame.size.height /2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0;
    
    UILabel *title = (UILabel*)[cell viewWithTag:101];
    title.text = gList.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainTableViewCell *gList = [friendList objectAtIndex:indexPath.row];
    targetNumber = gList.memberNo;
    
    if(![gameInfo objectForKey:@"keyword"]) {
        
        [self performSegueWithIdentifier:@"SelectWordSegue" sender:self];
    }
    
    
    else {
        [networkController uploadGameData:[gameInfo objectForKey:@"imageData"] Keyword:[gameInfo objectForKey:@"keyword"] Hint:[gameInfo objectForKey:@"hint"] GameNumber:[gameInfo objectForKey:@"gameNumber"] TargetNumber:targetNumber BananaCount:[gameInfo objectForKey:@"b_count"] Round:[gameInfo objectForKey:@"round"] ObserverName:OBSERVERNAME_3];
    }
    
}

#pragma mark HintViewControlle Delegate

- (void)closePopup:(FinishPopupViewController *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
- (void)sendToFriend:(FinishPopupViewController *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)addToRandom:(FinishPopupViewController *)controller {
    
}

@end
