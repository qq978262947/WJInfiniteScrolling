//
//  WJTwoViewController.m
//  WJInfiniteScrolling
//
//  Created by 汪俊 on 16/3/15.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import "WJTwoViewController.h"
#import "WJInfiniteScrolling.h"
#import "Masonry.h"
#import "WJInfiniteCache.h"

@interface WJTwoViewController ()

@end

@implementation WJTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    WJInfiniteScrolling *oneView = [[WJInfiniteScrolling alloc]init];
    [self.view addSubview:oneView];
    
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(@200);
        make.height.equalTo(@190);
    }];
    
    oneView.backgroundColor = [UIColor whiteColor];
    oneView.urlImageStrings = @[
                                @"http://i3.itc.cn/20160301/36e1_589ee660_9f1a_f7f9_841e_48a68aa61a15_1.jpg",
                                @"http://i2.itc.cn/20160309/3711_d3adb0d1_40a4_d8e0_c62f_a23cbc3edc84_1.jpg",
                                @"http://i0.itc.cn/20160315/3711_c0bdfb55_8e1f_733f_00fa_4880aa42e663_1.jpg",
                                @"http://i3.itc.cn/20160314/3711_91558c48_90d8_3651_f717_6fb6d83a9f9e_1.jpg",
                                @"http://i3.itc.cn/20160315/3711_8759ea44_704f_6218_b24f_aae33c82f0b9_1.jpg"
                                ];
    NSLog(@"%.2fM",(long)[[WJInfiniteCache sharedInfiniteCache] getSize] / 1000.0 / 1000.0);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[WJInfiniteCache sharedInfiniteCache]clearCache];
//    });
    //    http://i3.itc.cn/20160301/36e1_589ee660_9f1a_f7f9_841e_48a68aa61a15_1.jpg
    //    http://i2.itc.cn/20160309/3711_d3adb0d1_40a4_d8e0_c62f_a23cbc3edc84_1.jpg
    //    http://i0.itc.cn/20160315/3711_c0bdfb55_8e1f_733f_00fa_4880aa42e663_1.jpg
    //    http://i3.itc.cn/20160314/3711_91558c48_90d8_3651_f717_6fb6d83a9f9e_1.jpg
    //    http://i3.itc.cn/20160315/3711_8759ea44_704f_6218_b24f_aae33c82f0b9_1.jpg
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
