//
//  UIView+FBKCell.m
//  FlexBoxKit
//
//  Created by will on 2018/9/3.
//  Copyright © 2018年 will. All rights reserved.
//

#import "UIView+FBKCell.h"
#import "UIView+FBKit.h"
#import <objc/runtime.h>

@implementation UIView (FBKCell)

- (void)setFb_selectionStyle:(UITableViewCellSelectionStyle)fb_selectionStyle {
    objc_setAssociatedObject(self, _cmd, @(fb_selectionStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewCellSelectionStyle)fb_selectionStyle {
    return [objc_getAssociatedObject(self, @selector(setFb_selectionStyle:)) integerValue];;
}

@end
