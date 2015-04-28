//
//  PuzzelRightViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 14..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "PuzzelRightViewController.h"
#import "ReplyCustomCell.h"
#import "ReplyItemCell.h"
#import "NetworkController.h"

#define OBSERVERNAME @"getTopReply"

@implementation PuzzelRightViewController
@synthesize replyList;
@synthesize percent;
@synthesize gameItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.expBar setTransform:CGAffineTransformMakeScale(1.0, 12.0)];
    percent = 33;
    CGFloat curPercent = (CGFloat)self.percent/100;
    [self.expBar setProgress:curPercent];
    
    //set profile image
    [self.profile setImage:[[UIImage alloc]initWithData:gameItem.imageData]];
    self.profile.layer.cornerRadius = self.profile.frame.size.height /2;
    self.profile.layer.masksToBounds = YES;
    self.profile.layer.borderWidth = 0;
    
    self.name.text = gameItem.name;
    [self registerNotification];
    
    NetworkController *networkController = [NetworkController sharedInstance];
    [networkController getReplyList:gameItem.gameNo Count:3 Sort:-1 ObserverName:OBSERVERNAME];
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height*2);
    self.scrollView.scrollEnabled = TRUE;
}

- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(getTopReplyProcess:) name:OBSERVERNAME object:nil];
}

- (IBAction)showAllClick:(id)sender {
}
- (IBAction)nextGame:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
