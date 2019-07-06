//
//  UIButton+Extension.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/6.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extension)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (void)setDefaultStyle;
- (void)setDefaultSelectedStyle;
@end

NS_ASSUME_NONNULL_END
