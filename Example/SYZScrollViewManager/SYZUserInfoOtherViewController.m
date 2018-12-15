//
//  SYZUserInfoOtherViewController.m
//  SYZScrollViewManager_Example
//
//  Created by LeeRay on 2018/12/4.
//  Copyright © 2018年 sundasheng1985. All rights reserved.
//

#import "SYZUserInfoOtherViewController.h"
/**子控制器*/
#import "SYZListViewController.h"
#import "SYZHeaderView.h"

//得到屏幕height
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface SYZUserInfoOtherViewController ()
/**自定义TableHeaderView*/
@property (strong, nonatomic) SYZHeaderView *headerView;
@end

@implementation SYZUserInfoOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //根据需求设置header高度
    self.headerHeight = SCREEN_WIDTH *0.5 + 80;
    self.navigationController.navigationBar.translucent = YES;
    self.headerView = [[SYZHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headerHeight)];
    [self.tableView setTableHeaderView:self.headerView];
    //添加下拉放大
    self.headerManager = [SYZStretchableTableHeaderManager new];
    [self.headerManager stretchHeaderForTableView:self.tableView withView:self.headerView];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha = 0;
}

- (void)viewDidLayoutSubviews {
    [self.headerManager resizeView];
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self.headerManager scrollViewDidScroll:scrollView];
    
}

- (NSArray<NSString *> *)__sectionTitles {
    return @[@"动态",@"相册",@"视频",@"档案"];
}

- (NSArray<UIViewController *> *)__loadChildControllers {
    SYZListViewController* dynamicVC = [[SYZListViewController alloc] init];
    dynamicVC.sManager = self.pageManager;
    SYZListViewController* photoVC = [[SYZListViewController alloc] init];
    photoVC.sManager = self.pageManager;
    SYZListViewController* videoVC = [[SYZListViewController alloc] init];
    videoVC.sManager = self.pageManager;
    SYZListViewController* profileVC = [[SYZListViewController alloc] init];
    profileVC.sManager = self.pageManager;
    
    return @[dynamicVC,photoVC,videoVC,profileVC];
}



@end
