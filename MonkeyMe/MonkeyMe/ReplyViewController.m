//
//  ReplyViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 4. 10..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "ReplyViewController.h"
#import "ReplyItemCell.h"
#import "ReplyCustomCell.h"
#import "WYStoryboardPopoverSegue.h"
#import "SortViewPopupController.h"
#import "SVProgressHUD.h"
#import "ProfileViewController.h"

#define OBSERVERNAME1 @"replyListProcess"
#define OBSERVERNAME2 @"sendReplyProcess"

#define RECENT  0
#define POPULAR 1
#define MAXREPLYLEN 40

@interface ReplyViewController () <SortPopupDelegate,WYPopoverControllerDelegate> {}
@end
@implementation ReplyViewController
@synthesize replyList;
@synthesize popoverController;
@synthesize networkController;
@synthesize g_no;
@synthesize keyboardHeight;
@synthesize userStateInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItemLeft];
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.tableView.frame];
    [control setBackgroundColor:[UIColor clearColor]];
    [control addTarget:self action:@selector(keyboardHide) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setBackgroundView:control];
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    
    networkController = [NetworkController sharedInstance];
    
    [networkController getReplyList:g_no Count:0 Sort:RECENT ObserverName:OBSERVERNAME1];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotification];
    [self registKeyboardNotification];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregistKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavigationItemLeft {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)back {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark KEYBOARD settings
- (void)registKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void) unregistKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];
    keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self setViewMovedUp:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    [self setViewMovedUp:NO];
}

- (void)keyboardHide {
    [self.view endEditing:YES];
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp && self.view.frame.origin.y >=0)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        
        rect.origin.y -= keyboardHeight.height;
        rect.size.height += keyboardHeight.height;
    }
    else if(!movedUp && self.view.frame.origin.y <0)
    {
        // revert back to the normal state.
        rect.origin.y += keyboardHeight.height;
        rect.size.height -= keyboardHeight.height;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark Network Observer Process
- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(replyListProcess:) name:OBSERVERNAME1 object:nil];
    [sendNotification addObserver:self selector:@selector(sendReplyProcess:) name:OBSERVERNAME2 object:nil];
    
}

- (void)replyListProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..
    [SVProgressHUD dismiss];
    NSLog(@"receive ok");
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
            
            myItem.memberNo = (NSString*)replyItem[@"memberNo"];
            myItem.memberID = (NSString*)replyItem[@"memberID"];
            myItem.r_no = (NSString*)replyItem[@"r_no"];
            myItem.profileUrl = (NSString*)replyItem[@"profileUrl"];
            myItem.name = (NSString*)replyItem[@"name"];
            myItem.contents = (NSString*)replyItem[@"contents"];
            myItem.date = (NSString*)replyItem[@"date"];
            myItem.likeCount = (NSNumber*)replyItem[@"likeCount"];
            myItem.friendCount = (NSNumber*)replyItem[@"friendCount"];
            myItem.level = (NSString*)replyItem[@"level"];
            
            [replyList addObject:myItem];
        }

        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    
}


- (void)sendReplyProcess:(NSNotification *)notification { //network notify the result of update request
    
    //do something..
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
        [SVProgressHUD dismiss];
    }
    else {
        [self performSelector:@selector(getReplyListAgain) withObject:nil afterDelay:0.5];
    }
}

- (void)getReplyListAgain {
    self.replyText.text = @"";
    [networkController getReplyList:g_no Count:0 Sort:RECENT ObserverName:OBSERVERNAME1];
}

- (IBAction)okBtn:(id)sender {
    
    if([self checkLength]) {
        [self keyboardHide];
    
        [SVProgressHUD setViewForExtension:self.view];
        [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
        [SVProgressHUD show];
    
        [networkController sendReply:g_no Contents:self.replyText.text ObserverName:OBSERVERNAME2];
    }
    
}

- (BOOL)checkLength {
    
    UIAlertView *alert;
    if(self.replyText.text.length > MAXREPLYLEN) {
        alert = [[UIAlertView alloc]initWithTitle:@"길이초과" message:@"댓글은 40글자를 넘을 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil];
        [alert show];
        return FALSE;
    }
    else {
        return TRUE;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"sortPopoverSegue"])
    {
        SortViewPopupController *sortViewPopupController = segue.destinationViewController;
        sortViewPopupController.delegate = self;
        
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionUp
                                                             animated:YES
                                                              options:WYPopoverAnimationOptionFadeWithScale
                                                                 mode:3];
        popoverController.delegate = self;
    }
    
    else if([segue.identifier isEqualToString:@"OthersProfileSegue"]) {
        
        ProfileViewController *profileView = (ProfileViewController*)segue.destinationViewController;
        profileView.userStateInfo = self.userStateInfo;
    }
}

- (void)likeBtnClicked:(UIButton*)sender {
    
}
- (void)nameBtnClicked:(UIButton*)sender {
    
    ReplyItemCell *myItem = [replyList objectAtIndex:sender.tag];
    
    userStateInfo = [[NSMutableDictionary alloc]init];;
    
    NSURL *url = [NSURL URLWithString:myItem.profileUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc]initWithData:data];
    
    [userStateInfo setValue:myItem.memberNo forKey:@"friendNumber"];
    [userStateInfo setValue:myItem.memberID forKey:@"memberID"];
    [userStateInfo setValue:myItem.name forKey:@"name"];
    [userStateInfo setValue:myItem.level forKey:@"level"];
    [userStateInfo setValue:image forKey:@"profileImage"];
    [userStateInfo setValue:myItem.friendCount forKey:@"friendCount"];
    
    [self performSegueWithIdentifier:@"OthersProfileSegue" sender:self];
    
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
    UIButton *nameBtn = cell.nameBtn;
    //UIButton *optionBtn = cell.optionBtn;
    
    name.text = replyItem.name;
    contents.text = replyItem.contents;
    date.text = @"1일 전";
    likeCount.text = [NSString stringWithFormat:@"%@",replyItem.likeCount];
    contents.text = replyItem.contents;
        
    likebtn.tag = indexPath.row;
    [likebtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    nameBtn.tag = indexPath.row;
    [nameBtn addTarget:self action:@selector(nameBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self keyboardHide];
}


@end
