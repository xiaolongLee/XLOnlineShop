//
//  MeCellButton.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "MeCellButton.h"
#define KSImageScale 0.66666
@implementation MeCellButton
#pragma mark - 设置按钮内部图片和文字的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat H = contentRect.size.height*KSImageScale;
    return CGRectMake(0, 0, W, H);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat H = contentRect.size.height*(1 - KSImageScale);
    CGFloat y = contentRect.size.height - H;
    return CGRectMake(0, y - 5, W, H);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
