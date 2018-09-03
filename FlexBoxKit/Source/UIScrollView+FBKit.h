//
//  UIScrollView+FBKit.h
//  FlexBoxKit
//
//  Created by will on 2018/9/3.
//  Copyright © 2018年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBKDiv.h"

@interface UIScrollView (FBKit)

/**
 ScrollView layout div make contentSize  auto size
 contentSize自动计算
 */

@property(nonatomic, strong) FBKDiv *contentDiv;


/**
 remove layout
 */
- (void)clearLayout;
@end
