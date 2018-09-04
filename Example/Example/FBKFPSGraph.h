//
//  FBKFPSGraph.h
//  FlexBoxLayout
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBKFPSGraph : UIView

@property (nonatomic, assign, readonly) NSUInteger FPS;
@property (nonatomic, assign, readonly) NSUInteger maxFPS;
@property (nonatomic, assign, readonly) NSUInteger minFPS;

- (instancetype)initWithFrame:(CGRect)frame
                        color:(UIColor *)color;

@end
