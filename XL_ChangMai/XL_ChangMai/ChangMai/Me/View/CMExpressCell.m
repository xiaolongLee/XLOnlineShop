//
//  CMExpressCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMExpressCell.h"
#define iconW 15
@interface CMExpressCell()

@property (weak, nonatomic) UILabel *timeLabel;

@end
@implementation CMExpressCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CMExpressCell";
    CMExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CMExpressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


+ (CGFloat)cellHeight
{
    return 20 + iconW + 60;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        CGFloat margin = 20;
        
        CGFloat lineW = 3;
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(margin, 0, lineW, 20);
        line.backgroundColor = __kLineColor;
        [self.contentView addSubview:line];
        
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"express_icon"]];
        icon.frame = CGRectMake(line.centerX - iconW/2, line.bottom, iconW, iconW);
        [self.contentView addSubview:icon];
        
        
        UIView *line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(margin, icon.bottom, lineW, 60);
        line1.backgroundColor = __kLineColor;
        [self.contentView addSubview:line1];
        
        
        CGFloat labelW = (__kWindow_Width - margin - icon.right - 10);
        CGFloat labelH = 0;
        UIFont *labelFont = Font(15);
        UILabel *namelable = [[UILabel alloc] init];
        namelable.numberOfLines = 0;
        namelable.font = labelFont;
        namelable.textColor = [UIColor grayColor];
        namelable.frame = CGRectMake(icon.right + 10, icon.top, labelW, labelH);
        [self.contentView addSubview:namelable];
        self.timeLabel = namelable;
        
        
        // cell的设置
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    NSString *timeStr = [MyDate getDateWithTimeStamp:_dataDict[@"dateline"] WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *statusStr = _dataDict[@"status"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@",statusStr,timeStr];
    
    //    self.timeLabel.text = @"上海\n2017/02/15";
    
    CGFloat labelW = self.timeLabel.width;
    
    CGFloat timeLabelH = [self.timeLabel.text sizeWithFont:Font(15) maxW:labelW].height;
    
    self.timeLabel.height = timeLabelH;
    
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
