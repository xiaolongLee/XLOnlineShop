//
//  NSString+Extension.h
//  01-QQ聊天布局
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH;

- (CGSize)sizeWithFont:(UIFont *)font;

- (NSString *)md5;

+ (NSAttributedString *)getAttributedText:(NSString *)text SpecialText:(NSString *)specialText Font:(UIFont *)font Color:(UIColor *)textColor;

@end
