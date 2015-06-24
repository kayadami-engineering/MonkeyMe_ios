//
//  MainViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 7..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "NetworkController.h"
#import "ProfileViewController.h"
#import "SVProgressHUD.h"
#import "GuessViewController.h"
#import "SelectWordView.h"
#import "CommonSharedObject.h"

#define PVPMODE     1
#define RANDMODE    2

#define OBSERVERNAME1 @"updateMainProcess"
#define OBSERVERNAME2 @"deleteOkProcess"

@implementation MainViewController
@synthesize myTableView;
@synthesize scrollView;
@synthesize gameListArray;
@synthesize profileImage;
@synthesize networkController;
@synthesize userStateInfo;
@synthesize gameItem;
@synthesize playMode;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItem];
    [self registerNotification];
    networkController = [NetworkController sharedInstance];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    [networkController updateMainRequest:OBSERVERNAME1];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    [networkController updateMainRequest:OBSERVERNAME1];
    
}
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setProfileImageFromURL:(NSString*)profileUrl {
    
    if([profileUrl isEqualToString:@"default"]) {
        [self.profileImage setImage:[UIImage imageNamed:@"profile_default.png"]];
    }
    else {
        NSURL *url = [NSURL URLWithString:profileUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if(data) {
            UIImage *image = [[UIImage alloc]initWithData:data];
            
            [self.profileImage setImage:image];
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
            self.profileImage.layer.masksToBounds = YES;
            self.profileImage.layer.borderWidth = 0;
            
            [userStateInfo setValue:image forKey:@"profileImage"];
        }
        
        else {
            NSLog(@"failed to load image");
        }
    }
}
- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(updateProcess:) name:OBSERVERNAME1 object:nil];
    [sendNotification addObserver:self selector:@selector(deleteOkProcess:) name:OBSERVERNAME2 object:nil];

}

- (void)updateProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..
    
    [SVProgressHUD dismiss];
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        
        userStateInfo = (NSMutableDictionary*)dict[@"userInfo"];
        // Get user profile info
        
        NSString *name = (NSString*)userStateInfo[@"name"];
        NSString *level = (NSString*)userStateInfo[@"level"];
        NSString *profileUrl = (NSString*)userStateInfo[@"profileUrl"];
        NSString *lightCount = (NSString*)userStateInfo[@"lightCount"];
        NSString *bananaCount = (NSString*)userStateInfo[@"bananaCount"];
        NSString *leafCount = (NSString*)userStateInfo[@"leafCount"];
    
        [self.myName setText:name];
        [self.myLevel setText:level];
        [self.stateCount_light setText:lightCount];
        [self.stateCount_banana setText:bananaCount];
        [self.stateCount_leaf setText:leafCount];
        
        
        //get game list
        NSMutableArray *gameListMyturn = (NSMutableArray*)dict[@"gamelist_myturn"];
        NSMutableArray *gameListFriendsTurn = (NSMutableArray*)dict[@"gamelist_friendsturn"];
        
        gameListArray = [[NSMutableArray alloc]init];
        NSMutableArray *myTurnList = [[NSMutableArray alloc]init];
        NSMutableArray *friendTurnList = [[NSMutableArray alloc]init];
        
        //get game list my turn
        for(NSDictionary *dict in gameListMyturn) {
            
            MainTableViewCell *listItem = [[MainTableViewCell alloc]init];
            
            listItem.gameNo = (NSString*)dict[@"gameNo"];
            listItem.memberNo = (NSString*)dict[@"memberNo"];
            listItem.imageUrl = (NSString*)dict[@"imageUrl"];
            listItem.keyword = (NSString*)dict[@"keyword"];
            listItem.hint = (NSString*)dict[@"hint"];
            listItem.profileUrl = (NSString*)dict[@"profileUrl"];
            listItem.name = (NSString*)dict[@"name"];
            listItem.level = (NSString*)dict[@"level"];
            listItem.isSolved = (NSString*)dict[@"isSolved"];
            listItem.b_count = (NSString*)dict[@"b_count"];
            
            listItem.round = [NSString stringWithFormat:@"%@",(NSString*)dict[@"round"]];
            [myTurnList addObject:listItem];
        }
        [gameListArray addObject:myTurnList];
        
        //get game list friends turn
        for(NSDictionary *dict in gameListFriendsTurn) {
            
            MainTableViewCell *listItem = [[MainTableViewCell alloc]init];
            
            listItem.gameNo = (NSString*)dict[@"gameNo"];
            listItem.memberNo = (NSString*)dict[@"memberNo"];
            listItem.profileUrl = (NSString*)dict[@"profileUrl"];
            listItem.name = (NSString*)dict[@"name"];
            listItem.level = (NSString*)dict[@"level"];
            listItem.round = [NSString stringWithFormat:@"%@",(NSString*)dict[@"round"]];
            [friendTurnList addObject:listItem];
        }
        [gameListArray addObject:friendTurnList];
        
        [self setProfileImageFromURL:profileUrl];
        [self.myTableView reloadData];
    }
}

- (void)deleteOkProcess:(NSNotification *)notification{
    
    //do something..
    [SVProgressHUD dismiss];
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        
        [self.myTableView reloadData];
    }
}
- (void)setNavigationItem {
    
    CommonSharedObject *commonSharedObject = [CommonSharedObject sharedInstance];
    NSString *storyboardName = commonSharedObject.storyboardName;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboardName
                                                             bundle: nil];
    
    LeftViewController *leftMenu = (LeftViewController*)[mainStoryboard
                                                         instantiateViewControllerWithIdentifier: @"LeftViewController"];
    
    RightViewController *rightMenu = (RightViewController*)[mainStoryboard
                                                            instantiateViewControllerWithIdentifier: @"RightViewController"];
    
    [SlideNavigationController sharedInstance].rightMenu = rightMenu;
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    // Creating a custom bar button for right menu
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [buttonLeft addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    [SlideNavigationController sharedInstance].leftBarButtonItem = leftBarButtonItem;
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"friendslist"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    
    
}

- (IBAction)playWithFriend:(id)sender {
    
    
    [self performSegueWithIdentifier:@"SelectFriendSegue" sender:self];
}

- (IBAction)playRandom:(id)sender {
    
    playMode = RANDMODE;
    [self performSegueWithIdentifier:@"GuessViewSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        
        ProfileViewController *profileView = (ProfileViewController*)segue.destinationViewController;
        profileView.userStateInfo = self.userStateInfo;
        
    }
    else if([segue.identifier isEqualToString:@"GuessViewSegue"]) {
        
        GuessViewController *guessView = (GuessViewController*)segue.destinationViewController;
        guessView.gameItem = gameItem;
        guessView.currentMode = playMode;
    }
    
    else if([segue.identifier isEqualToString:@"SelectWordSegue"]) {
        
        SelectWordView *wordView = (SelectWordView*)segue.destinationViewController;
        
        int newRound = [gameItem.round intValue];
        newRound = newRound+1;
        NSMutableDictionary *gameInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         gameItem.memberNo, @"targetNumber",
                                         gameItem.gameNo,@"gameNumber",
                                         [NSString stringWithFormat:@"%d",newRound],@"round",
                                         nil];
        wordView.gameInfo = gameInfo;
    }
}
#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section>0) {
        NSMutableArray *tempArray = self.gameListArray[section-1];
        return [tempArray count];
    }
    else
        return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.gameListArray count]+1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-20, 30)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(25, 10, self.view.frame.size.width-50, 50)];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(25, 65, self.view.frame.size.width-50, 50)];
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width-25, 50)];
    UILabel *text2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width-25, 50)];
    
    headerLabel.textColor = [UIColor whiteColor];
    text.textAlignment = NSTextAlignmentCenter;
    text2.textAlignment = NSTextAlignmentCenter;
    
    [headerview addSubview:headerLabel];
    
    switch (section) {
        case 0 :
            text.text = @"몽키 대전";
            text.textColor = [UIColor whiteColor];
            text2.text = @"퍼즐 몽키";
            text2.textColor = [UIColor whiteColor];
            [button setImage:[UIImage imageNamed:@"gomonkey.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(playWithFriend:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setImage:[UIImage imageNamed:@"puzzlemode.png"] forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(playRandom:) forControlEvents:UIControlEventTouchUpInside];
            [headerview addSubview:button];
            [headerview addSubview:button2];
            [headerview addSubview:text];
            [headerview addSubview:text2];
            
            break;
        case 1:
            headerview.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:66.0/255.0 blue:96.0/255.0 alpha:1.0];
            headerLabel.text = @"내가 게임할 차례";

            break;
        case 2:
            headerview.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:178.0/255.0 blue:181.0/255.0 alpha:1.0];
            headerLabel.text = @"친구들이 게임할 차례";

            break;
        default:
            break;
    }
    
    return headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 124;
    else
        return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if(indexPath.section > 0) {
        NSMutableArray *tempArray = self.gameListArray[indexPath.section-1];
    
        MainTableViewCell *gList = [tempArray objectAtIndex:indexPath.row];
        UIImageView *profile = (UIImageView *)[cell viewWithTag:100];
        
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
                        UITableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        
                        if (updateCell) {
                            profile.image = image;
                        }
                    });
                }
            }
        });
        
        UILabel *name = (UILabel *)[cell viewWithTag:101];
        name.text = gList.name;
    
        UILabel *round = (UILabel *)[cell viewWithTag:102];
        round.text = gList.round;
    
        UILabel *level = (UILabel *)[cell viewWithTag:103];
        level.text = gList.level;
    
        profile.layer.cornerRadius = profile.frame.size.height /2;
        profile.layer.masksToBounds = YES;
        profile.layer.borderWidth = 0;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //select game from friend
    if(indexPath.section==1) {
        
        MainTableViewCell *gList = [[self.gameListArray objectAtIndex:0] objectAtIndex:indexPath.row];
        gameItem = gList;
        
        if([gameItem.isSolved intValue]==0) {
            playMode = PVPMODE;
            [self performSegueWithIdentifier:@"GuessViewSegue" sender:self];

        }
        else
            [self performSegueWithIdentifier:@"SelectWordSegue" sender:self];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        [SVProgressHUD setViewForExtension:self.view];
        [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
        [SVProgressHUD show];
        
        MainTableViewCell *gList = [[self.gameListArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        
        [networkController deleteGameItem:gList.gameNo ObserverName:OBSERVERNAME2];
        
        [[self.gameListArray objectAtIndex:indexPath.section-1] removeObjectAtIndex:indexPath.row];
    }
}

@end

