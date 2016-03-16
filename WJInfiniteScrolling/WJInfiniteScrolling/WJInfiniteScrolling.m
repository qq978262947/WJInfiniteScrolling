//
//  WJInfiniteScrolling.m
//  WJInfiniteScrolling
//
//  Created by 汪俊 on 16/3/15.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import "WJInfiniteScrolling.h"
#import <Masonry.h>
#import "WJDownloadOperation.h"
#import "NSString+WJMD5.h"

#define WJScreen [UIScreen mainScreen].bounds.size.width
#define WJFiniteScrollW (WJScreen - 20)

static NSInteger const WJADImageBaseTag = 10;

@interface WJInfiniteScrolling () <UIScrollViewDelegate, WJDownloadOperationDelegate>
/**
 *  pagecontrol
 */
@property (nonatomic, weak) UIPageControl *pageCotrol;
/**
 *  scrollview
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  当前页
 */
@property (nonatomic, assign) NSInteger currentPage;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, strong) NSOperationQueue *queue;
/** key:url value:operation对象 */
@property (nonatomic, strong) NSMutableDictionary *operations;

/**
 *  存放图片等字典
 */
@property (nonatomic, strong)NSMutableDictionary *imagesDict;
/**
 *  沙盒cache路径
 */
@property (strong, nonatomic)NSString *path;
@end



@implementation WJInfiniteScrolling

- (NSString *)path {
    if (nil == _path) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _path = [paths firstObject];
        _path = [_path stringByAppendingPathComponent:@"wjImages"];
        // 判断文件夹是否存在，如果不存在，则创建
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:_path]) {
            [manager createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _path;
}

- (NSMutableDictionary *)imagesDict {
    if (nil == _imagesDict) {
        _imagesDict = [NSMutableDictionary dictionary];
    }
    return _imagesDict;
}

/**
 *  队列
 *
 *  @return queue
 */
- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3; // 最大并发数 == 3
    }
    return _queue;
}
/**
 *  存放所有下载任务的字典
 *
 *  @return NSMutableDictionary
 */
- (NSMutableDictionary *)operations
{
    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (UIImage *)placeholderImage {
    if (nil == _placeholderImage) {
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"placeholderImage" ofType:@"bundle"];
        NSString *filePath = [bundlePath stringByAppendingPathComponent:@"FollowBtnClickBg"];
        _placeholderImage = [UIImage imageNamed:filePath];
    }
    return _placeholderImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupReceiveMemoryWaring];
    self.autoPlayInterval = 2.5;
}

+ (instancetype)infiniteScrollingView {
    return [[self alloc]initWithFrame:CGRectZero];
}

+ (instancetype)infiniteScrollingViewWithFrame:(CGRect)frame {
    return [[self alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupReceiveMemoryWaring];
        self.autoPlayInterval = 2.5;
    }
    return self;
}




- (void)setUrlImageStrings:(NSArray *)urlImageStrings {
    _urlImageStrings = [urlImageStrings copy];
    self.pageCotrol.numberOfPages = urlImageStrings.count;
    //设置一个图片的存储路径
    
    
    for (int i = 0; i < urlImageStrings.count; i++) {
        NSString *urlString = urlImageStrings[i];
        NSString *filePath = [self.path stringByAppendingPathComponent:[NSString stringWithFormat:@"wj_imageFilePath%@", [urlString md532BitLower]]];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if (nil == image) {
            
            WJDownloadOperation *operation = self.operations[urlString];
            if (operation) { // 正在下载
                // ... 暂时不需要做其他事
                
            } else { // 没有正在下载
                // 创建操作
                operation = [[WJDownloadOperation alloc] init];
                operation.url = urlString;
                operation.delegate = self;
                [self.queue addOperation:operation]; // 异步下载
                self.operations[urlString] = operation;
            }
        } else {
            [self setupImage:image WithUrlString:urlString];
        }
    }
    [self configImageView];
    
}

/**
 *  需要接受内存警告通知
 */
- (void)setupReceiveMemoryWaring {
    //接收内存警告通知，调用handleMemoryWarning方法处理
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}


- (void)configImageView
{
    // 获取当前页的上一页
    NSInteger page = (self.currentPage - 1 + _urlImageStrings.count) % _urlImageStrings.count;
    for (int i = 0; i < 3; i++) {
        // 得到当前页及其前后页
        int pageIndex = (int) (i + page) % _urlImageStrings.count;
        // 取出对应的图片
        NSString *urlString = _urlImageStrings[pageIndex];
        UIImage *image = self.imagesDict[urlString];
        // 为其刷新图片
        UIImageView *imageView = [self viewWithTag:WJADImageBaseTag + i];
        if (image) {
            imageView.image = image;
        } else {
            NSString *filePath = [self.path stringByAppendingPathComponent:[NSString stringWithFormat:@"wj_imageFilePath%@", [urlString md532BitLower]]];
            image = [UIImage imageWithContentsOfFile:filePath];
            imageView.image = image ? image : self.placeholderImage;
        }
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
    pageCotrol.numberOfPages = _urlImageStrings.count;
    
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

// 初始化定时器
- (void)configTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoPlayInterval target:self selector:@selector(autoChangePage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 定时器跳转掉用的方法
- (void)autoChangePage {
    self.currentPage = (self.currentPage + 1) % _urlImageStrings.count;
    [self configImageView];
}

// 设置图片
- (void)setupImage:(UIImage *)image WithUrlString:(NSString *)urlString {
    if (!image) return;
    [self.imagesDict setObject:image forKey:urlString];
    if (self.scrollView.contentOffset.x == WJFiniteScrollW) {
        [self configImageView];
    }
}

#pragma mark - WJDownloadOperationDelegate
- (void)downloadOperation:(WJDownloadOperation *)operation didFinishDownload:(UIImage *)image {
    [self setupImage:image WithUrlString:operation.url];

    NSString *filePath = [self.path stringByAppendingPathComponent:[NSString stringWithFormat:@"wj_imageFilePath%@", [operation.url md532BitLower]]];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

#pragma mark  - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = (scrollView.contentOffset.x - WJFiniteScrollW) / WJFiniteScrollW;
    
    pageIndex >= 0 ? 1 : (pageIndex = _urlImageStrings.count - 1);
    self.currentPage = (self.currentPage + pageIndex) % _urlImageStrings.count;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width - 0.5 + self.currentPage;
    if (page < 0) {
        page += _urlImageStrings.count;
    } else if (page >= _urlImageStrings.count) {
        page -= _urlImageStrings.count;
    }
    self.pageCotrol.currentPage = page;
}

//处理内存警告
- (void)handleMemoryWarning
{
//    NSLog(@"ViewController中handleMemoryWarning调用");
    // 需要在这里做一些内存清理工作. 如果不处理，会被系统强制闪退。
    // 清理图片的缓存
    [self.imagesDict removeAllObjects];
    self.placeholderImage = nil;
    // 清理操作缓存
    [self.operations removeAllObjects];
    
    // 取消下载队列里面的任务
    [self.queue cancelAllOperations];
    
}

/**
 *  移除通知
 */
- (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

@end

