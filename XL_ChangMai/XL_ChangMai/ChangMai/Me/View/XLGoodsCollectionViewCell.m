//
//  XLGoodsCollectionViewCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/12.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "XLGoodsCollectionViewCell.h"

@interface XLGoodsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageGoods;

@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@property (weak, nonatomic) IBOutlet UILabel *labelName;


@end

@implementation XLGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    
    [self.imageGoods sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"cover"]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.imageGoods.image = image;
    }];
    self.labelName.text = _dataDict[@"title"];
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",_dataDict[@"pay_amount"]];
    
    
}

@end
