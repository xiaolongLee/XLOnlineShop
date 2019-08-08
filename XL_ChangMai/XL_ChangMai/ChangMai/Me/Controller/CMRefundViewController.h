//
//  CMRefundViewController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMRefundViewController : CMBaseViewController
// 订单编号
@property (nonatomic,strong) NSString *soNo;
//1,退款，2退货
@property (nonatomic,assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
