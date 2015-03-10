//
//  RIghtViewController.m
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 7..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "RightViewController.h"

@implementation RightViewController

@synthesize headerSearch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightMenu.jpg"]];
    self.tableView.backgroundView = imageView;
    
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

#pragma mark - UITableView Delegate & Datasrouce -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(70, 20, self.view.frame.size.width-70, 40)];
    headerSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 20, self.view.frame.size.width-80, 35)];
    headerSearch.delegate = self;
    headerSearch.backgroundColor = [UIColor whiteColor];
    headerSearch.backgroundImage = [[UIImage alloc] init];
    headerSearch.placeholder = @"Search";
    headerSearch.layer.cornerRadius = 5;
    headerSearch.clipsToBounds = YES;
    [headerview addSubview:headerSearch];
    
    return headerview;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell"];
    UIImageView *profile = (UIImageView *)[cell viewWithTag:100];
    profile.image = [UIImage imageNamed:@"ky"];
    
    UILabel *name = (UILabel *)[cell viewWithTag:101];
    
    switch (indexPath.row)
    {
        case 0:
            name.text = @"Kaya lee";
            break;
            
        case 1:
            name.text = @"sy";
            break;
            
        case 2:
            name.text = @"kj";
            break;
            
        case 3:
            name.text = @"qwe";
            break;
            
        case 4:
            name.text = @"123";
            break;
            
        case 5:
            name.text = @"asd";
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    profile.layer.cornerRadius = profile.frame.size.height /2;
    profile.layer.masksToBounds = YES;
    profile.layer.borderWidth = 0;
    
    return cell;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <SlideNavigationContorllerAnimator> revealAnimator;
    
    switch (indexPath.row)
    {
        case 0:
            revealAnimator = nil;
            break;
            
        case 1:
            revealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] init];
            break;
            
        case 2:
            revealAnimator = [[SlideNavigationContorllerAnimatorFade alloc] init];
            break;
            
        case 3:
            revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
            break;
            
        case 4:
            revealAnimator = [[SlideNavigationContorllerAnimatorScale alloc] init];
            break;
            
        case 5:
            revealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blackColor] andMinimumScale:.8];
            break;
            
        default:
            return;
    }
    
    [self hideKeyboard];
    
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        [SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
    }];
}
@end
