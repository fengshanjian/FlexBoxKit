//
//  FBKLayoutProtocol.h
//  FlexBoxKit
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBKLayoutProtocol <NSObject>

@required
/**
 calculates the layout
 */
- (void)applyLayout;

/**
 children layout node
 */
@property(nonatomic, copy) NSArray<id<FBKLayoutProtocol>> *children;

/**
 The FBKLayout that is attached to this view. It is lazily created.
 */
@property(nonatomic, strong, readonly) FBKLayout *layout;

- (void)addChild:(id<FBKLayoutProtocol>)child;

- (void)removeChild:(id<FBKLayoutProtocol>)child;

- (void)removeAllChildren;

@end
