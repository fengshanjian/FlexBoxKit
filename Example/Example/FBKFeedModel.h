//
//  FBKFeedModel.h
//  FlexBoxLayout
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBKFeedModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *time;
@property (nonatomic, copy, readonly) NSString *imageName;

@end
