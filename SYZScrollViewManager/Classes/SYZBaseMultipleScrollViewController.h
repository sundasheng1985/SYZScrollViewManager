//
//  SYZBaseMultipleScrollViewController.h
//  SYZScrollViewManager
//
//  Created by LeeRay on 2018/12/4.
//

#import <UIKit/UIKit.h>
#import <SYZScrollViewManager/SYZMultipleScrollViewManager.h>
#import <SYZScrollViewManager/SYZMultipleBaseTableView.h>
#import <SYZScrollViewManager/SYZStretchableTableHeaderManager.h>
/**分页管理器*/
#import <SGPagingView/SGPagingView.h>

@interface SYZBaseMultipleScrollViewController : UIViewController
/** 多视图管理类 */
@property (nonatomic, strong) SYZMultipleScrollViewManager * pageManager;
/** 基类 */
@property (nonatomic, strong) SYZMultipleBaseTableView * tableView;
/** 分页管理控件底部控件 */
@property (nonatomic, strong) UIView *secontionHeaderView;
/** 下拉放大管理器 */
@property (nonatomic, strong) SYZStretchableTableHeaderManager * headerManager;
/** 分享 */
@property (nonatomic, strong) UIButton *shareBtn;
/** 表头高度 */
@property (nonatomic, assign) CGFloat headerHeight;
/** navbar和控制栏高度 */
@property (nonatomic, assign) CGFloat KNavHeight;

#pragma mark - 子类重写
- (NSArray<NSString*>*)__sectionTitles;

- (NSArray<UIViewController*>*)__loadChildControllers;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end
