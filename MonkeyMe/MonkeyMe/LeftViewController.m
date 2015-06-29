//
//  LeftViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 7..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "LeftViewController.h"
#import "CommonSharedObject.h"
#import "KeychainItemWrapper.h"

@implementation LeftViewController

#pragma mark - UIViewController Methods -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
    //self.tableView.backgroundView = imageView;
    self.tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:143/255.0 blue:158.0/255.0 alpha:1.0f];
    NSLog(@"Left view load");
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
    
    UIImageView *image = (UIImageView *)[cell viewWithTag:100];
    UILabel *text = (UILabel *)[cell viewWithTag:101];
    
    switch (indexPath.row)
    {
        case 0:
            text.text = @"Home";
            image.image = [UIImage imageNamed:@"shop"];
            break;
            
        case 1:
            text.text = @"Inbox";
            image.image = [UIImage imageNamed:@"inbox"];
            break;
            
        case 2:
            text.text = @"Ranking";
            image.image = [UIImage imageNamed:@"ranking"];
            break;
            
        case 3:
            text.text = @"Add your monkey";
            image.image = [UIImage imageNamed:@"word"];
            break;
        case 4 :
            text.text = @"Shop";
            image.image = [UIImage imageNamed:@"shop"];
            break;
        case 5 :
            text.text = @"Settings";
            image.image = [UIImage imageNamed:@"settings"];
            break;
        case 6 :
            text.text = @"Help";
            image.image = [UIImage imageNamed:@"help"];
            break;
        case 7 :
            text.text = @"Logout";
            image.image = [UIImage imageNamed:@"help"];
            KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"monkeymeLogin" accessGroup:nil];
            [wrapper resetKeychainItem];
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonSharedObject *commonSharedObject = [CommonSharedObject sharedInstance];
    NSString *storyboardName = commonSharedObject.storyboardName;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboardName
                                                             bundle: nil];
    UIViewController *vc ;
    
    switch (indexPath.row)
    {

        case 1:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainViewController"];
            break;
            
        case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainViewController"];
            break;
            
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
}


@end
