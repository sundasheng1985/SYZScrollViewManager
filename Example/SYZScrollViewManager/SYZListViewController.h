//
//  SYZListViewController.h
//  SYZScrollViewManager_Example
//
//  Created by LeeRay on 2018/11/18.
//  Copyright © 2018年 sundasheng1985. All rights reserved.
//

#import <UIKit/UIKit.h>
/**管理器*/
#import <SYZScrollViewManager/SYZMultipleScrollViewManager.h>
@interface SYZListViewController : UIViewController

/**子控制器该属性由主控制器传值过来*/
@property (strong, nonatomic) SYZMultipleScrollViewManager *sManager;
@end
