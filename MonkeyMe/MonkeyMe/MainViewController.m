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

#define OBSERVERNAME @"updateMainProcess"

@implementation MainViewController
@synthesize myTableView;
@synthesize scrollView;
@synthesize gameListArray;
@synthesize profileImage;
@synthesize networkController;
@synthesize userStateInfo;
@synthesize gameItem;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItem];
    [self registerNotification];
    networkController = [NetworkController sharedInstance];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [networkController updateMainRequest:OBSERVERNAME];
    
}
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setProfileImageFromURL:(NSString*)profileUrl {
    
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
- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(updateProcess:) name:OBSERVERNAME object:nil];

}

- (void)updateProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..

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

- (void)setNavigationItem {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        
        ProfileViewController *profileView = (ProfileViewController*)segue.destinationViewController;
        profileView.userStateInfo = self.userStateInfo;
        
    }
    else if([segue.identifier isEqualToString:@"GuessViewSegue"]) {
        
        GuessViewController *guessView = (GuessViewController*)segue.destinationViewController;
        guessView.gameItem = gameItem;
        
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
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(122, 5, self.view.frame.size.width-122, 50)];
    UILabel *text2 = [[UILabel alloc] initWithFrame:CGRectMake(122, 60, self.view.frame.size.width-122, 50)];
    
    headerLabel.textColor = [UIColor whiteColor];
    
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
            
            NSURL *url = [NSURL URLWithString:gList.profileUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            gList.imageData = data;
            
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
        [self performSegueWithIdentifier:@"GuessViewSegue" sender:self];
    }
}


@end

