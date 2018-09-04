//
//  UIView+FBKit.m
//  FlexBoxKit
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "UIView+FBKit.h"
#import "FBKLayout+Private.h"
#import <objc/runtime.h>
#import "FBKDiv.h"

static const void *kYGYogaAssociatedKey = &kYGYogaAssociatedKey;
static const void *kFBKChildrenKey = &kFBKChildrenKey;

@implementation UIView (FBKit)

#pragma mark getter setter
- (BOOL)isYogaEnabled
{
    return objc_getAssociatedObject(self, kYGYogaAssociatedKey) != nil;
}

- (void)configureLayout:(FBKLayoutConfigurationBlock)block
{
    if (block != nil) {
        [self layout].isEnabled = YES;
        block(self.layout);
    }
}
- (void)setFb_drawsAsynchronously:(BOOL)fb_drawsAsynchronously {
    self.layer.drawsAsynchronously = fb_drawsAsynchronously;
}

- (BOOL)fb_drawsAsynchronously {
    return self.layer.drawsAsynchronously;
}

#pragma mark FBKLayoutProtocol

- (FBKLayout *)layout
{
    FBKLayout *layout = objc_getAssociatedObject(self, kYGYogaAssociatedKey);
    if (!layout) {
        layout = [[FBKLayout alloc] initWithView:self];
        objc_setAssociatedObject(self, kYGYogaAssociatedKey, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return layout;
}

-(NSArray<id<FBKLayoutProtocol>> *)children{
    return objc_getAssociatedObject(self, kFBKChildrenKey) ? : [NSMutableArray array];
}


-(void)setChildren:(NSArray<id<FBKLayoutProtocol>> *)children{
    if ([self children] == children) {
        return;
    }
    for (id<FBKLayoutProtocol> child in children) {
        [self addChild:child];
    }
}

- (void)addChild:(id<FBKLayoutProtocol>)child {
    NSMutableArray *newChildren = [[self children] mutableCopy];
    if([newChildren containsObject:child]) return;
    [newChildren addObject:child];
    objc_setAssociatedObject(self, kFBKChildrenKey, newChildren, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addChildToView:child];
}


- (void)applyLayout {
    [self.layout applyLayoutPreservingOrigin:NO];
}

- (void)removeAllChildren {
    [[self layout] removeAllChildren];
    objc_setAssociatedObject(self, kFBKChildrenKey, [NSMutableArray array], OBJC_ASSOCIATION_COPY_NONATOMIC);
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)removeChild:(id<FBKLayoutProtocol>)child {
    NSMutableArray *newChildren = [[self children] mutableCopy];
    if([newChildren containsObject:child]){
        [newChildren removeObject:child];
        [[self layout] removeChild:child.layout];
    }
    objc_setAssociatedObject(self, kFBKChildrenKey, newChildren, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeChildFromView:child];
}

-(void)insertChild:(id<FBKLayoutProtocol>)child atIndex:(NSInteger)index{
    NSMutableArray *newChildren = [[self children] mutableCopy];
    if([newChildren containsObject:child]) return;
    [newChildren insertObject:child atIndex:index];
    objc_setAssociatedObject(self, kFBKChildrenKey, newChildren, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addChildToView:child];
}

-(void)removeChildAtIndex:(NSInteger)index{
    NSMutableArray *newChildren = [[self children] mutableCopy];
    id<FBKLayoutProtocol> child = newChildren[index];
    [newChildren removeObjectAtIndex:index];
    [[self layout] removeChild:child.layout];
    objc_setAssociatedObject(self, kFBKChildrenKey, newChildren, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeChildFromView:child];
}


#pragma mark private method
- (void)addChildToView:(id<FBKLayoutProtocol>)child {
    if([child isKindOfClass:UIView.class]&&![self.subviews containsObject:(UIView *)child]){
        [self addSubview:((UIView *) child)];
    }
    else if([child isKindOfClass:FBKDiv.class]){
        ((FBKDiv *)child).parentView = self;
        for (id<FBKLayoutProtocol> element in child.children) {
            [self addChildToView:element];
        }
    }
}
-(void)removeChildFromView:(id<FBKLayoutProtocol>)child{
    if([child isKindOfClass:UIView.class] && ((UIView *)child).isYogaEnabled){
        [((UIView *)child) removeFromSuperview];
    }
    else if([child isKindOfClass:FBKDiv.class]){
        for (id<FBKLayoutProtocol> element in child.children) {
            [self removeChildFromView:element];
        }
    }
}

@end
