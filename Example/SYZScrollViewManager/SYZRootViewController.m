//
//  SYZRootViewController.m
//  SYZScrollViewManager_Example
//
//  Created by LeeRay on 2018/11/18.
//  Copyright © 2018年 sundasheng1985. All rights reserved.
//

#import "SYZRootViewController.h"
#import "SYZUserInfoViewController.h"
#import "SYZUserInfoOtherViewController.h"

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
    
    UIButton *otherBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBTN.backgroundColor = [UIColor yellowColor];
    otherBTN.frame = CGRectMake(100, 300, 100, 100);
    [otherBTN setTitle:@"用户详情页" forState:UIControlStateNormal];
    [otherBTN addTarget:self action:@selector(otherAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherBTN];
}

- (void)buttonAction:(UIButton *)btn{
    [self.navigationController pushViewController:[SYZUserInfoViewController new] animated:YES];
}

- (void)otherAction:(UIButton *)btn{
    [self.navigationController pushViewController:[SYZUserInfoOtherViewController new] animated:YES];
}

@end
