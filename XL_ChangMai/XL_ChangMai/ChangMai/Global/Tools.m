//
//  Tools.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/26.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "Tools.h"

@implementation Tools
+(NSData *)imageToData:(UIImage *)img
{
    /** 对图片进行压缩 */
    NSData *data = UIImageJPEGRepresentation(img, 0.3);//0.3
    if (!data) {
        
        NSLog(@"---- png --- ");
        data = UIImagePNGRepresentation(img);
    }
    return data;
}

+(void)LogWith:(NSObject *)param
{
    [self LogWith:param WithTitle:@""];
}

+(void)LogWith:(NSObject *)param WithTitle:(NSString *)title
{
    //    NSError *parseError = nil;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&parseError];
    //    NSLog(@",%@%@", title,[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}

+(CGSize)getStringRect:(NSString *)str FontSize:(CGFloat)size MaxWidth:(CGFloat)width MaxHeight:(CGFloat)height
{
    NSDictionary *fontDic = @{NSFontAttributeName:Font(size)};
    CGRect fontRect = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic context:nil];
    return fontRect.size;
}

#pragma mark - 手机号码验证
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

//身份证号
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/** 判断输入的是否为金额 */
+(BOOL)isTheAmount:(NSString *)string
{
    //用来判断该字符串是否全是数字
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet                                      characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSRange foundRange = [string rangeOfCharacterFromSet:disallowedCharacters];
    if( foundRange.location != NSNotFound){
        return NO;
    }else
        return YES;
}
@end
