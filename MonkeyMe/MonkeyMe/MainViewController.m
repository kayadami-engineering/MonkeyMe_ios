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

@implementation MainViewController
@synthesize tableView;
@synthesize scrollView;
@synthesize gameListArray;
@synthesize profileImage;


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self setNavigationItem];
    [self setGameList];
    
    [self.profileImage setImage:[UIImage imageNamed:@"ky"]];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    
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
    
    /*
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Closed %@", menu);
     }];
     
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Opened %@", menu);
     }];
     
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Revealed %@", menu);
     }];
     */
}
- (void)setGameList {
    
    gameListArray = [[NSMutableArray alloc]init];
    NSMutableArray *newTempList = [[NSMutableArray alloc]init];
    NSMutableArray *newTempList2 = [[NSMutableArray alloc]init];
    
    MainTableViewCell *ky = [[MainTableViewCell alloc]init];
    
    ky.imageName = @"ky.png";
    ky.name = @"Kaya";
    ky.level = @"5";
    ky.roundName = @"Round 5";
    
    MainTableViewCell *yong = [[MainTableViewCell alloc]init];
    
    yong.imageName = @"yong.jpg";
    yong.name = @"Developer of Majesty";
    yong.level = @"6";
    yong.roundName = @"Round 4";
    
    MainTableViewCell *medic = [[MainTableViewCell alloc]init];
    
    medic.imageName = @"medic.jpg";
    medic.name = @"Medic";
    medic.level = @"2";
    medic.roundName = @"Round 4";
    
    MainTableViewCell *chole = [[MainTableViewCell alloc]init];
    
    chole.imageName = @"chole.jpg";
    chole.name = @"Chole Moretz";
    chole.level = @"15";
    chole.roundName = @"Round 7";
    
    [newTempList addObject:ky];
    [newTempList addObject:yong];
    [newTempList addObject:medic];
    [newTempList addObject:chole];
    [newTempList addObject:ky];
    [newTempList addObject:yong];
    [newTempList addObject:medic];
    [newTempList addObject:chole];
    
    [newTempList2 addObject:ky];
    [newTempList2 addObject:yong];
    [newTempList2 addObject:medic];
    [newTempList2 addObject:chole];
    [newTempList2 addObject:ky];
    [newTempList2 addObject:yong];
    [newTempList2 addObject:medic];
    [newTempList2 addObject:chole];
    
    [gameListArray addObject:newTempList];
    [gameListArray addObject:newTempList2];
    
    
}

- (IBAction)playWithFriend:(id)sender {
    
    [self performSegueWithIdentifier:@"SelectFriendSegue" sender:self];
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
        profile.image = [UIImage imageNamed:gList.imageName];
    
        UILabel *name = (UILabel *)[cell viewWithTag:101];
        name.text = gList.name;
    
        UILabel *round = (UILabel *)[cell viewWithTag:102];
        round.text = gList.roundName;
    
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
    if(indexPath.section==1)
        [self performSegueWithIdentifier:@"GuessViewSegue" sender:self];
}


@end

