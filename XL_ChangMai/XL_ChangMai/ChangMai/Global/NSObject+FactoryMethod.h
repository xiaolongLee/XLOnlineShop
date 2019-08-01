//
//  NSObject+FactoryMethod.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/22.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FactoryMethod)
-(BOOL) isValidateMobile:(NSString *)mobile;
- (UIImageView *)createArrowImageViewFrame:(CGRect)arrowFrame;
- (UITextField *)createDefaultStyleTextFieldFrame:(CGRect)fieldFrame;
- (UIButton *)createDefaultStyleButtonFrame:(CGRect)btnFrame cornerRadius:(CGFloat)btnRadius title:(NSString *)btnTitle;
- (UIView *)createDefaultStyleLineFrame:(CGRect)lineFrame;
-(void)alertWithMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
