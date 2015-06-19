//
//  MainTableViewCell.h
//  MonkeyMe
//
//  Created by Imac on 2015. 2. 10..
//  Copyright (c) 2015년 kayadami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameItemObject.h"

@interface MainTableViewCell : GameItemObject {

    NSString *round;
    NSString *b_count;
    NSString *isSolved;
    NSNumber *friendCount;
    
}
@property (copy, nonatomic) NSString *round;
@property (copy, nonatomic) NSString *b_count;
@property (copy, nonatomic) NSString *isSolved;
@property (copy, nonatomic) NSNumber *friendCount;


@end
