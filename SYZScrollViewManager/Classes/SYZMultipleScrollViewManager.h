//
//  SYZMultipleScrollViewManager.h
//  SYZScrollViewManager
//
//  Created by LeeRay on 2018/12/2.
//

#import <Foundation/Foundation.h>

@interface SYZMultipleScrollViewManager : NSObject
/**设置主控制器关联的UIScrollView滑动到多少时，子控制器才允许滑动，
 如果不设置或者<=0，则默认主控制器关联的UIScrollView滑动到底部时子控制器开始滑动*/
@property (assign, nonatomic) CGFloat mainOffsetY;
// 判断是否显示滚动条，只需要在主控制器设置即可，子控制器不用设置 yes-不显示 NO-显示
@property (assign, nonatomic) BOOL scrollIndicator;

/**销毁 移除观察者*/
- (void)multipleManagerDealloc;

/** 告知子控制器关联的UIScrollView */
- (void)addChildView:(UIScrollView *)sView ;


/** 告知主控制器关联的UIScrollView */
- (void)addMainView:(UIScrollView *)sView;

/** 告知主控制器中的分页控制器，解决分页控制器和主控制器的UIScrollView同时滑动的问题 */
- (void)addMainRelevancyPageView:(UIScrollView *)sView;

@end
