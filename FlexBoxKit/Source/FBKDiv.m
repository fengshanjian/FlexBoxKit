//
//  FBKDiv.m
//  FlexBoxKit
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "FBKDiv.h"
#import "FBKLayout+Private.h"
@interface FBKDiv(){
    NSMutableArray *_children;
}

@end

@implementation FBKDiv

@dynamic children;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _layout = [[FBKLayout alloc] initWithView:self];
        _frame = CGRectZero;
        _children = [NSMutableArray new];
    }
    return self;
}

- (void)configureLayout:(FBKLayoutConfigurationBlock)block
{
    if (block != nil) {
        self.layout.isEnabled = YES;
        block(self.layout);
    }
}


#pragma mark FBKLayoutProtocol

-(NSArray<id<FBKLayoutProtocol>> *)children{
    return [_children copy];
}

- (void)setChildren:(NSArray <id<FBKLayoutProtocol>>*)children {
    if (_children == children) {
        return;
    }
    [self removeAllChildren];
    for (id<FBKLayoutProtocol> child in children) {
        [self addChild:child];
    }
}

- (void)addChild:(id<FBKLayoutProtocol>)child {
    if([_children containsObject:child]) return;
    [_children addObject:child];
    if(self.parentView){
        [self addChildToView:child];
    }
}

- (void)applyLayout {
    [self.layout applyLayoutPreservingOrigin:NO];
}

- (void)removeAllChildren {
    [_children removeAllObjects];
    [self.layout removeAllChildren];
    for (id<FBKLayoutProtocol> child in self.children) {
        [self removeChildFromView:child];
    }
}

- (void)removeChild:(id<FBKLayoutProtocol>)child {
    if([_children containsObject:child]){
        [_children removeObject:child];
        [self.layout removeChild:child.layout];
        [self removeChildFromView:child];
    }
}

#pragma mark private method

- (void)addChildToView:(id<FBKLayoutProtocol>)child{
    if([child isKindOfClass:UIView.class]&&![self.parentView.subviews containsObject:(UIView *)child]){
        [self.parentView addSubview:(UIView *)child];
    }else if([child isKindOfClass:FBKDiv.class]){
        [self addChildToView:child];
    }
}

- (void)removeChildFromView:(id<FBKLayoutProtocol>)child{
    if([child isKindOfClass:UIView.class]){
        [((UIView *) child) removeFromSuperview];
    }else if([child isKindOfClass:FBKDiv.class]){
        [self removeChildFromView:child];
    }
}

@end
