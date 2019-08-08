//
//  CMAcountCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMAcountCell.h"
@interface CMAcountCell ()

@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UILabel *schemeLabel;

@property (weak, nonatomic) UILabel *amountLabel;


@end
@implementation CMAcountCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CMAcountCell";
    CMAcountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CMAcountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


+ (CGFloat)cellHeight
{
    return 40;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        CGFloat margin = 20;
        CGFloat labelW = (__kWindow_Width - 2*margin)/3;
        CGFloat labelH = 40;
        UIFont *labelFont = Font(15);
        UILabel *namelable = [[UILabel alloc] init];
        namelable.font = labelFont;
        namelable.frame = CGRectMake(margin, 0, labelW, labelH);
        self.timeLabel = namelable;
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.font = labelFont;
        phoneLabel.frame = CGRectMake(margin + labelW, 0, labelW, labelH);
        self.schemeLabel = phoneLabel;
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = labelFont;
        addressLabel.frame = CGRectMake(margin + 2*labelW, 0, labelW, labelH);
        self.amountLabel = addressLabel;
        
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.schemeLabel];
        [self.contentView addSubview:self.amountLabel];
        
        
        
        // cell的设置
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    //    self.timeLabel.text = @"2016-01-10";
    //    self.schemeLabel.text = @"充值";
    //    self.amountLabel.text = @"100";
    
    
    self.timeLabel.text = [MyDate getDateWithTimeStamp:_dataDict[@"dateline"]];
    self.schemeLabel.text = _dataDict[@"type"];
    self.amountLabel.text = [NSString stringWithFormat:@"¥%@",_dataDict[@"score"]];
}


@end
