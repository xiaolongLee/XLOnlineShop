//
//  DiscoverCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/1.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "DiscoverCell.h"


@implementation DiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"cover"]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imagView.image = image;
    }];
    self.titleLabel.text = _dataDict[@"title"];
    self.detailLabel.text = _dataDict[@"content"];
}

@end
