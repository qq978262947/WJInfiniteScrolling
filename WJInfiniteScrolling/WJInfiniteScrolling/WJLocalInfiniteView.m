//
//  WJOneView.m
//  WJInfiniteScrolling
//
//  Created by 汪俊 on 16/3/9.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import "WJLocalInfiniteView.h"
#import <Masonry.h>

#define WJScreen [UIScreen mainScreen].bounds.size.width
#define WJFiniteScrollW (WJScreen - 20)

static NSInteger const WJADImageBaseTag = 10;

@interface WJLocalInfiniteView () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageCotrol;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSTimer *timer;
@end



@implementation WJLocalInfiniteView



- (void)setImages:(NSArray *)images {
    _images = [images copy];
    self.pageCotrol.numberOfPages = images.count;
    [self configImageView];
    
}

- (void)configImageView
{
    // 获取当前页的上一页
    NSInteger page = (self.currentPage - 1 + _images.count) % _images.count;
    for (int i = 0; i < 3; i++) {
        // 得到当前页及其前后页
        int pageIndex = (int) (i + page) % _images.count;
        // 取出对应的图片
        NSString *imageName = _images[pageIndex];
        // 为其刷新图片
        UIImageView *imageView = [self viewWithTag:WJADImageBaseTag + i];
        imageView.image = [UIImage imageNamed:imageName];
    }
    self.pageCotrol.currentPage = self.currentPage;
    self.scrollView.contentOffset = CGPointMake(WJFiniteScrollW, 0);
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self configSubViews];
    [self configTimer];
}
- (void)configSubViews
{
    // 创建scrollerview，并初始化
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    
    // 创建contentview并设置那边距
    UIView *contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIView *lastView = nil;
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [contentView addSubview:imageView];
        imageView.tag = WJADImageBaseTag + i;
        imageView.userInteractionEnabled = YES;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(lastView ? lastView.mas_right : @(0));
            make.top.bottom.equalTo(@0);
            make.width.equalTo(self);
        }];
        
        lastView = imageView;
        
    }
    
    
//    contentView.frame = CGRectMake(0, 0, WJFiniteScrollW * 3, 200);
//        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.equalTo(@0);
//            make.bottom.equalTo(@0);
//            make.right.equalTo(lastView.mas_right);
//        }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(@(WJFiniteScrollW * 3));
        make.height.equalTo(self);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        make.right.equalTo(contentView.mas_right);
    }];
    
    
    
    UIPageControl *pageCotrol = [[UIPageControl alloc]init];
    pageCotrol.pageIndicatorTintColor = [UIColor yellowColor];
    pageCotrol.currentPageIndicatorTintColor = [UIColor greenColor];
    [self addSubview:pageCotrol];
    self.pageCotrol = pageCotrol;
    pageCotrol.currentPage = 0;
    pageCotrol.numberOfPages = _images.count;
    
    [pageCotrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@0);
        make.width.greaterThanOrEqualTo(@48);
    }];
    
    [pageCotrol addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    self.currentPage = 0;
    scrollView.contentSize = CGSizeMake(WJFiniteScrollW * 3, 0);
    scrollView.contentOffset = CGPointMake(WJFiniteScrollW, 0);
    
}

- (void)changePage:(UIPageControl *)pageControl {
    self.currentPage = pageControl.currentPage;
    [self configImageView];
}



- (void)configTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(autoChangePage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)autoChangePage {
    self.currentPage = (self.currentPage + 1) % _images.count;
    [self configImageView];
}


#pragma mark  - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = (scrollView.contentOffset.x - WJFiniteScrollW) / WJFiniteScrollW;
    
    pageIndex >= 0 ? 1 : (pageIndex = _images.count - 1);
    self.currentPage = (self.currentPage + pageIndex) % _images.count;
    [self configImageView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self configTimer];
}

@end
