//
//  ShoppingCarCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/1.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "ShoppingCarCell.h"

@interface ShoppingCarCell()
@property (weak, nonatomic) IBOutlet UIButton *buttonSelect;
@property (weak, nonatomic) IBOutlet UIImageView *ImageGoods;
@property (weak, nonatomic) IBOutlet UILabel *LabelGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *LabelCount;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;

@end

@implementation ShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.addBtn.layer.borderColor = __kLineColor.CGColor;
    self.addBtn.layer.borderWidth = 1;
    [self.addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.cutBtn.layer.borderColor = __kLineColor.CGColor;
    self.cutBtn.layer.borderWidth = 1;
    [self.cutBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = __kLineColor;
    line.frame = CGRectMake(0, 0, self.LabelCount.width, 1);
    [self.LabelCount addSubview:line];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = __kLineColor;
    line1.frame = CGRectMake(0, self.LabelCount.height - 1, self.LabelCount.width, 1);
    [self.LabelCount addSubview:line1];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = __kLineColor;
    line2.frame = CGRectMake(0, self.height - __kLine_Width_Height, __kWindow_Width, __kLine_Width_Height);
    [self.contentView addSubview:line2];
}

- (void)setDataDict:(NSMutableDictionary *)dataDict
{
    _dataDict = dataDict;
    [self.ImageGoods sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"cover"]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.ImageGoods.image = image;
    }];
    
    self.LabelGoodsName.text = _dataDict[@"title"];
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",_dataDict[@"pay_amount"]];
    self.LabelCount.text = [NSString stringWithFormat:@"%@",_dataDict[@"good_number"]];
    
    
    if ([_dataDict[@"good_number"] intValue]== 1) {
        _cutBtn.userInteractionEnabled = NO;
        _cutBtn.alpha = 0.5;
    }
    
    self.buttonSelect.selected = [_dataDict[@"selected"] boolValue];
    
}




- (IBAction)selectItem:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    BOOL select = ![_dataDict[@"selected"] boolValue];
    [_dataDict setObject:@(select) forKey:@"selected"];
    
    //    NSLog(@"%d",sender.isSelected);
    //    NSLog(@"%d",_shoppingModel.isSelect);
    
    if (_selectItem) {
        _selectItem(_dataDict);
    }
    
    
}
- (IBAction)addGoods:(UIButton *)sender {
    NSInteger count = (long)[_dataDict[@"good_number"] integerValue];
    count ++;
    [_dataDict setObject:@(count) forKey:@"good_number"];
    
    
    /** 更新新购物车 */
    if (_updateShoppingCar) {
        _updateShoppingCar(_dataDict);
    }
    
    if (_selectItem) {
        _selectItem(_dataDict);
    }
    
    
    _cutBtn.userInteractionEnabled = YES;
    _cutBtn.alpha = 1.0;
}

- (IBAction)CutGoods:(UIButton *)sender {
    
    NSInteger count = (long)[_dataDict[@"good_number"] integerValue];
    if (count > 1) {
        count --;
        
        if (count == 1) {
            _cutBtn.userInteractionEnabled = NO;
            _cutBtn.alpha = 0.5;
        }
        
        [_dataDict setObject:@(count) forKey:@"good_number"];
        
        /** 更新购物车 */
        if (_updateShoppingCar) {
            _updateShoppingCar(_dataDict);
        }
        
        
        if (_selectItem) {
            _selectItem(_dataDict);
        }
        
        
    }else{
        _cutBtn.userInteractionEnabled = NO;
        _cutBtn.alpha = 0.5;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
