//
//  RIghtViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 7..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "RightViewController.h"
#import "MainTableViewCell.h"
#import "ProfileViewController.h"
#define OBSERVERNAME_1 @"m_friendListProcess"
#define OBSERVERNAME_2 @"f_friendListProcess"

@implementation RightViewController

@synthesize headerSearch;
@synthesize collapsedSections;
@synthesize monkeyFriendList;
@synthesize facebookFriendList;
@synthesize networkController;
@synthesize blockUpdate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightMenu.jpg"]];
    self.tableView.backgroundView = imageView;
    
    collapsedSections = [NSMutableSet new];
    
    networkController = [NetworkController sharedInstance];
    monkeyFriendList = [[NSMutableArray alloc] init];
    facebookFriendList = [[NSMutableArray alloc] init];
    
    self.blockUpdate = false;
    [self registerNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(monkeyFriendListUpdate:) name:OBSERVERNAME_1 object:nil];
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
        
        NSMutableArray *friendList = (NSMutableArray*)dict[@"friendList"];
        
        for(int i=0;i<[friendList count];i++) {
            dict = [friendList objectAtIndex:i];
            
            MainTableViewCell *listItem = [[MainTableViewCell alloc]init];
            
            listItem.memberNo = (NSString*)dict[@"memberNo"];
            listItem.profileUrl = (NSString*)dict[@"profileUrl"];
            listItem.name = (NSString*)dict[@"name"];
            listItem.memberID = (NSString*)dict[@"memberID"];
            listItem.level = (NSString*)dict[@"level"];
            listItem.friendCount = (NSNumber*)dict[@"friendCount"];
            [monkeyFriendList addObject:listItem];
        }
        
        [self.tableView beginUpdates];
        int numOfRows = [monkeyFriendList count];
        
        if(numOfRows!=0) {
            NSArray* indexPaths = [self indexPathsForSection:2 withNumberOfRows:numOfRows];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [collapsedSections addObject:@(2)];
        }
        [self.tableView endUpdates];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // add self
    [self hideKeyboard];
}

-(void)hideKeyboard {
    
    if(self.headerSearch)
        [self.headerSearch resignFirstResponder];
}

-(void)sectionButtonTouchUpInside:(UIButton*)sender {

    [self.tableView beginUpdates];
    int section = sender.tag;
    bool shouldCollapse = [collapsedSections containsObject:@(section)];
    
    if (shouldCollapse) {
        int numOfRows = [self.tableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [collapsedSections removeObject:@(section)];
    }
    else {
        
        if(!blockUpdate) { //first update
            
            if(section==1) { //facebook friend
                
            }
            else if(section==2) { //monkey me friend
                
                [self.networkController getMonkeyFriendList:OBSERVERNAME_1];
            }
            blockUpdate = true;
        }
        else { //already update!
            int numOfRows;
            
            if(section==1) {
                numOfRows = [facebookFriendList count];
            }
            else if(section==2) {
                numOfRows = [monkeyFriendList count];
            }
            
            if(numOfRows!=0) {
                NSArray* indexPaths = [self indexPathsForSection:2 withNumberOfRows:numOfRows];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [collapsedSections addObject:@(section)];
            }
        }
    }
    
    [self.tableView endUpdates];
    //[_tableView reloadData];
}

-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows {
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

#pragma mark - UITableView Delegate & Datasrouce -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview;
    
    if(section==0) {
        headerview = [[UIView alloc] initWithFrame:CGRectMake(60, 20, self.view.frame.size.width-60, 40)];
        
        headerSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 20, self.view.frame.size.width-80, 35)];
        headerSearch.delegate = self;
        headerSearch.backgroundColor = [UIColor whiteColor];
        headerSearch.backgroundImage = [[UIImage alloc] init];
        headerSearch.placeholder = @"Search";
        headerSearch.layer.cornerRadius = 5;
        headerSearch.clipsToBounds = YES;
        [headerview addSubview:headerSearch];
    
    }
    else {
        headerview = [[UIView alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-60, 50)];
        //UIButton* result = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *result = [[UIButton alloc]initWithFrame:CGRectMake(60,0,self.view.frame.size.width-60, 50)];
        
        [result addTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        result.backgroundColor = [UIColor colorWithRed:23.0/255.0 green:165.0/255.0 blue:184.0/255.0 alpha:1.0];
        NSString *temp = section==1 ? @"페이스북 친구" : @"서로 이웃 몽키";
        [result setTitle:temp forState:UIControlStateNormal];
        result.tag = section;
        [headerview addSubview:result];
        
    }
    return headerview;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 || ![collapsedSections containsObject:@(section)])
        return 0;
    
    else {
        
        if(section==1)
            return [facebookFriendList count];
        else
            return [monkeyFriendList count];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section>0 ? 50 : 60;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell"];

    UIImageView *profile = (UIImageView *)[cell viewWithTag:100];
    UILabel *name = (UILabel *)[cell viewWithTag:101];
    
    NSMutableArray *tempArray;
    
    if(indexPath.section==1)
        tempArray = facebookFriendList;
    else
        tempArray = monkeyFriendList;
    
    MainTableViewCell *gList = [tempArray objectAtIndex:indexPath.row];
    
    name.text = gList.name;
    
    if(!gList.imageData) { //first update
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
    }
    else { //already updated
        UIImage *image = [[UIImage alloc]initWithData:gList.imageData];
        profile.image = image;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    profile.layer.cornerRadius = profile.frame.size.height /2;
    profile.layer.masksToBounds = YES;
    profile.layer.borderWidth = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self hideKeyboard];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    NSMutableArray *tempArray;
    
    if(indexPath.section==1)
        tempArray = facebookFriendList;
    else
        tempArray = monkeyFriendList;
    
    MainTableViewCell *gList = [tempArray objectAtIndex:indexPath.row];
    NSMutableDictionary *userStateInfo = [[NSMutableDictionary alloc]init];;
    
    UIImage *image = [[UIImage alloc]initWithData:gList.imageData];
   
    [userStateInfo setValue:gList.memberNo forKey:@"friendNumber"];
    [userStateInfo setValue:gList.memberID forKey:@"memberID"];
    [userStateInfo setValue:gList.name forKey:@"name"];
    [userStateInfo setValue:gList.level forKey:@"level"];
    [userStateInfo setValue:image forKey:@"profileImage"];
    [userStateInfo setValue:gList.friendCount forKey:@"friendCount"];
    
    ProfileViewController *vc ;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
    vc.userStateInfo = userStateInfo;
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
    
}
@end
