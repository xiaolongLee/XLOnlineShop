//
//  CMTabBarController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/4.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMTabBarController : UITabBarController
- (void)updateTabNavigationRootController:(UINavigationController *)vController;
- (void)pushOrderDetailViewController:(NSString *)orderId;

/**  记录订单id，支付回调，跳转到订单详情 */
@property(nonatomic,copy)NSString *orderNO;
@end

NS_ASSUME_NONNULL_END
