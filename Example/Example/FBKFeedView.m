//
//  FBKFeedView.m
//  FlexBoxLayout_Example
//
//  Created by will on 2018/8/29.
//  Copyright © 2018年 will. All rights reserved.
//

#import "FBKFeedView.h"
#import "FlexBoxKit.h"
#import <yoga/YGEnums.h>

@interface FBKFeedView ()

@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *contentLabel;
@property (nonatomic, strong)  UIImageView *contentImageView;
@property (nonatomic, strong)  UILabel *usernameLabel;
@property (nonatomic, strong)  UILabel *timeLabel;

@end
@implementation FBKFeedView

- (instancetype)initWithModel:(FBKFeedModel *)model {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)]) {
        [self configView];
        [self configData:model];
        [self layoutView];
    }
    
    return self;
}

- (void)configView {
    
    _titleLabel = [UILabel new];
    
    _contentLabel = [UILabel new];
    
    _contentLabel.numberOfLines = 0;
    
    _contentImageView = [UIImageView new];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    _usernameLabel = [UILabel new];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
}

- (void)configData:(FBKFeedModel *)model {
    
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    _contentLabel.attributedText = [[NSAttributedString alloc] initWithString:model.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    _contentImageView.image = [UIImage imageNamed:model.imageName];
    
    _usernameLabel.attributedText = [[NSAttributedString alloc] initWithString:model.username attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    _timeLabel.attributedText = [[NSAttributedString alloc] initWithString:model.time attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
}

- (void)layoutView {
    
    
    [_titleLabel configureLayout:^(FBKLayout * _Nonnull layout) {
        layout.kMarginTop = 10;
    }];
    [_contentLabel configureLayout:^(FBKLayout *layout) {
        layout.kMarginTop = 10;
    }];
    [_contentImageView configureLayout:^(FBKLayout *layout) {
        layout.kMarginTop = 10;
    }];
    [_usernameLabel configureLayout:^(FBKLayout *layout) {
        layout.flexGrow = 1.0;
    }];
    [_timeLabel configureLayout:^(FBKLayout *layout) {
        layout.flexGrow = 1.0;
    }];
    
    FBKDiv *div = [FBKDiv new];
    [div configureLayout:^(FBKLayout *layout) {
        layout.flexDirection = YGFlexDirectionRow;
        layout.justifyContent = YGJustifySpaceBetween;
        layout.alignItems = YGAlignCenter;
        layout.kMarginTop = 10;
        layout.kWidth = [UIScreen mainScreen].bounds.size.width-30;
    }];
    [div addChild:_usernameLabel];
    [div addChild:_timeLabel];
    
    [self configureLayout:^(FBKLayout *layout) {
        layout.kMarginLeft = layout.kMarginRight = 15;
        layout.kPaddingBottom = 10;
        layout.alignItems = YGAlignFlexStart;
        
    }];
    [self setChildren:@[_titleLabel,_contentLabel,_contentImageView,div]];

}

@end
