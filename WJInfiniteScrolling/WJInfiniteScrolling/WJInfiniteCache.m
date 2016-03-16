//
//  WJInfiniteCache.m
//  WJInfiniteScrolling
//
//  Created by 汪俊 on 16/3/16.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import "WJInfiniteCache.h"

@interface WJInfiniteCache ()
@property (strong, nonatomic)NSString *path;
@end

@implementation WJInfiniteCache
singleton_m(InfiniteCache)

- (NSString *)path {
    if (_path == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _path = [paths firstObject];
        _path = [_path stringByAppendingPathComponent:@"wjImages"];
    }
    return _path;
}

- (NSInteger)getSize {
    // 做无限滚动的图片一般很少，所以并不耗时，不需要异步操作
    NSUInteger size = 0;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:self.path];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        size += [[[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil][NSFileSize] integerValue];
    }
    return size;
}


- (void)clearCache {
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:self.path]) {
        [fileManager removeItemAtPath:self.path error:nil];
    }

}


@end
