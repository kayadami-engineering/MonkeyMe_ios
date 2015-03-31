//
//  SelectWordView.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "SelectWordView.h"
#import "HintVIewController.h"

@implementation SelectWordView
@synthesize targetNumber;
@synthesize wordItemList;
@synthesize selectedItem;
@synthesize networkController;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItem];
    [self registerNotification];
    networkController = [NetworkController sharedInstance];
    [networkController getWordList];
    
}
- (void)registerNotification {
    
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    [sendNotification addObserver:self selector:@selector(getWordlistProcess:) name:@"getWordlistProcess" object:nil];
    
}
- (void)getWordlistProcess:(NSNotification*)notification {
    
    NSDictionary* dict = notification.userInfo;
    
    NSString *result = (NSString*)dict[@"result"];
    NSString *message = (NSString*)dict[@"message"];
    
    if([result isEqualToString:@"error"]) { // if update failed
        
        //show pop up
        
        NSLog(@"Error Message=%@",message);
    }
    else {
        wordItemList = [[NSMutableArray alloc] init];
        
        NSMutableArray *wordList = (NSMutableArray*)dict[@"wordList"];

        // Get user profile info
        for(NSDictionary *wordDict in wordList) {
            WordItemCell *item = [[WordItemCell alloc]init];
            NSNumber *level = (NSNumber*)wordDict[@"level"];
            
            switch ([level intValue]) {
                case 0:
                    item.difficulty = @"쉬움";
                    break;
                case 1:
                    item.difficulty = @"보통";
                    break;
                case 2:
                    item.difficulty = @"어려움";
                    break;
                case 3:
                    item.difficulty = @"지옥";
                    break;
                    
                default:
                    break;
            }
            item.keyword = (NSString*)wordDict[@"keyword"];
            item.b_count = (NSString*)[NSString stringWithFormat:@"%@",level];
            
            [wordItemList addObject:item];
        }
        
        [self.tableView reloadData];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"HintSegue"]) {
        
        HintVIewController *hintView = (HintVIewController*)segue.destinationViewController;
        hintView.targetNumber = targetNumber;
        hintView.wordItem = selectedItem;
    }
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UILabel *difficulty = (UILabel *)[cell viewWithTag:100];
    UILabel *keyword = (UILabel *)[cell viewWithTag:101];
    
    WordItemCell *wordItemCell = [wordItemList objectAtIndex:indexPath.row];
    
    difficulty.text = wordItemCell.difficulty;
    keyword.text = wordItemCell.keyword;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordItemCell *wordItemCell = [wordItemList objectAtIndex:indexPath.row];
    selectedItem = wordItemCell;
    
    [self performSegueWithIdentifier:@"HintSegue" sender:self];
}
@end
