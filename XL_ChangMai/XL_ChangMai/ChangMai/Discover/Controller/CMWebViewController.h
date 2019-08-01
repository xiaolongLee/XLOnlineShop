//
//  CMWebViewController.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/1.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMWebViewController : CMBaseViewController
/** webId */
@property (nonatomic,copy) NSNumber * webId;
/** urlStr */
@property (nonatomic,copy) NSString * webUrlStr;

/** webVcTitle */
@property (nonatomic,copy) NSString * webVcTitle;
@end

NS_ASSUME_NONNULL_END
