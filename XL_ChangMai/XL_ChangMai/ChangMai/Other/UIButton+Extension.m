//
//  UIButton+Extension.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/6.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}
- (void)setDefaultStyle{
    
    self.layer.cornerRadius = __kCORNERRADIUS_BUTTON;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = __kThemeColor.CGColor;
    self.layer.borderWidth = 1;
    self.titleLabel.font = Font(14);
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.adjustsImageWhenHighlighted = NO;
    
}
- (void)setDefaultSelectedStyle{
    self.layer.cornerRadius = __kCORNERRADIUS_BUTTON;
    self.layer.masksToBounds = YES;
    self.titleLabel.font = Font(14);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
    self.adjustsImageWhenHighlighted = NO;
}
@end
