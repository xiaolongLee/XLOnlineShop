//
//  CMHomeImageCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/19.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMHomeImageCell.h"
#define margin 5

@interface  CMHomeImageCell ()

/** 大照片 */
@property (weak, nonatomic) UIButton *bigButton;
/** 照片 */
@property (weak, nonatomic) UIButton *btn1;
/** 照片 */
@property (weak, nonatomic) UIButton *btn2;
/** 照片 */
@property (weak, nonatomic) UIButton *btn3;

@end

@implementation CMHomeImageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CMHomeImageCell";
    CMHomeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CMHomeImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)cellHeight
{
    return 143 + margin + 89 + margin;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        UIButton *bigBtn = [self createButtonWithFrame:CGRectMake(0, 0, __kWindow_Width, 143)];
        [bigBtn setImage:[UIImage imageNamed:@"h_news_porduct_pic1"] forState:UIControlStateNormal];
        [bigBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bigBtn];
        self.bigButton = bigBtn;
        
        CGFloat btnW = (__kWindow_Width - 4*margin)/3;
        UIButton *btn1 = [self createButtonWithFrame:CGRectMake(margin, _bigButton.bottom + margin, btnW, 89)];
        [btn1 setImage:[UIImage imageNamed:@"h_news_porduct_pic2"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn1];
        self.btn1 = btn1;
        
        UIButton *btn2 = [self createButtonWithFrame:CGRectMake(margin*2 + btnW , _bigButton.bottom + margin, btnW, 89)];
        [btn2 setImage:[UIImage imageNamed:@"h_news_porduct_pic2"] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn2];
        self.btn2 = btn2;
        
        UIButton *btn3 = [self createButtonWithFrame:CGRectMake(margin*3 + btnW*2, _bigButton.bottom + margin, btnW, 89)];
        [btn3 setImage:[UIImage imageNamed:@"h_news_porduct_pic2"] forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn3];
        self.btn3 = btn3;
        
        // cell的设置
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (UIButton *)createButtonWithFrame:(CGRect)btnFrame
{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    
    return btn;
}

- (void)setDataDict:(NSDictionary *)dataDict {
    
    _dataDict = dataDict;
    [self.bigButton sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"web_new_1"]] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self.bigButton setImage:image forState:UIControlStateNormal];
    }];
    
    [self.btn1 sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"web_new_2"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.bigButton setImage:image forState:UIControlStateNormal];
    }];
    
    [self.btn2 sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"web_new_3"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.bigButton setImage:image forState:UIControlStateNormal];
    }];
    
    [self.btn3 sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"web_new_4"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.bigButton setImage:image forState:UIControlStateNormal];
    }];
}

- (void)btnClick:(UIButton *)sender {
    if (self.pictureClickblock) {
        _pictureClickblock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
