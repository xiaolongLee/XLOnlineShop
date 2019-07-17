//
//  CMStoreCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/17.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMStoreCell.h"
#define imageHeight 130
@interface CMStoreCell ()
/** 门店名字 */
@property (weak, nonatomic) UILabel *titleLabel;
/** 门店照片 */
@property (weak, nonatomic) UIImageView *imgView;
@end
@implementation CMStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CMStoreCell";
    CMStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CMStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)cellHeight {
     return imageHeight + 10;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        
        
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(__kScreenMargin, 0, __kWindow_Width - 2*__kScreenMargin,imageHeight);
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        imgV.image = [UIImage imageNamed:@"stores_pic1"];
        [self.contentView addSubview:imgV];
        self.imgView = imgV;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = CGRectMake(imgV.left, imgV.top,imgV.width, 50);
        titleLabel.backgroundColor = __kColorR_G_B_A(0, 0, 0, 0.7);
        titleLabel.text = @"人民广场店\n南京东路";
        titleLabel.numberOfLines = 2;
        titleLabel.font = Font(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        // cell的设置
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"cover"]] placeholderImage:[UIImage imageNamed:@"stores_pic1"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.imgView.image = image;
        }else{
            self.imgView.image = [UIImage imageNamed:@"stores_pic1"];
        }
    }];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",_dataDict[@"title"],_dataDict[@"address"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
