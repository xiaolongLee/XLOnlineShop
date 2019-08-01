//
//  CMHomeImageCell.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/19.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMHomeImageCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
/**  数据源 */
@property (nonatomic,copy) NSDictionary *dataDict;
/**
 *    图片点击
 */
@property (nonatomic,copy) void(^pictureClickblock)(void);

@end

NS_ASSUME_NONNULL_END
