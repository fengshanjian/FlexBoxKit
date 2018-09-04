//
//  FBKFeedModel.m
//  FlexBoxLayout
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "FBKFeedModel.h"

@implementation FBKFeedModel


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = super.init;
  if (self) {
    _title = dictionary[@"title"];
    _content = dictionary[@"content"];
    _username = dictionary[@"username"];
    _time = dictionary[@"time"];
    _imageName = dictionary[@"imageName"];
  }
  return self;
}



@end
