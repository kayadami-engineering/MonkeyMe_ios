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
@synthesize collapsedSections;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightMenu.jpg"]];
    self.tableView.backgroundView = imageView;
    
    collapsedSections = [NSMutableSet new];
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
        int numOfRows = 6;
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [collapsedSections addObject:@(section)];
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
        headerview = [[UIView alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-60, 40)];
        //UIButton* result = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *result = [[UIButton alloc]initWithFrame:CGRectMake(60,0,self.view.frame.size.width-60, 40)];
        
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
    if(section == 0)
        return 0;
    return ![collapsedSections containsObject:@(section)] ? 0 : 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section>0 ? 40 : 60;

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
