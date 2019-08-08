//
//  CMSettleViewController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/1.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMSettleViewController : CMBaseViewController
/**  1.商品详情直接购买 */
@property (nonatomic,assign) int sourceType;
/**  商品详情直接购买商品的ID */
@property (nonatomic,strong) NSString  *cart_Id;
/**  商品 */
@property (nonatomic,strong) NSArray *goodsArr;
/**  门店编号 */
@property(nonatomic,assign)long long storeId;
/**  门店地址 */
@property(nonatomic,assign)NSString *storeAddress;
@end

NS_ASSUME_NONNULL_END
