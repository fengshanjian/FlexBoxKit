//
//  UITableView+FBKit.h
//  FlexBoxKit
//
//  Created by will on 2018/9/3.
//  Copyright © 2018年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef UIView *_Nonnull (^FBKCellBlock)(NSIndexPath *indexPath);

@interface UITableView (FBKit)

/**
 setting the cell contentView Size, defalut width of UITableView
 */
@property(nonatomic) CGFloat fb_constrainedWidth;



/**
 cache layout
 */
@property(nonatomic) BOOL fb_cacheLayout;



/**
 cache content view cannot be together with fb_CacheLayout at the same time
 
 */
@property(nonatomic) BOOL fb_cacheContentView;


/**
 get the height of cell
 @param indexPath indexpath
 @return height
 */
- (CGFloat)fb_heightForIndexPath:(NSIndexPath *)indexPath;


/**
 get the cell of indexPath
 @param indexPath indexPath
 @return cell
 */
- (UITableViewCell *)fb_cellForIndexPath:(NSIndexPath *)indexPath;


/**
 set the cell content view
 @param cellBlock UIView
 */
- (void)fb_setCellContnetViewBlockForIndexPath:(FBKCellBlock)cellBlock;


/**
 content view
 @param indexPath indexPath
 @return nil if cell is not visible or index path is out of range
 */
- (UIView *)fb_contentViewForIndexPath:(NSIndexPath *)indexPath;


/**
 remove all cache
 */
- (void)fb_removeAllCache;

@end

NS_ASSUME_NONNULL_END
