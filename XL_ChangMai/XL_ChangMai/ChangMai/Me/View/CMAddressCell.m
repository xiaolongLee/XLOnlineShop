//
//  CMAddressCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMAddressCell.h"
#define labelH 25
#define topMargin 5
@interface CMAddressCell ()

/** 大照片 */
@property (weak, nonatomic) UILabel *nameLabel;
/** 照片 */
@property (weak, nonatomic) UILabel *phoneLabel;
/** 照片 */
@property (weak, nonatomic) UILabel *addressLabel;
/** 照片 */
@property (weak, nonatomic) UILabel *defaultAddressLabel;
/** 照片 */
@property (weak, nonatomic) UIButton *defaultAddressBtn;
/** 照片 */
@property (weak, nonatomic) UIButton *deleteBtn;

@property (weak, nonatomic) UIButton *editBtn;

@end
@implementation CMAddressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CMAddressCell";
    CMAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CMAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)cellHeight
{
    return labelH*3 + 40 + topMargin*2;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        
        UIFont *labelFont = Font(13);
        UILabel *namelable = [[UILabel alloc] init];
        namelable.font = labelFont;
        self.nameLabel = namelable;
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.font = labelFont;
        self.phoneLabel = phoneLabel;
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = labelFont;
        self.addressLabel = addressLabel;
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = __kContentBgColor;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = __kLineColor;
        
        UIFont *btnFont = Font(14);
        UIButton *defaultAddressBtn = [[UIButton alloc] init];
        [defaultAddressBtn setImage:[UIImage imageNamed:@"radio_icon"] forState:UIControlStateNormal];
        [defaultAddressBtn setImage:[UIImage imageNamed:@"radio_icon_now"] forState:UIControlStateSelected];
        [defaultAddressBtn addTarget:self action:@selector(defaultAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.defaultAddressBtn = defaultAddressBtn;
        
        
        UILabel *defaultAddressLabel = [[UILabel alloc] init];
        defaultAddressLabel.font = btnFont;
        defaultAddressLabel.textColor = [UIColor lightGrayColor];
        self.defaultAddressLabel = defaultAddressLabel;
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.titleLabel.font = btnFont;
        [deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        [deleteBtn setTitle:@" 删除" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.deleteBtn = deleteBtn;
        
        UIButton *editBtn = [[UIButton alloc] init];
        editBtn.titleLabel.font = btnFont;
        [editBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
        [editBtn setTitle:@" 编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.editBtn = editBtn;
        
        [bottomView sd_addSubviews:@[line, _defaultAddressBtn,_defaultAddressLabel, _deleteBtn,_editBtn]];
        
        [self sd_addSubviews:@[_nameLabel, _phoneLabel, _addressLabel,bottomView]];
        
        
        CGFloat margin = 10;
        _nameLabel.sd_layout
        .leftSpaceToView(self, margin)
        .topSpaceToView(self,topMargin)
        .heightIs(labelH)
        .rightSpaceToView(self,margin);
        
        _phoneLabel.sd_layout
        .leftSpaceToView(self, margin)
        .topSpaceToView(_nameLabel,0)
        .heightIs(labelH)
        .rightSpaceToView(self,margin);
        
        _addressLabel.sd_layout
        .leftSpaceToView(self, margin)
        .topSpaceToView(_phoneLabel,0)
        .heightIs(labelH)
        .rightSpaceToView(self,margin);
        
        bottomView.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(_addressLabel,topMargin)
        .heightIs(40)
        .rightSpaceToView(self,0);
        
        line.sd_layout
        .leftSpaceToView(bottomView, 0)
        .topSpaceToView(bottomView,0)
        .heightIs(__kLine_Width_Height)
        .rightSpaceToView(bottomView,0);
        
        _defaultAddressBtn.sd_layout
        .leftSpaceToView(bottomView, margin)
        .topSpaceToView(bottomView,0)
        .heightRatioToView(bottomView,1)
        .widthIs(25);
        
        _defaultAddressLabel.sd_layout
        .leftSpaceToView(_defaultAddressBtn, 0)
        .topSpaceToView(bottomView,0)
        .heightRatioToView(bottomView,1)
        .widthIs(130);
        
        CGFloat btnW = 60;
        _editBtn.sd_layout
        .rightSpaceToView(bottomView, margin)
        .topSpaceToView(bottomView,0)
        .heightRatioToView(bottomView,1)
        .widthIs(btnW);
        
        _deleteBtn.sd_layout
        .rightSpaceToView(bottomView, 3+btnW)
        .topSpaceToView(bottomView,0)
        .heightRatioToView(bottomView,1)
        .widthIs(btnW);
        
        // cell的设置
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    //    self.nameLabel.text = @"联  系  人: 张全蛋";
    //    self.phoneLabel.text = @"收货地址: 198998q398923";
    //    self.addressLabel.text = @"收货地址: 上海市店铺定2030号阿斯顿了";
    //    self.defaultAddressLabel.text = @"设置为默认地址";
    //        self.defaultAddressBtn.selected = YES;
    
    
    self.nameLabel.text = [NSString stringWithFormat:@"联  系  人: %@",_dataDict[@"name"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话: %@",_dataDict[@"phone"]];
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址: %@",_dataDict[@"address"]];
    
    if (![_dataDict[@"is_default"] intValue]) {
        self.defaultAddressLabel.text = @"设置为默认地址";
        self.defaultAddressBtn.selected = NO;
    }else{
        self.defaultAddressLabel.text = @"默认地址";
        self.defaultAddressBtn.selected = YES;
    }
    
    
}



-(void)defaultAddressBtnClick:(UIButton *)sender
{
    if (_setDefaultAddress) {
        _setDefaultAddress(self.dataDict);
    }
}

-(void)editBtnClick:(UIButton *)sender
{
    if (_editAddress) {
        _editAddress(self.dataDict);
    }
}


-(void)deleteBtnClick:(UIButton *)sender
{
    if (_deleteAddress) {
        _deleteAddress(self.dataDict);
    }
}


@end
