//
//  SYZUserInfoViewController.m
//  SYZScrollViewManager_Example
//
//  Created by LeeRay on 2018/11/18.
//  Copyright © 2018年 sundasheng1985. All rights reserved.
//

#import "SYZUserInfoViewController.h"
#import <Masonry/Masonry.h>
#import <SYZScrollViewManager/SYZScrollViewManager.h>
/**分页管理器*/
#import <SGPagingView/SGPagingView.h>
/**子控制器*/
#import "SYZListViewController.h"
#import "SYZHeaderView.h"

//得到屏幕height
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface SYZUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource, SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
/**管理器对象 这个在主控制器里进行声明*/
@property (strong, nonatomic) SYZMultipleScrollViewManager *syzManager;
/**uitableView 用MultipleGestureTableView是为了多手势支持，也可以不用*/
@property (strong, nonatomic) SYZMultipleBaseTableView *gestureTableView;
/**sectionHeaderView 用于放置UIPageViewController和分段管理器(就是子控制器顶部的按钮等)*/
@property (strong, nonatomic) UIView *kjView;
/**放置分段管理器(子控制器顶部的按钮等控件)*/
@property (strong, nonatomic) SGPageTitleView *sgTitleView;
/**分页控制器*/
@property (strong, nonatomic) SGPageContentScrollView *sgPageView;
/**放置所有的子控制器，用于在用户使用中途传值*/
@property (strong, nonatomic) NSArray *childArray;
/**自定义TableHeaderView*/
@property (strong, nonatomic) SYZHeaderView *headerView;
/**下拉放大的管理器*/
@property (strong, nonatomic) SYZStretchableTableHeaderManager *stretchableManager;
/** 表头高度 */
@property (nonatomic, assign) CGFloat headerHeight;
/** navbar和控制栏高度 */
@property (nonatomic, assign) CGFloat KNavHeight;
@end

@implementation SYZUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人主页";
    self.navigationController.navigationBar.translucent = YES;
    self.KNavHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    //基础控件
    self.gestureTableView = [[SYZMultipleBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.gestureTableView.delegate = self;
    self.gestureTableView.dataSource = self;
    [self.view addSubview:self.gestureTableView];
    if (@available(iOS 11.0,*)) {
        self.gestureTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.gestureTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //初始化多视图管理器
    self.syzManager = [SYZMultipleScrollViewManager new];
    //把滚动视图交给管理器
    [self.syzManager addMainView:self.gestureTableView];
    self.syzManager.mainOffsetY = SCREEN_WIDTH *0.5 + 80 - self.KNavHeight;
    //tableHeaderView 这个就是下拉放大的header
    self.headerHeight = SCREEN_WIDTH *0.5 + 80;
    self.headerView = [[SYZHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.5 + 80)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.gestureTableView setTableHeaderView:self.headerView];
    
    //创建子控制器
    [self loadChildVC];
    //初始化分页控制器
    [self loadPageView];
    //把header交给下拉放大管理器
    //下拉放大
    self.stretchableManager = [SYZStretchableTableHeaderManager new];
    [self.stretchableManager stretchHeaderForTableView:self.gestureTableView withView:self.headerView];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha = 0;
}

/**由于下拉放大必须实现，如果不需要下拉放大效果，这里可以不需要*/
- (void)viewDidLayoutSubviews {
    [self.stretchableManager resizeView];
}

/**这里由于下拉放大需要，如果不需要下拉放大效果，则可以不实现*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.stretchableManager scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y > 88) {
        if (scrollView.contentOffset.y/(self.headerHeight -self.KNavHeight) >= 1) {
            self.navigationController.navigationBar.alpha = 1.0;
        }else{
            self.navigationController.navigationBar.alpha = scrollView.contentOffset.y/(self.headerHeight -self.KNavHeight);
        }
    }
    else{
        self.navigationController.navigationBar.alpha = 0.0;
    }
    NSLog(@"透明度 === %.2f",(scrollView.contentOffset.y/(self.headerHeight -88) >= 1 ? 1 :scrollView.contentOffset.y/(self.headerHeight -88)));
    
    NSLog(@"偏移量 === %.2f",scrollView.contentOffset.y);
}

/**初始化分页控制器(PageViewController)*/
- (void)loadPageView {
    //titleView
    if (!self.sgTitleView) {
        SGPageTitleViewConfigure *config = [SGPageTitleViewConfigure new];
        
        self.sgTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)
                                                          delegate:self
                                                        titleNames:@[@"kjTitle0",@"kjTitle1",@"kjTitle2"]
                                                         configure:config];
        self.sgTitleView.backgroundColor = [UIColor whiteColor];
        [self.kjView addSubview:self.sgTitleView];
    }
    //contentView
    if (!self.sgPageView) {
        self.sgPageView = [SGPageContentScrollView pageContentScrollViewWithFrame:CGRectMake(0, 44.0 , SCREEN_WIDTH, SCREEN_HEIGHT-44 -self.KNavHeight)
                                                                         parentVC:self
                                                                         childVCs:self.childArray];
        self.sgPageView.delegatePageContentScrollView = self;
        [self.kjView addSubview:self.sgPageView];
        
        //因为分页管理器也是属于UIScrollView，也需要交给管理器来统一管理
        UIScrollView *sView = [self.sgPageView valueForKey:@"_scrollView"];
        [self.syzManager addMainRelevancyPageView:sView];
    }
    self.sgTitleView.selectedIndex = 0;
}

/**初始化子控制器*/
- (void)loadChildVC {
    SYZListViewController *kjvc_0 = [[SYZListViewController alloc] init];
    //这里可以进行首次传值，比如UIScrollView管理器对象 或者  其它的属性
    kjvc_0.sManager = self.syzManager;
    
    SYZListViewController *kjvc_1 = [[SYZListViewController alloc] init];
    //这里可以进行首次传值，比如UIScrollView管理器对象 或者  其它的属性
    kjvc_1.sManager = self.syzManager;
    
    SYZListViewController *kjvc_2 = [[SYZListViewController alloc] init];
    //这里可以进行首次传值，比如UIScrollView管理器对象 或者  其它的属性
    kjvc_2.sManager = self.syzManager;
    
    //可以有很多个子控制器 因为是demo 没有创建不同的控制器类 实际项目根据页面展示不同有多个控制器类
    
    //把子控制器都放入到数组，便于后续有什么需要传值的需求
    self.childArray = @[kjvc_0, kjvc_1, kjvc_2];
}


#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //这个header的高度就是放置xjView的，所以一般都是当前页面的高度，如果考虑导航栏和tabbar。那么要减去导航栏高度和tabbar的高度
    return SCREEN_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (!self.kjView) {
//        [self loadKjView];
//    }
    return self.kjView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - SGPageTitleViewDelegate
/**
 *  联动 pageContent 的方法
 *
 *  @param pageTitleView      SGPageTitleView
 *  @param selectedIndex      选中按钮的下标
 */
- (void)pageTitleView:(SGPageTitleView *)pageTitleView
        selectedIndex:(NSInteger)selectedIndex {
    [self.sgPageView setPageContentScrollViewCurrentIndex:selectedIndex];
}

#pragma mark - SGPageContentScrollViewDelegate
/**
 *  联动 SGPageTitleView 的方法
 *
 *  @param pageContentScrollView      SGPageContentScrollView
 *  @param progress                   SGPageContentScrollView 内部视图滚动时的偏移量
 *  @param originalIndex              原始视图所在下标
 *  @param targetIndex                目标视图所在下标
 */
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView
                     progress:(CGFloat)progress
                originalIndex:(NSInteger)originalIndex
                  targetIndex:(NSInteger)targetIndex {
    [self.sgTitleView setPageTitleViewWithProgress:progress
                                     originalIndex:originalIndex
                                       targetIndex:targetIndex];
}


- (UIView *)kjView{
    if (!_kjView) {
        //由于是放到sectionHeader上的 所以这里需要使用frame,一般这里的宽高就是屏幕的宽高，如果要考虑导航栏和tabbar的高度，这里的高度是要减去导航栏高度(64或88)和tabar的高度
        _kjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
    }
    return _kjView;
}

- (void)dealloc {
    /**需要销毁管理器的观察者*/
    if (self.syzManager) {
        [self.syzManager multipleManagerDealloc];
    }
}
@end
