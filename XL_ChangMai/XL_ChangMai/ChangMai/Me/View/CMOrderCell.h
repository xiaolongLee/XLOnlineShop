//
//  CMOrderCell.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMOrderCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *dict;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight:(NSDictionary *)dict;
/**
 *    支付block
 */
@property (nonatomic,copy) void(^payblock)(NSDictionary *);
/**
 *    收货
 */
@property (nonatomic,copy) void(^chargeblock)(NSDictionary *);
/** 取消订单 */
@property (nonatomic,copy) void(^cancleOrder)(NSDictionary *);
/** 删除订单 */
@property (nonatomic,copy) void(^deleteOrder)(NSDictionary *);
/** 申请退款 */
@property (nonatomic,copy) void(^blockRefund)(NSDictionary *);
/** 查看物流 */
@property (nonatomic,copy) void(^blockCheckInvoice)(NSDictionary *);

@end

NS_ASSUME_NONNULL_END
