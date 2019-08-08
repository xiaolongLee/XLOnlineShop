//
//  CMGoCommentViewController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMGoCommentViewController : CMBaseViewController
@property(nonatomic,assign)long long goodId;
/**
 *    评价成功block
 */
@property (nonatomic,copy) void(^commentSuccessblock)();
@end

NS_ASSUME_NONNULL_END
