//
//  ShoppingCarCell.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/1.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCarCell : UITableViewCell
/**  数据源 */
@property (nonatomic,strong) NSMutableDictionary *dataDict;
/**  选择商品更新购物车 */
@property (nonatomic,copy) void(^selectItem)(NSMutableDictionary *dataDict);
/**  更新购物车数量 */
@property (nonatomic,copy) void(^updateShoppingCar)(NSMutableDictionary *dataDict);
@end

NS_ASSUME_NONNULL_END
