//
//  Tools.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/26.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject
+(NSData *)imageToData:(UIImage *)img;

/** 打印字典 显示中文 */
+(void)LogWith:(NSObject *)param;

+(void)LogWith:(NSObject *)param WithTitle:(NSString *)title;

/** 根据文字获取 size  width为特定的宽  Height为特定的高  不确定高度 可以 MAXFLOAT */
+(CGSize)getStringRect:(NSString *)str FontSize:(CGFloat)size MaxWidth:(CGFloat)width MaxHeight:(CGFloat)height;

#pragma mark - 手机号码验证
+(BOOL) isValidateMobile:(NSString *)mobile;

+ (BOOL)isValidateIdentityCard: (NSString *)identityCard;

/** 判断输入的是否为金额 */
+(BOOL)isTheAmount:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
