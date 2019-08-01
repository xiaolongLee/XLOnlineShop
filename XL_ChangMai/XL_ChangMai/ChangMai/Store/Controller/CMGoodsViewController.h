//
//  CMGoodsViewController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/19.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMGoodsViewController : CMBaseViewController
/**  搜索关键词 */
@property (nonatomic,strong) NSString *searchKeyword;

/**  标题 */
@property (nonatomic,strong) NSString *producutTitle;

/**  小分类的编号，从门店小分类点进来之后传的 */
@property (nonatomic,assign) long long subcate;
/**  门店编号 */
@property(nonatomic,assign)long long storeId;

/**
 *  来源的途径
 参数二     is_best        int类型,如果是爆款，值为1    爆款
 参数三     is_new        int类型,如果是新品，值为1    新品
 参数四     is_hot        int类型,如果是热销，值为1    热销
 参数五     is_member    int类型,如果是会员专享，值为1    会员专享
 1.搜索关键词，或者点击热搜关键词，跳转过来
 2.点击小分类，跳转过来
 3.爆款
 4.新品
 5.热销
 6.会员专享
 */
@property (nonatomic,assign)int sourceType;
@end

NS_ASSUME_NONNULL_END
