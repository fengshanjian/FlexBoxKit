//
//  UIView+FBKit.h
//  FlexBoxKit
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "FBKLayout.h"
#import <UIKit/UIKit.h>
#import "FBKLayoutProtocol.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^FBKLayoutConfigurationBlock)(FBKLayout *layout);

@interface UIView (FBKit)<FBKLayoutProtocol>


@property(nonatomic) BOOL fb_drawsAsynchronously;

/**
 Indicates whether or not Yoga is enabled
 */
@property (nonatomic, readonly, assign) BOOL isYogaEnabled;



/**
 In ObjC land, every time you access `view.yoga.*` you are adding another `objc_msgSend`
 to your code. If you plan on making multiple changes to FBKLayout, it's more performant
 to use this method, which uses a single objc_msgSend call.
 */
- (void)configureLayout:(FBKLayoutConfigurationBlock)block;



@end
NS_ASSUME_NONNULL_END
