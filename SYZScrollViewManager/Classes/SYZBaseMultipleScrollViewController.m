//
//  SYZBaseMultipleScrollViewController.m
//  SYZScrollViewManager
//
//  Created by LeeRay on 2018/12/4.
//

#import "SYZBaseMultipleScrollViewController.h"
#import <Masonry/Masonry.h>

//得到屏幕height
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface SYZBaseMultipleScrollViewController ()<
SGPageTitleViewDelegate,
SGPageContentScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
/** 分页控制器 */
@property (nonatomic,strong) SGPageContentScrollView* pageView;
/** 分页控制器表头 */
@property (nonatomic,strong) SGPageTitleView* titlesView;
/** nav底色 */
@property (nonatomic, strong) UIView *navView;
@end

@implementation SYZBaseMultipleScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _renderUI];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)_renderUI {
    //安全区域和navbar的高度
    self.KNavHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.tableView = [[SYZMultipleBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
    self.pageManager = [[SYZMultipleScrollViewManager alloc] init];
    [self.pageManager addMainView:self.tableView];
    self.secontionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self __loadChildControllers];
    [self _loadPageViews];
    //设置默认偏移量
    self.pageManager.mainOffsetY = SCREEN_WIDTH*0.6 - self.KNavHeight;
    self.headerHeight = SCREEN_WIDTH*0.6;
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.navigationController.navigationBar.frame.size.height + 20)];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    if (self.tableView.contentOffset.y > self.KNavHeight && self.headerHeight > self.KNavHeight) {
        if (self.tableView.contentOffset.y/(self.headerHeight -self.KNavHeight) >= 1) {
            [self _setNavigationBarBackgroundImageWithcomponent:1];
        }else{
            [self _setNavigationBarBackgroundImageWithcomponent:self.tableView.contentOffset.y/(self.headerHeight -self.KNavHeight)];
        }
    }
    else{
        [self _setNavigationBarBackgroundImageWithcomponent:0];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareBtn];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self _setNavigationBarBackgroundImageWithcomponent:1];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > self.KNavHeight) {
        if (scrollView.contentOffset.y/(self.headerHeight -self.KNavHeight) >= 1) {
            [self _setNavigationBarBackgroundImageWithcomponent:1];
        }else{
            [self _setNavigationBarBackgroundImageWithcomponent:self.tableView.contentOffset.y/(self.headerHeight -self.KNavHeight)];
        }
    }
    else{
        [self _setNavigationBarBackgroundImageWithcomponent:0];
    }
}

- (void)_setNavigationBarBackgroundImageWithcomponent:(CGFloat)component{
    UIImage *image;
    image = [self imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:component]];
//    self.navView.alpha = component;
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
}

-(UIImage *)createImageColor:(UIColor *)color size:(CGSize)size {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //绘制颜色区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [color setFill];
    [path fill];
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (NSArray<UIViewController *> *)__loadChildControllers {
    return nil;
}

- (NSArray<NSString *> *)__sectionTitles {
    return nil;
}

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
    return SCREEN_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.secontionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.titlesView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

#pragma mark - Private
- (void)_loadPageViews {
    SGPageTitleViewConfigure* config = [SGPageTitleViewConfigure new];
    config.bottomSeparatorColor = [UIColor whiteColor];
    config.titleFont = [UIFont systemFontOfSize:17];
    config.titleSelectedFont = [UIFont systemFontOfSize:17];
    config.titleColor = [UIColor lightGrayColor];
    config.titleSelectedColor = [UIColor blackColor];
    config.indicatorColor = [UIColor blackColor];
    config.indicatorHeight = 4;
    config.indicatorCornerRadius = 2;
    CGRect titleFrame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0);
    self.titlesView = [SGPageTitleView pageTitleViewWithFrame:titleFrame
                                                     delegate:self
                                                   titleNames:[self __sectionTitles]
                                                    configure:config];
    self.titlesView.backgroundColor = [UIColor whiteColor];
    [self.secontionHeaderView addSubview:self.titlesView];
    
    CGRect pageFrame = CGRectMake(0, 44.0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    self.pageView = [SGPageContentScrollView pageContentScrollViewWithFrame:pageFrame
                                                                   parentVC:self childVCs:[self __loadChildControllers]];
    self.pageView.delegatePageContentScrollView = self;
    [self.secontionHeaderView addSubview:self.pageView];
    
    UIScrollView* sView = [self.pageView valueForKey:@"_scrollView"];
    [self.pageManager addMainRelevancyPageView:sView];
    
    self.titlesView.selectedIndex = 0;
}

- (SYZStretchableTableHeaderManager *)headerManager{
    if (!_headerManager) {
        _headerManager = [SYZStretchableTableHeaderManager new];
    }
    return _headerManager;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(SCREEN_WIDTH - 20 -13, [[UIApplication sharedApplication] statusBarFrame].size.height + 13, 20, 20);
        [_shareBtn setTitle:@"..." forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (void)dealloc {
    if (self.pageManager) {
        [self.pageManager multipleManagerDealloc];
    }
}



@end
