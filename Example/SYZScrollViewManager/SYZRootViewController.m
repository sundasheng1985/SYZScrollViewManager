//
//  SYZRootViewController.m
//  SYZScrollViewManager_Example
//
//  Created by LeeRay on 2018/11/18.
//  Copyright © 2018年 sundasheng1985. All rights reserved.
//

#import "SYZRootViewController.h"
#import "SYZUserInfoViewController.h"

@interface SYZRootViewController ()

@end

@implementation SYZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor yellowColor];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"用户详情页" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)buttonAction:(UIButton *)btn{
    [self.navigationController pushViewController:[SYZUserInfoViewController new] animated:YES];
}

@end
