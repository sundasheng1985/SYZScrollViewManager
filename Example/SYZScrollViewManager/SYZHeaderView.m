//
//  SYZHeaderView.m
//  SYZScrollViewManager_Example
//
//  Created by LeeRay on 2018/11/18.
//  Copyright © 2018年 sundasheng1985. All rights reserved.
//

#import "SYZHeaderView.h"
#import <Masonry/Masonry.h>

@interface SYZHeaderView()<UITableViewDelegate,UITableViewDataSource>
/** 图片 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 列表 */
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation SYZHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconImageView];
        [self addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.height.mas_offset(44*2);
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_offset(0);
            make.bottom.mas_offset(-44*2 +8);
        }];
        
        self.tableview.frame = CGRectMake(0, self.frame.size.height - 44*2, self.frame.size.width, 44*2);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.tableview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.tableview.bounds;
        maskLayer.path = maskPath.CGPath;
        self.tableview.layer.mask = maskLayer;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"啦啦啦啦啦啦啦啦";
    return cell;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bh_1"]];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
//        _tableview.layer.cornerRadius = 10;
        _tableview.clipsToBounds = YES;
    }
    return _tableview;
}


@end
