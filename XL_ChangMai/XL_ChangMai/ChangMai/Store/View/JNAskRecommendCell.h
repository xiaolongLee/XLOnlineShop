//
//  JNAskRecommendCell.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JNAskRecommendCell : UICollectionViewCell
//分类数据
//@property(nonatomic,strong)JNThirdCategoryDetailModel *thirdCategoryDetailModel;
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;@end

NS_ASSUME_NONNULL_END
