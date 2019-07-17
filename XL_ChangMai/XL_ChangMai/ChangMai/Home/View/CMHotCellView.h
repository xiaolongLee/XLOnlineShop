//
//  CMHotCellView.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/16.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMHotCellView : UIView
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;
/**
 *    图片点击
 */
@property (nonatomic,copy) void(^pictureClickblock)(void);

@property (nonatomic,assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
