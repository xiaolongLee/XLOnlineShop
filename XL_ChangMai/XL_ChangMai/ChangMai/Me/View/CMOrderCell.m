//
//  CMOrderCell.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMOrderCell.h"
#define productCellH 90
#define textFont Font(13)
#define labelH 40
#define bottomViewH ((labelH) + 50)
#define productH 90
@interface CMOrderCell ()<AbstractAlertViewDelegate>
@property (weak, nonatomic)  UILabel *labelOrderNo;
/** 序列号 */
@property (weak, nonatomic)  UILabel *labelOrderState;
/** 商品明细view */
@property (weak, nonatomic)  UIView  *viewGraphic;
/** 总计 总金额 */
@property (weak, nonatomic)  UILabel *labelGoodsPrice;
/** 申请退款 */
@property (weak, nonatomic)  UIButton *refundButton;
/** 快递查询 */
@property (weak, nonatomic)  UIButton *buttonExpress;
/** 状态操作按钮，去支付，确认收货，删除订单 */
@property (weak, nonatomic)  UIButton *buttonOperation;
/** 底部view */
@property (weak, nonatomic)  UIView *bottomView;

@end
@implementation CMOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CMOrderCell";
    CMOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CMOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    //默认隐藏物流按钮
    cell.buttonExpress.hidden = YES;
    return cell;
}


+ (CGFloat)cellHeight:(NSDictionary *)dict
{
    NSArray *goodsArr = dict[@"goods"];
    return bottomViewH + labelH + productH*goodsArr.count;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setUpView
{
    
    /** 编号 */
    UILabel *orderNoLabel = [[UILabel alloc]init];
    orderNoLabel.font = textFont;
    _labelOrderNo = orderNoLabel;
    
    
    /** 状态 */
    UILabel *stateLabel = [[UILabel alloc]init];
    stateLabel.font = textFont;
    stateLabel.textColor = __kThemeColor;
    stateLabel.textAlignment = NSTextAlignmentRight;
    _labelOrderState = stateLabel;
    
    /** 顶部分割线 */
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = __kLineColor;
    
    
    /** 图文详情 */
    UIView *graphicView = [[UIView alloc]init];
    graphicView.contentMode = UIViewContentModeScaleAspectFit;
    _viewGraphic = graphicView;
    
    /** 底部view */
    UIView *bottomView = [[UIView alloc]init];
    bottomView.contentMode = UIViewContentModeScaleAspectFit;
    //    bottomView.backgroundColor = [UIColor redColor];
    _bottomView = bottomView;
    
    /** 总金额 */
    UILabel *payLabel = [[UILabel alloc]init];
    payLabel.font = textFont;
    payLabel.textAlignment = NSTextAlignmentRight;
    _labelGoodsPrice = payLabel;
    
    /** 底部分割线 */
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = __kLineColor;
    
    CGFloat cornerR = 20;
    
    /** 申请退款 */
    UIButton *refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refundBtn setTitleColor:__kGreen_Color forState:UIControlStateNormal];
    refundBtn.titleLabel.font = textFont;
    refundBtn.layer.borderColor = __kGreen_Color.CGColor;
    refundBtn.layer.borderWidth = 1;
    refundBtn.layer.cornerRadius = cornerR;
    refundBtn.layer.masksToBounds = YES;
    [refundBtn addTarget:self action:@selector(choseOperation2:) forControlEvents:UIControlEventTouchUpInside];
    //    _refundButton = refundBtn;
    
    /** 查看物流 */
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:__kGreen_Color forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = textFont;
    cancelBtn.layer.borderColor = __kGreen_Color.CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = cornerR;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(choseOperation1:) forControlEvents:UIControlEventTouchUpInside];
    _buttonExpress = cancelBtn;
    
    /** 操作按钮 */
    UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn setTitleColor:__kThemeColor forState:UIControlStateNormal];
    operationBtn.titleLabel.font = textFont;
    operationBtn.layer.borderColor = __kThemeColor.CGColor;
    operationBtn.layer.borderWidth = 1;
    operationBtn.layer.cornerRadius = cornerR;
    operationBtn.layer.masksToBounds = YES;
    [_buttonOperation setTitle:@"立即支付" forState:UIControlStateNormal];
    _buttonOperation = operationBtn;
    [_buttonOperation addTarget:self action:@selector(choseOperation:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView sd_addSubviews:@[_labelGoodsPrice, bottomLine,_buttonExpress, _buttonOperation]];
    
    [self sd_addSubviews:@[_labelOrderNo, _labelOrderState, topLine,_viewGraphic,_bottomView]];
    
    
    
    CGFloat margin = 10;
    
    _labelOrderNo.sd_layout
    .leftSpaceToView(self, margin)
    .topSpaceToView(self,0)
    .heightIs(labelH)
    .rightSpaceToView(self,150);
    
    _labelOrderState.sd_layout
    .leftSpaceToView(self, margin)
    .topSpaceToView(self,0)
    .heightIs(labelH)
    .rightSpaceToView(self,margin);
    
    topLine.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(_labelOrderNo,0)
    .heightIs(__kLine_Width_Height)
    .rightSpaceToView(self,0);
    
    _viewGraphic.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(topLine,0)
    .rightSpaceToView(self,0);
    
    _bottomView.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(_viewGraphic,0)
    .heightIs(bottomViewH)
    .rightSpaceToView(self,0);
    
    _labelGoodsPrice.sd_layout
    .leftSpaceToView(_bottomView, margin)
    .topSpaceToView(_bottomView,0)
    .heightIs(labelH)
    .rightSpaceToView(_bottomView,margin);
    
    
    bottomLine.sd_layout
    .leftSpaceToView(_bottomView, 0)
    .topSpaceToView(_bottomView,labelH)
    .heightIs(__kLine_Width_Height)
    .widthRatioToView(_bottomView,1);
    
    CGFloat btnW = 80;
    CGFloat btnH = 40;
    _buttonOperation.sd_layout
    .rightSpaceToView(_bottomView, margin)
    .topSpaceToView(bottomLine,5)
    .heightIs(btnH)
    .widthIs(btnW);
    
    _buttonExpress.sd_layout
    .rightSpaceToView(_bottomView, 10 + btnW + margin)
    .topSpaceToView(bottomLine,5)
    .heightIs(btnH)
    .widthIs(btnW);
    
    //    _refundButton.sd_layout
    //    .leftSpaceToView(_bottomView, 20)
    //    .topSpaceToView(bottomLine,5)
    //    .heightIs(btnH)
    //    .widthIs(btnW);
    //
    
}

- (void)setDict:(NSDictionary *)dict
{
    
    //            id        订单编号
    //
    //            status_name    订单状态
    //
    //            shipping_type_name    收货类型名称
    //
    //            pay_type_name    支付类型名称
    //
    //            order_sn    订单编码
    //
    //            all_number    商品总数
    //
    //            amount        总金额
    //
    //            status        订单状态编号 （判断用）
    //
    //            goods        购买的商品
    //
    //            cover        商品封面
    //
    //            good_name    商品名称
    //
    //            good_id        商品编号
    //
    //            pay_amount    售价
    //
    //            good_number    商品数量
    
    _dict = dict;
    NSString *orderNo;
    //    if (_orderModel.soLineNo.length) {
    //        orderNo = [NSString stringWithFormat:@"订单号:%@",_orderModel.soLineNo];
    //    }else
    orderNo =[NSString stringWithFormat:@"订单号:%@",_dict[@"order_sn"]];
    _labelOrderNo.text = orderNo;
    _labelOrderState.text = _dict[@"status_name"];
    
    int orderStatus = [_dict[@"status"] intValue];
    /** 订单状态
     2 => '已取消',
     3 => '已关闭',
     5 => '未付款',
     6 => '已付款',
     7 => '商家已确认',
     8 => '商家已发货',
     9 => '已收货',  */
    switch (orderStatus) {
        case 2:{
            //            _labelOrderState.text = @"已取消";
            _labelOrderState.textColor = [UIColor lightGrayColor];
            _buttonOperation.hidden = NO;
            [_buttonOperation setTitle:@"删除订单" forState:UIControlStateNormal];
            _buttonExpress.hidden = YES;
            _refundButton.hidden = YES;
            
        }
        case 3:{
            //            _labelOrderState.text = @"已关闭";
            _labelOrderState.textColor = [UIColor lightGrayColor];
            _buttonOperation.hidden = NO;
            [_buttonOperation setTitle:@"删除订单" forState:UIControlStateNormal];
            _buttonExpress.hidden = YES;
            _refundButton.hidden = YES;
            
        }
        case 4:{
            //            _labelOrderState.text = @"已退货";
            _labelOrderState.textColor = [UIColor lightGrayColor];
            _buttonOperation.hidden = YES;
            _buttonExpress.hidden = YES;
            _refundButton.hidden = YES;
            
        }
            break;
        case 5:{
            //            _labelOrderState.text = @"未付款";
            _labelOrderState.textColor = [UIColor redColor];
            _buttonOperation.hidden = NO;
            [_buttonOperation setTitle:@"立即支付" forState:UIControlStateNormal];
            [_buttonExpress setTitle:@"取消订单" forState:UIControlStateNormal];
            
            _buttonExpress.hidden = NO;
            _refundButton.hidden = YES;
        }
            break;
        case 6:
            //            _labelOrderState.text = @"已付款";
            _labelOrderState.textColor = [UIColor redColor];
            _buttonOperation.hidden = YES;
            //            [_buttonOperation setTitle:@"催发货" forState:UIControlStateNormal];
            _buttonExpress.hidden = YES;
            _refundButton.hidden = NO;
            
            break;
        case 7:{
            //            _labelOrderState.text = @"商家已确认";
            _labelOrderState.textColor = [UIColor redColor];
            _buttonOperation.hidden = YES;
            _buttonExpress.hidden = YES;
            _refundButton.hidden = NO;
        }
            break;
        case 8:{
            //            _labelOrderState.text = @"商家已发货";
            _labelOrderState.textColor = [UIColor redColor];
            _buttonOperation.hidden = NO;
            [_buttonOperation setTitle:@"确认收货" forState:UIControlStateNormal];
            [_buttonExpress setTitle:@"快递查询" forState:UIControlStateNormal];
            
            _buttonExpress.hidden = NO;
            _refundButton.hidden = NO;
        }
            break;
        case 9:
            //            _labelOrderState.text = @"交易完成";
            _labelOrderState.textColor = [UIColor lightGrayColor];
            _buttonOperation.hidden = NO;
            [_buttonOperation setTitle:@"删除订单" forState:UIControlStateNormal];
            _buttonExpress.hidden = YES;
            _refundButton.hidden = YES;
            
            break;
        default:
            break;
    }
    
    
    NSArray *goodsArr = _dict[@"goods"];
    
    /** 商品明细 */
    _viewGraphic.frame = CGRectMake(0,labelH + __kLine_Width_Height , __kWindow_Width, productH*goodsArr.count);
    _bottomView.top = _viewGraphic.bottom;
    
    for (UIView *view in _viewGraphic.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < goodsArr.count; i ++) {
        
        NSDictionary *ddd = goodsArr[i];
        
        UIView *productCell = [[UIView alloc] init];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [image sd_setImageWithURL:[NSURL URLWithString:ddd[@"cover"]] placeholderImage:[UIImage imageNamed:@"allStarLoading"]];
        //        image.image = [UIImage imageNamed:@"product_pic2"];
        
        
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.numberOfLines = 0;
        //        nameLabel.text = @"阿斯顿见佛 史蒂夫奥神队赴澳拍速度发剖啊我肚佛史蒂夫奥神队赴澳拍速度发剖啊我肚佛怕山东皮肤啊欧式地方哦啊苏";
        nameLabel.text = ddd[@"good_name"];
        nameLabel.font = textFont;
        
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.text = [NSString stringWithFormat:@"¥%@",ddd[@"pay_amount"]];
        //        priceLabel.text = @"1元";
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = textFont;
        
        
        UILabel *quanLabel = [[UILabel alloc] init];
        quanLabel.textAlignment = NSTextAlignmentRight;
        quanLabel.text = [NSString stringWithFormat:@"x%@",ddd[@"good_number"]];
        //        quanLabel.text = @"x1";
        quanLabel.textColor = [UIColor lightGrayColor];
        quanLabel.font = textFont;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = __kLineColor;
        
        [productCell sd_addSubviews:@[image,nameLabel,priceLabel,quanLabel,line]];
        [_viewGraphic sd_addSubviews:@[productCell]];
        
        CGFloat margin = 10;
        
        productCell.sd_layout
        .leftSpaceToView(_viewGraphic, 0)
        .topSpaceToView(_viewGraphic,productCellH*i)
        .heightIs(productCellH)
        .rightSpaceToView(_viewGraphic,0);
        
        
        image.sd_layout
        .leftSpaceToView(productCell, margin)
        .topSpaceToView(productCell,margin)
        .heightIs(productCellH - 2*margin)
        .widthEqualToHeight();
        
        
        nameLabel.sd_layout
        .leftSpaceToView(productCell, productCellH + margin)
        .topSpaceToView(productCell,margin)
        .autoHeightRatio(0)
        .maxHeightIs(image.height)
        .rightSpaceToView(productCell,80);
        
        priceLabel.sd_layout
        .rightSpaceToView(productCell, margin)
        .topSpaceToView(productCell,0)
        .heightIs(40)
        .widthIs(90);
        
        quanLabel.sd_layout
        .rightSpaceToView(productCell, margin)
        .topSpaceToView(productCell,productCellH - 35)
        .heightIs(labelH)
        .widthIs(90);
        
        line.sd_layout
        .leftSpaceToView(productCell,0)
        .rightSpaceToView(productCell,0)
        .bottomSpaceToView(productCell,0)
        .heightIs(__kLine_Width_Height);
        
    }
    
    
    
    //   _labelGoodsPrice.text = @"1234元";
    _labelGoodsPrice.text = [NSString stringWithFormat:@"总%@件，总金额：¥%@",_dict[@"all_number"],_dict[@"amount"]];
}





// 申请退款
-(void)choseOperation2:(UIButton *)sender
{
    sender.enabled = NO;
    
    if (self.blockRefund) {
        self.blockRefund(self.dict);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}



#warning --- 查看物流有待完善
/** 查看物流 取消订单 */
-(void)choseOperation1:(UIButton *)sender
{
    sender.enabled = NO;
    NSString *str = [sender currentTitle];
    
    NSLog(@"%@",str);
    if ([str isEqualToString:@"快递查询"]) {
        if (self.blockCheckInvoice) {
            self.blockCheckInvoice(self.dict);
        }
    }else if ([str isEqualToString:@"取消订单"])
    {
        AbstractAlertView *alertView = [ButtonsAlertView buttonsAlertViewWithMessage:@"取消订单"  delegate:self buttonTitles:@[@"取消",@"确认"]];
        alertView.tag = 114;
        [alertView show];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

#pragma mark - 立即支付 催发货  确认收货 评价

-(void)choseOperation:(UIButton *)sender
{
    sender.enabled = NO;
    NSString *str = [sender currentTitle];
    NSLog(@" %@  -------- ",str);
    /** 订单状态
     2 => '已取消',
     3 => '已关闭',
     5 => '未付款',
     6 => '已付款',
     7 => '商家已确认',
     8 => '商家已发货',
     9 => '已收货',  */
    if ([str isEqualToString:@"立即支付"]) {
        if (_payblock) {
            _payblock(self.dict);
        }
    }
    //    }else if ([str isEqualToString:@"催发货"])
    //    {
    //        AbstractAlertView *alertView = [ButtonsAlertView buttonsAlertViewWithMessage:[NSString stringWithFormat:@"打电话给客户 %@",__KPhoneService]  delegate:self buttonTitles:@[@"取消",@"拨打"]];
    //        alertView.tag = 115;
    //        [alertView show];
    //
    //    }
    else if ([str isEqualToString:@"确认收货"])
    {
        AbstractAlertView *alertView = [ButtonsAlertView buttonsAlertViewWithMessage:@"确认收货"  delegate:self buttonTitles:@[@"取消",@" 确定"]];
        alertView.tag = 112;
        [alertView show];
        
    }
    else if ([str isEqualToString:@"删除订单"])
    {
        AbstractAlertView *alertView = [ButtonsAlertView buttonsAlertViewWithMessage:@"确认删除"  delegate:self buttonTitles:@[@"取消",@" 确定"]];
        alertView.tag = 113;
        [alertView show];
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    
}

- (void)alertView:(AbstractAlertView *)alertView data:(id)data atIndex:(NSInteger)index
{
    if (alertView.tag == 112) {
        if (index == 1) {
            if (self.chargeblock) {
                self.chargeblock(self.dict);
            }
        }
        
    }else if (alertView.tag == 113) {
        if (index == 1) {
            if (self.deleteOrder) {
                self.deleteOrder(self.dict);
            }
        }
        
    }else if (alertView.tag == 114) {
        if (index == 1) {
            if (self.cancleOrder) {
                self.cancleOrder(self.dict);
            }
        }
        
    }
    
    
}


@end
