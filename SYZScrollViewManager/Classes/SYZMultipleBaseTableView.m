//
//  SYZMultipleBaseTableView.m
//  SYZScrollViewManager
//
//  Created by LeeRay on 2018/12/2.
//

#import "SYZMultipleBaseTableView.h"

@implementation SYZMultipleBaseTableView

/**允许多个手势共同识别*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
