//
//  CMHotCellView.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/16.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMHotCellView.h"
@interface CMHotCellView ()
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *descrLabel;

@property(nonatomic,strong)UIImageView *imageV;
@end
@implementation CMHotCellView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI{
    
    /** 标题 */
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"热销品牌";
    /** adjustsFontSizeToFitWidth这个属性的意思是根据UILabel的宽度来自动适应字体大小，但要注意的是，这个属性不会让字体变大，只会缩小，所以开始的时候，可以设置字体fontSize大一点。
     */
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.textColor = __kGreen_Color;
    _titleLabel.font = Font(17);
    
    /** 描述 */
    _descrLabel = [[UILabel alloc]init];
    _descrLabel.text = @"全场一折";
    _descrLabel.adjustsFontSizeToFitWidth = YES;
    _descrLabel.font = Font(14);
    
    /** 图片 */
    _imageV = [[UIImageView alloc] init];
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    _imageV.userInteractionEnabled = YES;
    _imageV.image = [UIImage imageNamed:@"home_pic1"];
    
    [self sd_addSubviews:@[_titleLabel, _descrLabel, _imageV]];
    
    
    CGFloat margin = 20;
    
    _titleLabel.sd_layout.leftSpaceToView(self, margin).topEqualToView(self).heightIs(40).widthRatioToView(self, 0.5);
    
    _descrLabel.sd_layout.leftSpaceToView(self, margin).topSpaceToView(_titleLabel, -5).widthRatioToView(_titleLabel, 1).heightIs(30);
    
    _imageV.sd_layout
    .rightSpaceToView(self, 0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .widthRatioToView(self, 0.5);
    
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClick)]];
}


- (void)setDataDict:(NSDictionary *)dataDict {
    
     _dataDict = dataDict;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"web_best"]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.imageV.image = image;
    }];
}

- (void)pictureClick{
    if (self.pictureClickblock) {
        _pictureClickblock();
    }
}

- (void)setType:(NSInteger)type {
    _type = type;
    
    if (type == 1 ) {
        _titleLabel.text = @"热销品牌";
        _descrLabel.text = @"全场一折";
    }else if (type == 2){
        _titleLabel.text = @"爆款商品";
        _descrLabel.text = @"销售爆款";
    }
}
    
    

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
