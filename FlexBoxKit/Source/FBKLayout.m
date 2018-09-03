//
//  FBKLayout.m
//  FlexBoxKit
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "FBKLayout+Private.h"
#import "UIView+FBKit.h"
#import "FBKDiv.h"
#import "FBKViewLayoutCache.h"

#define FBK_VALUE_PROPERTY(lowercased_name, capitalized_name)                      \
- (CGFloat)k##lowercased_name                                                      \
{                                                                                  \
return YGNodeStyleGet##capitalized_name(self.node).value;                        \
}                                                                                  \
\
- (void)setK##capitalized_name:(CGFloat)k##lowercased_name                         \
{                                                                                  \
YGNodeStyleSet##capitalized_name(self.node, k##lowercased_name);                 \
}

#define YG_PROPERTY(type, lowercased_name, capitalized_name)    \
- (type)lowercased_name                                         \
{                                                               \
return YGNodeStyleGet##capitalized_name(self.node);           \
}                                                               \
\
- (void)set##capitalized_name:(type)lowercased_name             \
{                                                               \
YGNodeStyleSet##capitalized_name(self.node, lowercased_name); \
}

#define YG_VALUE_PROPERTY(lowercased_name, capitalized_name)                       \
- (YGValue)lowercased_name                                                         \
{                                                                                  \
return YGNodeStyleGet##capitalized_name(self.node);                              \
}                                                                                  \
\
- (void)set##capitalized_name:(YGValue)lowercased_name                             \
{                                                                                  \
switch (lowercased_name.unit) {                                                  \
case YGUnitPoint:                                                              \
YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value);          \
break;                                                                       \
case YGUnitPercent:                                                            \
YGNodeStyleSet##capitalized_name##Percent(self.node, lowercased_name.value); \
break;                                                                       \
default:                                                                       \
NSAssert(NO, @"Not implemented");                                            \
}                                                                                \
}

#define YG_EDGE_PROPERTY_GETTER(type, lowercased_name, capitalized_name, property, edge) \
- (type)lowercased_name                                                                  \
{                                                                                        \
return YGNodeStyleGet##property(self.node, edge);                                      \
}

#define YG_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge) \
- (void)set##capitalized_name:(CGFloat)lowercased_name                             \
{                                                                                  \
YGNodeStyleSet##property(self.node, edge, lowercased_name);                      \
}

#define YG_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)         \
YG_EDGE_PROPERTY_GETTER(CGFloat, lowercased_name, capitalized_name, property, edge) \
YG_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGE_PROPERTY_SETTER(objc_lowercased_name, objc_capitalized_name, c_name, edge) \
- (void)set##objc_capitalized_name:(YGValue)objc_lowercased_name                                 \
{                                                                                                \
switch (objc_lowercased_name.unit) {                                                           \
case YGUnitPoint:                                                                            \
YGNodeStyleSet##c_name(self.node, edge, objc_lowercased_name.value);                       \
break;                                                                                     \
case YGUnitPercent:                                                                          \
YGNodeStyleSet##c_name##Percent(self.node, edge, objc_lowercased_name.value);              \
break;                                                                                     \
default:                                                                                     \
NSAssert(NO, @"Not implemented");                                                          \
}                                                                                              \
}

#define FBK_EDGE_PROPERTY_GETTER(lowercased_name, capitalized_name, property, edge)      \
- (CGFloat)k##lowercased_name                                                               \
{                                                                                        \
return YGNodeStyleGet##property(self.node, edge).value;                                \
}

#define FBK_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)    \
- (void)setK##capitalized_name:(CGFloat)k##lowercased_name                             \
{                                                                                      \
YGNodeStyleSet##property(self.node, edge, k##lowercased_name);                       \
}
#define FBK_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)   \
FBK_EDGE_PROPERTY_GETTER(lowercased_name, capitalized_name, property, edge)          \
FBK_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)   \
YG_EDGE_PROPERTY_GETTER(YGValue, lowercased_name, capitalized_name, property, edge) \
YG_VALUE_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGES_PROPERTIES(lowercased_name, capitalized_name)                                                  \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Left, capitalized_name##Left, capitalized_name, YGEdgeLeft)                   \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Top, capitalized_name##Top, capitalized_name, YGEdgeTop)                      \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Right, capitalized_name##Right, capitalized_name, YGEdgeRight)                \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Bottom, capitalized_name##Bottom, capitalized_name, YGEdgeBottom)             \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Start, capitalized_name##Start, capitalized_name, YGEdgeStart)                \
YG_VALUE_EDGE_PROPERTY(lowercased_name##End, capitalized_name##End, capitalized_name, YGEdgeEnd)                      \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Horizontal, capitalized_name##Horizontal, capitalized_name, YGEdgeHorizontal) \
YG_VALUE_EDGE_PROPERTY(lowercased_name##Vertical, capitalized_name##Vertical, capitalized_name, YGEdgeVertical)       \
YG_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, capitalized_name, YGEdgeAll)

#define FBK_VALUE_EDGES_PROPERTIES(lowercased_name, capitalized_name)                                                  \
FBK_VALUE_EDGE_PROPERTY(lowercased_name##Left, capitalized_name##Left, capitalized_name, YGEdgeLeft)                   \
FBK_VALUE_EDGE_PROPERTY(lowercased_name##Top, capitalized_name##Top, capitalized_name, YGEdgeTop)                      \
FBK_VALUE_EDGE_PROPERTY(lowercased_name##Right, capitalized_name##Right, capitalized_name, YGEdgeRight)                \
FBK_VALUE_EDGE_PROPERTY(lowercased_name##Bottom, capitalized_name##Bottom, capitalized_name, YGEdgeBottom)             \
FBK_VALUE_EDGE_PROPERTY(lowercased_name##Start, capitalized_name##Start, capitalized_name, YGEdgeStart)                \
FBK_VALUE_EDGE_PROPERTY(lowercased_name##End, capitalized_name##End, capitalized_name, YGEdgeEnd)                      \
FBK_VALUE_EDGE_PROPERTY(lowercased_name##Horizontal, capitalized_name##Horizontal, capitalized_name, YGEdgeHorizontal) \
FBK_VALUE_EDGE_PROPERTY(lowercased_name##Vertical, capitalized_name##Vertical, capitalized_name, YGEdgeVertical)       \
FBK_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, capitalized_name, YGEdgeAll)

YGValue YGPointValue(CGFloat value)
{
    return (YGValue) { .value = value, .unit = YGUnitPoint };
}

YGValue YGPercentValue(CGFloat value)
{
    return (YGValue) { .value = value, .unit = YGUnitPercent };
}

static YGConfigRef globalConfig;

@interface FBKLayout ()

@property (nonatomic, weak, readonly) id<FBKLayoutProtocol> view;

@end

@implementation FBKLayout

@synthesize isEnabled=_isEnabled;
@synthesize isIncludedInLayout=_isIncludedInLayout;
@synthesize node=_node;

+ (void)initialize
{
    globalConfig = YGConfigNew();
    YGConfigSetExperimentalFeatureEnabled(globalConfig, YGExperimentalFeatureWebFlexBasis, true);
    YGConfigSetPointScaleFactor(globalConfig, [UIScreen mainScreen].scale);
}

- (instancetype)initWithView:(id<FBKLayoutProtocol>)view
{
    if (self = [super init]) {
        _view = view;
        _node = YGNodeNewWithConfig(globalConfig);
        YGNodeSetContext(_node, (__bridge void *) view);
        _isEnabled = NO;
        _isIncludedInLayout = YES;
    }
    
    return self;
}


- (void)dealloc
{
    YGNodeFree(self.node);
}

- (BOOL)isDirty
{
    return YGNodeIsDirty(self.node);
}

- (void)markDirty
{
    if (self.isDirty || !self.isLeaf) {
        return;
    }
    
    // Yoga is not happy if we try to mark a node as "dirty" before we have set
    // the measure function. Since we already know that this is a leaf,
    // this *should* be fine. Forgive me Hack Gods.
    const YGNodeRef node = self.node;
    if (YGNodeGetMeasureFunc(node) == NULL) {
        YGNodeSetMeasureFunc(node, YGMeasureView);
    }
    
    YGNodeMarkDirty(node);
}

- (NSUInteger)numberOfChildren
{
    return YGNodeGetChildCount(self.node);
}

- (BOOL)isLeaf
{
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
    if (self.isEnabled) {
        for (id<FBKLayoutProtocol> subview in self.view.children) {
            FBKLayout *const yoga = subview.layout;
            if (yoga.isEnabled && yoga.isIncludedInLayout) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - Style

- (YGPositionType)position
{
    return YGNodeStyleGetPositionType(self.node);
}

- (void)setPosition:(YGPositionType)position
{
    YGNodeStyleSetPositionType(self.node, position);
}

YG_PROPERTY(YGDirection, direction, Direction)
YG_PROPERTY(YGFlexDirection, flexDirection, FlexDirection)
YG_PROPERTY(YGJustify, justifyContent, JustifyContent)
YG_PROPERTY(YGAlign, alignContent, AlignContent)
YG_PROPERTY(YGAlign, alignItems, AlignItems)
YG_PROPERTY(YGAlign, alignSelf, AlignSelf)
YG_PROPERTY(YGWrap, flexWrap, FlexWrap)
YG_PROPERTY(YGOverflow, overflow, Overflow)
YG_PROPERTY(YGDisplay, display, Display)

YG_PROPERTY(CGFloat, flexGrow, FlexGrow)
YG_PROPERTY(CGFloat, flexShrink, FlexShrink)
YG_VALUE_PROPERTY(flexBasis, FlexBasis)
FBK_VALUE_PROPERTY(FlexBasis, FlexBasis)

YG_VALUE_EDGE_PROPERTY(left, Left, Position, YGEdgeLeft)
YG_VALUE_EDGE_PROPERTY(top, Top, Position, YGEdgeTop)
YG_VALUE_EDGE_PROPERTY(right, Right, Position, YGEdgeRight)
YG_VALUE_EDGE_PROPERTY(bottom, Bottom, Position, YGEdgeBottom)
YG_VALUE_EDGE_PROPERTY(start, Start, Position, YGEdgeStart)
YG_VALUE_EDGE_PROPERTY(end, End, Position, YGEdgeEnd)
YG_VALUE_EDGES_PROPERTIES(margin, Margin)
YG_VALUE_EDGES_PROPERTIES(padding, Padding)

FBK_VALUE_EDGE_PROPERTY(Left, Left, Position, YGEdgeLeft)
FBK_VALUE_EDGE_PROPERTY(Top, Top, Position, YGEdgeTop)
FBK_VALUE_EDGE_PROPERTY(Right, Right, Position, YGEdgeRight)
FBK_VALUE_EDGE_PROPERTY(Bottom, Bottom, Position, YGEdgeBottom)
FBK_VALUE_EDGE_PROPERTY(Start, Start, Position, YGEdgeStart)
FBK_VALUE_EDGE_PROPERTY(End, End, Position, YGEdgeEnd)
FBK_VALUE_EDGES_PROPERTIES(Margin, Margin)
FBK_VALUE_EDGES_PROPERTIES(Padding, Padding)

YG_EDGE_PROPERTY(borderLeftWidth, BorderLeftWidth, Border, YGEdgeLeft)
YG_EDGE_PROPERTY(borderTopWidth, BorderTopWidth, Border, YGEdgeTop)
YG_EDGE_PROPERTY(borderRightWidth, BorderRightWidth, Border, YGEdgeRight)
YG_EDGE_PROPERTY(borderBottomWidth, BorderBottomWidth, Border, YGEdgeBottom)
YG_EDGE_PROPERTY(borderStartWidth, BorderStartWidth, Border, YGEdgeStart)
YG_EDGE_PROPERTY(borderEndWidth, BorderEndWidth, Border, YGEdgeEnd)
YG_EDGE_PROPERTY(borderWidth, BorderWidth, Border, YGEdgeAll)

YG_VALUE_PROPERTY(width, Width)
YG_VALUE_PROPERTY(height, Height)
YG_VALUE_PROPERTY(minWidth, MinWidth)
YG_VALUE_PROPERTY(minHeight, MinHeight)
YG_VALUE_PROPERTY(maxWidth, MaxWidth)
YG_VALUE_PROPERTY(maxHeight, MaxHeight)
FBK_VALUE_PROPERTY(Width, Width)
FBK_VALUE_PROPERTY(Height, Height)
FBK_VALUE_PROPERTY(MinWidth, MinWidth)
FBK_VALUE_PROPERTY(MinHeight, MinHeight)
FBK_VALUE_PROPERTY(MaxWidth, MaxWidth)
FBK_VALUE_PROPERTY(MaxHeight, MaxHeight)
YG_PROPERTY(CGFloat, aspectRatio, AspectRatio)

#pragma mark private

-(void)removeChild:(FBKLayout *)layout{
     YGNodeRemoveChild(_node, layout.node);
}
-(void)removeAllChildren{
    YGRemoveAllChildren(_node);
}

#pragma mark - Layout and Sizing

- (YGDirection)resolvedDirection
{
    return YGNodeLayoutGetDirection(self.node);
}

- (void)applyLayout
{
    CGSize size = CGSizeZero;
    if([self.view isKindOfClass:UIView.class]){
        size = ((UIView *)self.view).bounds.size;
    }else if([self.view isKindOfClass:FBKDiv.class]){
        size = ((FBKDiv *)self.view).frame.size;
    }
    [self calculateLayoutWithSize:size];
    YGApplyLayoutToViewHierarchy(self.view, NO);
}

- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin
{
    CGSize size = CGSizeZero;
    if([self.view isKindOfClass:UIView.class]){
        size = ((UIView *)self.view).bounds.size;
    }else if([self.view isKindOfClass:FBKDiv.class]){
        size = ((FBKDiv *)self.view).frame.size;
    }
    [self calculateLayoutWithSize:size];
    YGApplyLayoutToViewHierarchy(self.view, preserveOrigin);
}

- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin withSize:(CGSize) size{
    [self calculateLayoutWithSize:size];
    YGApplyLayoutToViewHierarchy(self.view, preserveOrigin);
}
- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin dimensionFlexibility:(YGDimensionFlexibility)dimensionFlexibility
{
    CGSize size = CGSizeZero;
    if([self.view isKindOfClass:UIView.class]){
        size = ((UIView *)self.view).bounds.size;
    }else if([self.view isKindOfClass:FBKDiv.class]){
        size = ((FBKDiv *)self.view).frame.size;
    }
    if (dimensionFlexibility & YGDimensionFlexibilityFlexibleWidth) {
        size.width = YGUndefined;
    }
    if (dimensionFlexibility & YGDimensionFlexibilityFlexibleHeigth) {
        size.height = YGUndefined;
    }
    [self calculateLayoutWithSize:size];
    YGApplyLayoutToViewHierarchy(self.view, preserveOrigin);
}


- (CGSize)intrinsicSize
{
    const CGSize constrainedSize = {
        .width = YGUndefined,
        .height = YGUndefined,
    };
    return [self calculateLayoutWithSize:constrainedSize];
}

- (CGSize)calculateLayoutWithSize:(CGSize)size
{
    NSAssert([NSThread isMainThread], @"Yoga calculation must be done on main.");
    NSAssert(self.isEnabled, @"Yoga is not enabled for this view.");
    
    YGAttachNodesFromViewHierachy(self.view);
    
    const YGNodeRef node = self.node;
    YGNodeCalculateLayout(
                          node,
                          size.width,
                          size.height,
                          YGNodeStyleGetDirection(node));
    
    return (CGSize) {
        .width = YGNodeLayoutGetWidth(node),
        .height = YGNodeLayoutGetHeight(node),
    };
}

#pragma mark - Private

static YGSize YGMeasureView(
                            YGNodeRef node,
                            float width,
                            YGMeasureMode widthMode,
                            float height,
                            YGMeasureMode heightMode)
{
    const CGFloat constrainedWidth = (widthMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : width;
    const CGFloat constrainedHeight = (heightMode == YGMeasureModeUndefined) ? CGFLOAT_MAX: height;
    
    UIView *view = (__bridge UIView*) YGNodeGetContext(node);
    const CGSize sizeThatFits = [view sizeThatFits:(CGSize) {
        .width = constrainedWidth,
        .height = constrainedHeight,
    }];
    
    return (YGSize) {
        .width = YGSanitizeMeasurement(constrainedWidth, sizeThatFits.width, widthMode),
        .height = YGSanitizeMeasurement(constrainedHeight, sizeThatFits.height, heightMode),
    };
}

static CGFloat YGSanitizeMeasurement(
                                     CGFloat constrainedSize,
                                     CGFloat measuredSize,
                                     YGMeasureMode measureMode)
{
    CGFloat result;
    if (measureMode == YGMeasureModeExactly) {
        result = constrainedSize;
    } else if (measureMode == YGMeasureModeAtMost) {
        result = MIN(constrainedSize, measuredSize);
    } else {
        result = measuredSize;
    }
    
    return result;
}

static BOOL YGNodeHasExactSameChildren(const YGNodeRef node, NSArray<id<FBKLayoutProtocol>> *subviews)
{
    if (YGNodeGetChildCount(node) != subviews.count) {
        return NO;
    }
    
    for (int i=0; i<subviews.count; i++) {
        if (YGNodeGetChild(node, i) != subviews[i].layout.node) {
            return NO;
        }
    }
    
    return YES;
}

static void YGAttachNodesFromViewHierachy(id<FBKLayoutProtocol> const view)
{
    FBKLayout *const yoga = view.layout;
    const YGNodeRef node = yoga.node;
    
    // Only leaf nodes should have a measure function
    if (yoga.isLeaf) {
        YGRemoveAllChildren(node);
        YGNodeSetMeasureFunc(node, YGMeasureView);
    } else {
        YGNodeSetMeasureFunc(node, NULL);
        
        NSMutableArray<id<FBKLayoutProtocol>> *subviewsToInclude = [[NSMutableArray alloc] initWithCapacity:view.children.count];
        for (id<FBKLayoutProtocol>subview in view.children) {
            if (subview.layout.isEnabled && subview.layout.isIncludedInLayout) {
                [subviewsToInclude addObject:subview];
            }
        }
        
        if (!YGNodeHasExactSameChildren(node, subviewsToInclude)) {
            YGRemoveAllChildren(node);
            for (int i=0; i<subviewsToInclude.count; i++) {
                subviewsToInclude[i].layout.parent = yoga;
                YGNodeInsertChild(node, subviewsToInclude[i].layout.node, i);
            }
        }
        for (id<FBKLayoutProtocol> const subview in subviewsToInclude) {
            YGAttachNodesFromViewHierachy(subview);
        }
    }
}

static void YGRemoveAllChildren(const YGNodeRef node)
{
    if (node == NULL) {
        return;
    }
    
    while (YGNodeGetChildCount(node) > 0) {
        YGNodeRemoveChild(node, YGNodeGetChild(node, YGNodeGetChildCount(node) - 1));
    }
}

static CGFloat YGRoundPixelValue(CGFloat value)
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        scale = [UIScreen mainScreen].scale;
    });
    
    return roundf(value * scale) / scale;
}

static CGFloat FBKNodeLayoutGetLeft(FBKLayout *layout){
    const BOOL isDiv = [layout.parent.view isKindOfClass:FBKDiv.class];
    return YGNodeLayoutGetLeft(layout.node)+(isDiv?((FBKDiv *)layout.parent.view).frame.origin.x:0);
}
static CGFloat FBKNodeLayoutGetTop(FBKLayout *layout){
    
    const BOOL isDiv = [layout.parent.view isKindOfClass:FBKDiv.class];
    return YGNodeLayoutGetTop(layout.node)+(isDiv?((FBKDiv *)layout.parent.view).frame.origin.y:0);
}

static void YGApplyLayoutToViewHierarchy(id <FBKLayoutProtocol> view, BOOL preserveOrigin)
{
    NSCAssert([NSThread isMainThread], @"Framesetting should only be done on the main thread.");
    
    const FBKLayout *yoga = view.layout;
    
    if (!yoga.isIncludedInLayout) {
        return;
    }
    
    YGNodeRef node = yoga.node;
    
    const CGPoint topLeft = {
        FBKNodeLayoutGetLeft(view.layout),
        FBKNodeLayoutGetTop(view.layout),
    };
    
    const CGPoint bottomRight = {
        topLeft.x + YGNodeLayoutGetWidth(node),
        topLeft.y + YGNodeLayoutGetHeight(node),
    };
    CGPoint oldOrigin = CGPointZero;
    if([view isKindOfClass:UIView.class]) oldOrigin = ((UIView *)view).frame.origin;
    if([view isKindOfClass:FBKDiv.class]) oldOrigin = ((FBKDiv *)view).frame.origin;
    const CGPoint origin = preserveOrigin ? oldOrigin : CGPointZero;
    if([view isKindOfClass:UIView.class]) {
        ((UIView *)view).frame = (CGRect) {
            .origin = {
                .x = YGRoundPixelValue((preserveOrigin ? 0 : topLeft.x) + origin.x),
                .y = YGRoundPixelValue((preserveOrigin ? 0 : topLeft.y) + origin.y),
            },
            .size = {
                .width = YGRoundPixelValue(bottomRight.x) - YGRoundPixelValue(topLeft.x),
                .height = YGRoundPixelValue(bottomRight.y) - YGRoundPixelValue(topLeft.y),
            },
        };
    }
    else if([view isKindOfClass:FBKDiv.class]){
        ((FBKDiv *)view).frame = (CGRect) {
            .origin = {
                .x = YGRoundPixelValue((preserveOrigin ? 0 : topLeft.x) + origin.x),
                .y = YGRoundPixelValue((preserveOrigin ? 0 : topLeft.y) + origin.y),
            },
            .size = {
                .width = YGRoundPixelValue(bottomRight.x) - YGRoundPixelValue(topLeft.x),
                .height = YGRoundPixelValue(bottomRight.y) - YGRoundPixelValue(topLeft.y),
            },
        };
    }
    
    if (!yoga.isLeaf) {
        for (NSUInteger i=0; i<view.children.count; i++) {
            YGApplyLayoutToViewHierarchy(view.children[i], NO);
        }
    }
}


- (FBKViewLayoutCache *)layoutCache {
    
    FBKViewLayoutCache *layoutCache = [FBKViewLayoutCache new];
    layoutCache.frame = [self.view isKindOfClass:UIView.class] ? ((UIView *)self.view).frame:((FBKDiv *)self.view).frame;;
    NSMutableArray *childrenLayoutCache = [NSMutableArray arrayWithCapacity:self.view.children.count];
    for (FBKLayout *childLayout in self.view.children) {
        [childrenLayoutCache addObject:[childLayout layoutCache]];
    }
    layoutCache.childrenCache = [childrenLayoutCache copy];
    return layoutCache;
}


- (void)applyLayoutCache:(FBKViewLayoutCache *)layoutCache {
    id<FBKLayoutProtocol> view = self.view;
    if([view isKindOfClass:UIView.class]){
        ((UIView*) view).frame = layoutCache.frame;
    }else if([view isKindOfClass:FBKDiv.class]){
        ((FBKDiv *) view).frame = layoutCache.frame;
    }
    for (int i = 0; i < layoutCache.childrenCache.count; i++) {
        FBKViewLayoutCache* childLayoutCache = layoutCache.childrenCache[i];
        id<FBKLayoutProtocol> childView = view.children[i];
        [childView.layout applyLayoutCache:childLayoutCache];
    }
}

@end
