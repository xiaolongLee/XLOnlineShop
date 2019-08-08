//
//  CMAddressCell.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMAddressCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;

/** 编辑地址 */
@property (nonatomic,copy) void(^editAddress)(NSDictionary *dataDict);
/** 删除地址 */
@property (nonatomic,copy) void(^deleteAddress)(NSDictionary *dataDict);
/** 设为默认地址 */
@property (nonatomic,copy) void(^setDefaultAddress)(NSDictionary *dataDict);

@end

NS_ASSUME_NONNULL_END
