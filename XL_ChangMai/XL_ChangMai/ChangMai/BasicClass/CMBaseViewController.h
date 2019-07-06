//
//  CMBaseViewController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/4.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
/** 根据类型创建tableview */
- (void)createTableViewFrame:(CGRect)tableViewFrame Style:(UITableViewStyle)tableViewStyle;
@end

NS_ASSUME_NONNULL_END
