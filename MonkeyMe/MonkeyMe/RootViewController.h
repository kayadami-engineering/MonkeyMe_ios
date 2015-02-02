//
//  ViewController.h
//  happinuss_ios
//
//  Created by Imac on 2015. 1. 6..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkController.h"

@interface RootViewController : UIViewController {

    NetworkController *networkController;
    
}
-(void) myTask;
-(void) initialSetup;

@property (strong, nonatomic)NetworkController *networkController;


@end

