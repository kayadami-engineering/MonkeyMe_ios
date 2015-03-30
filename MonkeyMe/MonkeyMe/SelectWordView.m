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


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItem];
    [self setWordItem];
}

- (void)setNavigationItem {
    
    UIButton *buttonLeft  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)setWordItem {
    
    wordItemList = [[NSMutableArray alloc] init];
    
    WordItemCell *easy = [[WordItemCell alloc]init];
    easy.difficulty = @"쉬움";
    easy.keyword = @"코";
    easy.b_count = @"1";
    
    WordItemCell *medium = [[WordItemCell alloc]init];
    medium.difficulty = @"보통";
    medium.keyword = @"고양이";
    medium.b_count = @"2";
    
    WordItemCell *hard = [[WordItemCell alloc]init];
    hard.difficulty = @"어려움";
    hard.keyword = @"외계인";
    hard.b_count = @"3";
    
    WordItemCell *crazy = [[WordItemCell alloc]init];
    crazy.difficulty = @"지옥";
    crazy.keyword = @"해바라기씨";
    crazy.b_count = @"4";
    
    [wordItemList addObject:easy];
    [wordItemList addObject:medium];
    [wordItemList addObject:hard];
    [wordItemList addObject:crazy];
    
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
