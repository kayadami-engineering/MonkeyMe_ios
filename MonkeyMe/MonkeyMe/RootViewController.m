//
//  ViewController.m
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 6..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import "RootViewController.h"
#import "SVProgressHUD.h"

@implementation RootViewController
@synthesize networkController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialSetup {
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:120.0/255.0 green:194.0/255.0 blue:222.0/255.0 alpha:0.90]];
    [SVProgressHUD show];
    [self performSelector:@selector(myTask)withObject:nil afterDelay:2.0];
    
    networkController = [[NetworkController alloc]init];
    [networkController initNetwork];
    [networkController postToServer:[NSString stringWithFormat:@"command=%@", @"BookList"]];
    
    
}
- (void)myTask {
    
    //do something..
    [SVProgressHUD dismiss];
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
@end
