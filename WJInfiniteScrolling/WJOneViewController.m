//
//  WJOneViewController.m
//  WJInfiniteScrolling
//
//  Created by 汪俊 on 16/3/9.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import "WJOneViewController.h"
#import "WJOneView.h"
#import "Masonry.h"

@interface WJOneViewController ()

@end

@implementation WJOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    WJOneView *oneView = [[WJOneView alloc]init];
    [self.view addSubview:oneView];
    
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@200);
        make.height.equalTo(@190);
    }];
    
    oneView.backgroundColor = [UIColor whiteColor];
    oneView.images = @[@"image01", @"image02", @"image03", @"minion_01", @"minion_02", @"minion_03"];
//    oneView.images = @[@"image01", @"image02", @"image03"];
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
