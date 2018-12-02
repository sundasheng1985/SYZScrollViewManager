//
//  SYZStretchableTableHeaderManager.h
//  SYZScrollViewManager
//
//  Created by LeeRay on 2018/12/2.
//

#import <Foundation/Foundation.h>
/** 下拉放大管理器 */
@interface SYZStretchableTableHeaderManager : NSObject
/** 主控件 */
@property (nonatomic,retain) UITableView* tableView;
/** header */
@property (nonatomic,retain) UIView* view;

/** 将header添加到tableview上 */
- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view;
/** 滚动事件 */
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
/** 重置frame */
- (void)resizeView;

@end
