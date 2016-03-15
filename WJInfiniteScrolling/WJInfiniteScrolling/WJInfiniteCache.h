//
//  WJInfiniteCache.h
//  WJInfiniteScrolling
//
//  Created by 汪俊 on 16/3/16.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "singleton.h"

@interface WJInfiniteCache : NSObject

singleton_h(InfiniteCache)
/**
 *  获取缓存文件夹下文件数量
 *
 *  @return NSInteger
 */
- (NSInteger)getSize;
/**
 *  清除缓存
 */
- (void)clearCache;

@end
