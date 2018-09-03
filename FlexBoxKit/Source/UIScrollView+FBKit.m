//
//  UIScrollView+FBKit.m
//  FlexBoxKit
//
//  Created by will on 2018/9/3.
//  Copyright © 2018年 will. All rights reserved.
//

#import "UIScrollView+FBKit.h"
#import <objc/runtime.h>

@implementation UIScrollView (FBKit)


+ (void)load {
    SEL originalSelector = @selector(layoutSubviews);
    SEL swizzledSelector = NSSelectorFromString([@"fb_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (FBKDiv *)contentDiv {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setContentDiv:(FBKDiv *)fb_contentDiv {
    FBKDiv *contentDiv = [self contentDiv];
    if (contentDiv != fb_contentDiv) {
        objc_setAssociatedObject(self, @selector(contentDiv), fb_contentDiv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)clearLayout {
    [self setContentDiv:nil];
}

- (void)fb_layoutSubviews {
    [self fb_layoutSubviews];
    FBKDiv *contentDiv = [self contentDiv];
    if (contentDiv) {
        self.contentSize = (CGSize){
            .width = contentDiv.frame.size.width > self.frame.size.width ? contentDiv.frame.size.width : self.frame.size.width,
            .height = contentDiv.frame.size.height > self.frame.size.height ? contentDiv.frame.size.height: self.frame.size.height,
        };
    }
}

@end
