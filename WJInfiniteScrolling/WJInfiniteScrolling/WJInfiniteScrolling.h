//
//  WJInfiniteScrolling.h
//  WJInfiniteScrolling
//
//  Created by 汪俊 on 16/3/15.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJInfiniteScrolling : UIView
/**
 *  初始化方法
 *
 *  @return WJInfiniteScrolling
 */
+ (instancetype)infiniteScrollingView;
/**
 *  初始化方法
 *
 *  @param frame frame
 *
 *  @return WJInfiniteScrolling
 */
+ (instancetype)infiniteScrollingViewWithFrame:(CGRect)frame;

/**
 *  存放url字符串的数组
 */
@property (copy, nonatomic)NSArray *urlImageStrings;

/**
 *  设置占位图片
 */
@property (strong, nonatomic)UIImage *placeholderImage;

@property (assign, nonatomic)long autoPlayInterval;
@end
