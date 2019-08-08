//
//  CMAddressListViewController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/2.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMAddressListViewController : CMBaseViewController
/** 结算 */
@property (nonatomic,assign) BOOL  isSettlement;
/** 结算block */
@property (nonatomic,copy) void(^settlementBlock)(NSDictionary *);
@end

NS_ASSUME_NONNULL_END
