//
//  FBKViewLayoutCache.h
//  FlexBoxKit
//
//  Created by will on 2018/9/3.
//  Copyright © 2018年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBKViewLayoutCache : NSObject

@property(nonatomic, assign) CGRect frame;

@property(nonatomic, strong) NSArray<FBKViewLayoutCache*> *childrenCache;
@end
