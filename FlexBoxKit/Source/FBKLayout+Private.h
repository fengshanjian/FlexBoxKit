//
//  FBKLayout+private.h
//  FlexBoxKit
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "FBKLayout.h"
#import <yoga/Yoga.h>
#import "FBKLayoutProtocol.h"
#import "FBKViewLayoutCache.h"

@interface FBKLayout ()

@property (nonatomic, assign, readonly) YGNodeRef node;

- (instancetype)initWithView:(id<FBKLayoutProtocol>)view;
- (void) removeAllChildren;
- (void)removeChild:(FBKLayout *)layout;

- (FBKViewLayoutCache *)layoutCache;
- (void)applyLayoutCache:(FBKViewLayoutCache *)layoutCache;
@end
