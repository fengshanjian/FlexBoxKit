//
//  FBKDiv.h
//  FlexBoxKit
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBKLayout.h"
#import "UIView+FBKit.h"
#import "FBKLayoutProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/**
 FBKDiv is virtual view, split view to a different area, avoid too much view.
 */
@interface FBKDiv : NSObject<FBKLayoutProtocol>

@property(nonatomic)CGRect frame;
/**
 The FBKLayout that is attached to this view. It is lazily created.
 */
@property (nonatomic, readonly, strong) FBKLayout *layout;
/**
 In ObjC land, every time you access `view.yoga.*` you are adding another `objc_msgSend`
 to your code. If you plan on making multiple changes to FBKLayout, it's more performant
 to use this method, which uses a single objc_msgSend call.
 */
- (void)configureLayout:(FBKLayoutConfigurationBlock)block;

@property (nonatomic, weak) UIView *parentView;

@end

NS_ASSUME_NONNULL_END
