//
//  CMToPayViewController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMToPayViewController : CMBaseViewController
// 立即支付 订单编号
@property (nonatomic,strong) NSString *soNo;
/** 总金额 */
@property (nonatomic,strong) NSString * totalPrice;
@end

NS_ASSUME_NONNULL_END
