//
//  JNAskRecommendCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "JNAskRecommendCell.h"
@interface JNAskRecommendCell ()
/** 分类图片 */
@property (nonatomic,strong) UIImageView *categoryImage;
/** 分类名字 */
@property (nonatomic,strong) UILabel *categoryName;

@end
@implementation JNAskRecommendCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI
{
    _categoryImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    _categoryImage.contentMode = UIViewContentModeScaleAspectFill;
    _categoryImage.backgroundColor = [UIColor clearColor];
    _categoryImage.clipsToBounds = YES;
    //    _categoryImage.image = [UIImage imageNamed:@"prodcut_sort_pci3"];
    [self.contentView addSubview:_categoryImage];
    
    
    _categoryName = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_categoryImage.frame) + 5, self.frame.size.width, 30)];
    _categoryName.numberOfLines = 0;
    _categoryName.backgroundColor = [UIColor whiteColor];
    _categoryName.adjustsFontSizeToFitWidth = YES;
    _categoryName.font = Font(12);
    _categoryName.textColor = __kcolorText_Black;
    _categoryName.textAlignment = NSTextAlignmentCenter;
    //    _categoryName.text = @"S吗";
    [self.contentView addSubview:_categoryName];
}


- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    [self.categoryImage sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"cover"]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.categoryImage.image = image;
    }];
    
    self.categoryName.text = _dataDict[@"name"];
    
}
@end
