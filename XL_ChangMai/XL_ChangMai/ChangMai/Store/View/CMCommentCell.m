//
//  CMCommentCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMCommentCell.h"
#define imageHeight 40
#define labelH  30
#define imageW 80
#define vmargin 10
@interface CMCommentCell ()
{
    
}
@property (strong, nonatomic) UIImageView *imageViewHead;
@property (strong, nonatomic) UILabel *labeCommentName;
@property (strong, nonatomic) UILabel *labelCreateTime;
@property (strong, nonatomic) UILabel *labelCommentDetail;
@property (strong, nonatomic) UIView *imageContainer;


@end
@implementation CMCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CMCommentCell";
    CMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)cellHeightWith:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    _labelCommentDetail.text = _dataDict[@"content"];
    CGSize detailSize = [_labelCommentDetail sizeThatFits:CGSizeMake(_labelCommentDetail.width, MAXFLOAT)];
    NSArray *temp = _dataDict[@"images"];
    
    CGFloat cellH = 0.0f;
    
    if (temp.count) {
        cellH = labelH + detailSize.height + imageW + 2*vmargin;
    }else{
        cellH = labelH + detailSize.height + vmargin;
    }
    
    return cellH>imageHeight?cellH:imageHeight;
    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        
        CGFloat margin = 20;
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(margin, 5, imageHeight,imageHeight);
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        imgV.layer.cornerRadius = imageHeight/2;
        imgV.layer.masksToBounds = YES;
        //        imgV.image = [UIImage imageNamed:@"stores_pic1"];
        [self.contentView addSubview:imgV];
        self.imageViewHead = imgV;
        
        //    _imageViewHead.clipsToBounds = YES;
        [self.contentView addSubview:_imageViewHead];
        
        
        
        
        UIFont *labelFont = Font(15);
        
        
        _labeCommentName = [[UILabel alloc] init];
        _labeCommentName.font = labelFont;
        _labeCommentName.frame = CGRectMake(imgV.right + 10, 0, 200, labelH);
        [self.contentView addSubview:_labeCommentName];
        
        _labelCommentDetail = [[UILabel alloc] init];
        _labelCommentDetail.font = labelFont;
        _labelCommentDetail.numberOfLines = 0;
        _labelCommentDetail.frame = CGRectMake(_labeCommentName.left, _labeCommentName.bottom, __kWindow_Width - margin - _labeCommentName.left, 0);
        [self.contentView addSubview:_labelCommentDetail];
        
        
        
        _imageContainer = [[UIView alloc] init];
        _imageContainer.backgroundColor = [UIColor clearColor];
        _imageContainer.frame = CGRectMake(0, _labelCommentDetail.bottom + vmargin, __kWindow_Width, 0);
        [self.contentView addSubview:_imageContainer];
        
        
        
        
        CGFloat imageMargin = (__kWindow_Width - 3*imageW)/4;
        CGFloat imageX = imageMargin;
        CGFloat imageY = 0;
        
        
        
        for (int i = 0;i < 3;i++) {
            
            UIImageView *imageBtn = [[UIImageView alloc] init];
            imageBtn.layer.cornerRadius = 5;
            imageBtn.layer.masksToBounds = YES;
            imageBtn.backgroundColor = [UIColor whiteColor];
            imageBtn.tag = i + 100;
            imageBtn.userInteractionEnabled = YES;
            [imageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageBtnClick:)]];
            
            imageBtn.frame = CGRectMake(imageX, imageY, imageW, imageW);
            
            imageX = imageX + imageW + imageMargin;
            
            
            [_imageContainer addSubview:imageBtn];
            
        }
        
        // cell的设置
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    [self.imageViewHead sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"cover"]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.imageViewHead.image = image;
        }else{
            //            self.imageViewHead.image = [UIImage imageNamed:@"stores_pic1"];
        }
        
    }];
    
    _labeCommentName.text = [NSString stringWithFormat:@"%@",_dataDict[@"name"]];
    _labelCommentDetail.text = _dataDict[@"content"];
    [_labelCommentDetail sizeToFit];
    
    _imageContainer.top = _labelCommentDetail.bottom + vmargin;
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imaV = [_imageContainer viewWithTag:(100 + i)];
        if (imaV) {
            imaV.image = nil;
        }
    }
    
    if (![_dataDict[@"images"] isKindOfClass:[NSNull class]]) {
        NSArray *temp = _dataDict[@"images"];
        if (temp.count > 0) {
            for (int i = 0; i < temp.count; i++) {
                UIImageView *imaV = [_imageContainer viewWithTag:(100 + i)];
                if (imaV) {
                    [imaV sd_setImageWithURL:[NSURL URLWithString:temp[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        imaV.image = image;
                    }];
                }
            }
            _imageContainer.height = imageW;
        }else{
            _imageContainer.height = 0;
        }
    }else{
        _imageContainer.height = 0;
    }
    
}

- (void)imageBtnClick
{
    
}

@end
