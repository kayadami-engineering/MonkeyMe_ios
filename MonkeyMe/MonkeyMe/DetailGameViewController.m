//
//  EditPhotoViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 26..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "DetailGameViewController.h"
#import "SharePopupViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "ReplyItemCell.h"
#import "NetworkController.h"
#import "ReplyCustomCell.h"
#import "ReplyViewController.h"
#define OBSERVERNAME @"getTopReply"
@interface DetailGameViewController() <SharePopupDelegate,WYPopoverControllerDelegate>

@end
@implementation DetailGameViewController
@synthesize popoverController;
@synthesize gameItem;
@synthesize userStateInfo;
@synthesize replyList;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGameInfo];
    [self setNavigationItem];
    [self registerNotification];
    
    NetworkController *networkController = [NetworkController sharedInstance];
    [networkController getReplyList:gameItem.g_no Count:3 Sort:-1 ObserverName:OBSERVERNAME];
    
}

- (void)setGameInfo {
    
    NSString *name = (NSString*)userStateInfo[@"name"];
    UIImage *image = (UIImage*)userStateInfo[@"profileImage"];
    
    [self.gameImage setImage:[[UIImage alloc]initWithData:gameItem.imageData]];
    
    //set profile image
    [self.profileImage setImage:image];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    self.name.text = name;
    self.replyCount.text = @"251";//[gameItem.replyCount stringValue];
    self.rate.text = gameItem.rate;
    self.playCount.text = @"2012";//[gameItem.playCount stringValue];
    
    self.navigationItem.title = gameItem.keyword;
}

- (void)setNavigationItem {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(getTopReplyProcess:) name:OBSERVERNAME object:nil];
    
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height*2-436);
    self.scrollView.scrollEnabled = TRUE;
}

- (void)getTopReplyProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        replyList = [[NSMutableArray alloc] init];
        
        NSMutableArray *list = (NSMutableArray*)dict[@"replyList"];
        
        // Get user profile info
        for(NSDictionary *replyItem in list) {
            ReplyItemCell *myItem = [[ReplyItemCell alloc]init];
            
            myItem.name = (NSString*)replyItem[@"name"];
            myItem.contents = (NSString*)replyItem[@"contents"];
            myItem.date = (NSString*)replyItem[@"date"];
            myItem.likeCount = (NSNumber*)replyItem[@"likeCount"];
            
            [replyList addObject:myItem];
        }
        
        [self.tableView reloadData];
        
    }
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SharePopupSegue"])
    {
        SharePopupViewController *sharePopupViewController = segue.destinationViewController;
        sharePopupViewController.delegate = self;
        
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionUp
                                                             animated:YES
                                                              options:WYPopoverAnimationOptionFadeWithScale
                                                                 mode:2];
        popoverController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"ReplyViewSegue"]) {
        
        ReplyViewController *replyViewController = segue.destinationViewController;
        replyViewController.g_no = gameItem.g_no;
    }
}

- (void)likeBtnClicked:(UIButton*)sender {
    
    NSLog(@"cliekc");
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"HelveticaNeue" size:16.0], NSFontAttributeName,
                                          nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:bodyText attributes:attributesDictionary];
    CGSize constraintSize = CGSizeMake(224, CGFLOAT_MAX);
    CGRect textRect = [string boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    //CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = textRect.size.height;
    return height;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [replyList count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"ReplyTableCell" owner:self options:nil];
    ReplyCustomCell *cell = nil;
    
    cell = [cellArray objectAtIndex:0];
    
    ReplyItemCell *replyItem = [replyList objectAtIndex:indexPath.row];
        
    UILabel *name = cell.name;
    UILabel *contents = cell.contents;
    UILabel *date = cell.date;
    UILabel *likeCount = cell.likeCount;
    UIButton *likebtn = cell.likeBtn;
    UIButton *optionBtn = cell.optionBtn;
        
    name.text = replyItem.name;
    contents.text = replyItem.contents;
    date.text = @"1일 전";
    likeCount.text = [NSString stringWithFormat:@"%@",replyItem.likeCount];
    contents.text = replyItem.contents;
        
    likebtn.tag = indexPath.row;
    [likebtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ReplyItemCell *replyItem = [replyList objectAtIndex:indexPath.row];
    return [self heightForText:replyItem.contents]+65;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

- (IBAction)showAllClick:(id)sender {
    [self performSegueWithIdentifier:@"ReplyViewSegue" sender:self];
}
@end
