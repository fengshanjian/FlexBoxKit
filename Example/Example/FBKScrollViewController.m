//
//  FBKScrollViewController.m
//  FlexBoxLayout_Example
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "FBKScrollViewController.h"
#import "FlexBoxKit.h"
@interface FBKScrollViewController ()

@end
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width   //主屏幕宽
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height  //主屏幕高
#define iPhoneX (MAIN_SCREEN_WIDTH == 375.f && MAIN_SCREEN_HEIGHT == 812.f ? YES : NO)
@implementation FBKScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *contentView = [UIScrollView new];
    contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(iPhoneX?83:49));
    [self.view addSubview:contentView];

    
    UIView *child1 = [UIView new];
    child1.backgroundColor = [UIColor blueColor];
    [child1 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 100;
        layout.kHeight = 100;
    }];
    
    UIView *child2 = [UIView new];
    child2.backgroundColor = [UIColor greenColor];
    [child2 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 100;
        layout.kHeight = 100;
    }];
    
    UILabel *child3 = [UILabel new];
    child3.numberOfLines = 0;
    child3.backgroundColor = [UIColor yellowColor];
    [child3 setAttributedText:[[NSAttributedString alloc] initWithString:@"testfdsfdsfdsfdsfdsfdsafdsafdsafasdkkk" attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:18]}]];
    child3.layout.isEnabled = YES;
    FBKDiv *div1 = [FBKDiv new];
    [div1 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.justifyContent = YGJustifySpaceBetween;
        layout.alignItems = YGAlignCenter;
        layout.kMarginTop = 20;
        layout.kWidth = 150;
    }];
    [div1 setChildren:@[child1,child2,child3]];
    
    
    UIView *child5 = [UIView new];
    child5.backgroundColor = [UIColor blueColor];
    [child5 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 50;
        layout.kMarginBottom = 10;
        layout.flexGrow = 1.0;
    }];
    
    UIView *child6 = [UIView new];
    child6.backgroundColor = [UIColor greenColor];
    [child6 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kMargin = 10;
        layout.kWidth = 50;
        layout.flexGrow = 2.0;
    }];

    
    
    UIView *child7 = [UIView new];
    child7.backgroundColor = [UIColor yellowColor];
    [child7 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kMarginBottom = 10;
        layout.kWidth = 50;
        layout.flexGrow = 1.0;
    }];
    
    UIView *child8 = [UIView new];
    child8.backgroundColor = [UIColor blackColor];
    
    [child8 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kMarginBottom = 10;
        layout.kWidth = 50;
        layout.flexGrow = 1.0;
    }];
    
    FBKDiv *div2 = [FBKDiv new];
    [div2 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.justifyContent = YGJustifySpaceAround;
        layout.alignItems = YGAlignCenter;
        layout.kMarginTop = 20;
        layout.kWidth = 50;
        layout.kHeight = 800;
    }];
    [div2 setChildren:@[child5,child6,child7,child8]];
    
    FBKDiv *root = [FBKDiv new];
    [root configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.flexDirection = YGFlexDirectionRow;
        layout.justifyContent = YGJustifySpaceAround;
        layout.alignItems = YGAlignCenter;
    }];
    [root setChildren:@[div1,div2]];
    contentView.contentDiv = root;
    [contentView.layout applyLayoutPreservingOrigin:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
