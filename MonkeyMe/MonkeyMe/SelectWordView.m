//
//  SelectWordView.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 20..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "SelectWordView.h"

@implementation SelectWordView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationItem];
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
    UILabel *title = (UILabel *)[cell viewWithTag:101];
    
    switch(indexPath.row) {
        case 0 :
            difficulty.text = @"쉬움";
            title.text = @"코";
            break;
        case 1 :
            difficulty.text = @"보통";
            title.text = @"고양이";
            break;
        case 2 :
            difficulty.text = @"어려움";
            title.text = @"외계인";
            break;
        case 3 :
            difficulty.text = @"지옥";
            title.text = @"해바라기씨";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"HintSegue" sender:self];
}
@end
