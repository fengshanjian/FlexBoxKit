//
//  FBKViewController.m
//  FlexBoxLayout
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "FBKViewController.h"

#import "FlexBoxKit.h"
@interface FBKViewController ()

@end

@implementation FBKViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIView *root = self.view;
    [root configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.width = YGPointValue(self.view.bounds.size.width);
        layout.height = YGPointValue(self.view.bounds.size.height);
        layout.justifyContent = YGJustifyFlexStart;
        layout.alignItems = YGAlignCenter;
    }];
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor greenColor];
    [view1 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 100;
        layout.kHeight = 100;
    }];
    [root addChild:view1];
    
    
    FBKDiv *div = [FBKDiv new];
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor blueColor];
    [view2 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 100;
        layout.kHeight = 100;
    }];
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor yellowColor];
    [view3 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 100;
        layout.kHeight = 100;
    }];
    
    FBKDiv *div1 = [FBKDiv new];
    [div1 addChild:view2];
    [div1 addChild:view3];
    [div1 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 100;
        layout.kHeight = 200;
    }];

    [div configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 100;
        layout.kHeight = 300;
        layout.kMarginTop = 20;
    }];
    [div addChild:div1];
    UIView *view4 = [UIView new];
    [view4 configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kWidth = 100;
        layout.kHeight = 100;
    }];
    view4.backgroundColor = [UIColor redColor];
    [div addChild:view4];
    

    [root addChild:div];
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16];
    [label configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kMargin = 10;
    }];
    label.text = @"2234";
    label.numberOfLines = 0;
    [view2 addChild:label];
    
    [root.layout applyLayoutPreservingOrigin:NO];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [div removeChild:view4];
        label.text=@"223444444444";
        [label.layout markDirty];
        [div.layout applyLayoutPreservingOrigin:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *view5 = [UIView new];
        view5.backgroundColor = [UIColor orangeColor];
        //绝对布局
        [view5 configureLayout:^(FBKLayout * _Nonnull layout) {
            layout.position = YGPositionTypeAbsolute;
            layout.kLeft = 10;
            layout.kTop = 64;
            layout.kWidth = 100;
            layout.kHeight = 100;
        }];
        [root addChild:view5];
        [root.layout applyLayoutPreservingOrigin:NO];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [root removeChild:view1];
        [root.layout applyLayoutPreservingOrigin:NO];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5f animations:^{
            [view3 configureLayout:^(FBKLayout * _Nonnull layout) {
                layout.kHeight = 50;
            }];
            [root.layout applyLayoutPreservingOrigin:NO];
        } completion:^(BOOL finished) {
           
        }];
    });
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
