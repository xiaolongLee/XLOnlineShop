//
//  NSObject+FactoryMethod.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/22.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "NSObject+FactoryMethod.h"

@implementation NSObject (FactoryMethod)
#pragma mark - 手机号码验证
-(BOOL) isValidateMobile:(NSString *)mobile{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (UIImageView *)createArrowImageViewFrame:(CGRect)arrowFrame{
    UIImageView *arrowImageV = [[UIImageView alloc] init];
    arrowImageV.backgroundColor = [UIColor clearColor];
    arrowImageV.userInteractionEnabled = YES;
    arrowImageV.image = [UIImage imageNamed:@"all_arrow"];
    arrowImageV.frame = arrowFrame;
    arrowImageV.contentMode = UIViewContentModeScaleAspectFit;
    return arrowImageV;
}

- (UITextField *)createDefaultStyleTextFieldFrame:(CGRect)fieldFrame{
    UITextField *textF = [[UITextField alloc]  init];
    textF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, __kTextField_Height)];
    textF.leftViewMode = UITextFieldViewModeAlways;
    textF.backgroundColor = [UIColor whiteColor];
    textF.font = Font(15);
    textF.layer.borderWidth = 1;
    textF.layer.borderColor = __kLineColor.CGColor;
    textF.frame = fieldFrame;
    return textF;
}

- (UIButton *)createDefaultStyleButtonFrame:(CGRect)btnFrame cornerRadius:(CGFloat)btnRadius title:(NSString *)btnTitle{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = btnFrame;
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = Font(15);
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = __kThemeColor.CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btnRadius;
    return btn;
}

- (UIView *)createDefaultStyleLineFrame:(CGRect)lineFrame
{
    UIView *line = [[UIView alloc] init];
    line.frame = lineFrame;
    line.backgroundColor = __kLineColor;
    return line;
}

-(void)alertWithMessage:(NSString *)message
{
//    [MessageAlertView showWithMessage:message];
    
}

@end
