//
//  SYZStretchableTableHeaderManager.m
//  SYZScrollViewManager
//
//  Created by LeeRay on 2018/12/2.
//

#import "SYZStretchableTableHeaderManager.h"

@interface SYZStretchableTableHeaderManager()
{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}
@end

@implementation SYZStretchableTableHeaderManager
@synthesize tableView = _tableView;
@synthesize view = _view;

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view{
    _tableView = tableView;
    _view = view;
    
    initialFrame       = _view.frame;
    defaultViewHeight  = initialFrame.size.height;
    
    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    _tableView.tableHeaderView = emptyTableHeaderView;
    
    [emptyTableHeaderView addSubview:_view];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    CGRect f = _view.frame;
    f.size.width = _tableView.frame.size.width;
    _view.frame = f;
    
    if(scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        initialFrame.origin.y = offsetY * -1;
        initialFrame.size.height = defaultViewHeight + offsetY;
        _view.frame = initialFrame;
    }
}

- (void)resizeView{
    initialFrame.size.width = _tableView.frame.size.width;
    _view.frame = initialFrame;
}

@end
