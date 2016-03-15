//
//  WJHttpTool.h
//  百思不得姐
//
//  Created by 汪俊 on 16/2/17.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WJDownloadOperation;

@protocol WJDownloadOperationDelegate <NSObject>
@optional
- (void)downloadOperation:(WJDownloadOperation *)operation didFinishDownload:(UIImage *)image;
@end

@interface WJDownloadOperation : NSOperation
@property (nonatomic, copy) NSString *url;
@property (nonatomic, weak) id<WJDownloadOperationDelegate> delegate;
@end
