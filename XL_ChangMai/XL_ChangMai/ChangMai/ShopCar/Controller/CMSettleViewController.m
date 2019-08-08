//
//  CMSettleViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/1.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMSettleViewController.h"
#import "CMAddressListViewController.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"
//#import "Order.h"
//#import "ApiXml.h"
//#import "DataSigner.h"
//微信支付
//#import "WechatPayManager.h"
#import "CMTabBarController.h"
#define margin 10
#define cellH 50
#define cellH_low 40
#define cellH_Title_width 80
#define productH 90
#define sectionMargin 9
#define titleTextColor [UIColor lightGrayColor]
@interface CMSettleViewController ()
@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,strong)UIView *lastView;

/**支付类型 1 支付宝支付，2 微信支付，3 银联支付*/
@property (nonatomic,strong) NSNumber * payType;
/**支付类型 收货人信息 */
@property (nonatomic,strong) NSDictionary *addressDict;
/** 收货人 */
@property (nonatomic,weak) UILabel *labelContact;
/** 手机号 */
@property (nonatomic,weak) UILabel *labelTell;
/** 收货地址 */
@property (nonatomic,weak) UILabel *labelAddress;
/** 备注 */
@property (nonatomic,weak) UITextField *remarkF;
/** 收货方式 */
@property (nonatomic,strong) NSNumber *shipping_type;
/** 预支付时的编号 */
@property (nonatomic,strong) NSString *rid;
/** 选择收货方式的按钮 */
@property (nonatomic,strong) UIButton *selectBtn;
/** 选择支付方式的按钮 */
@property (nonatomic,strong) UIButton *selectPayBtn;
/** 总金额 */
@property (nonatomic,strong) NSNumber * totalPrice;
/** 订单编号 */
@property(nonatomic,copy) NSString *totalSoNo ;
@end

@implementation CMSettleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    [self createUI];
    [self performSelectorInBackground:@selector(requestMyAddressList) withObject:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"--%f",_lastView.bottom);
    
    self.scrollV.contentSize = CGSizeMake(__kWindow_Width, _lastView.bottom);
    
}

- (void)createUI
{
    
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.frame = self.view.bounds;
    scrollV.backgroundColor = __kViewBgColor;
    [self.view addSubview:scrollV];
    self.scrollV = scrollV;
    
    
    UIView *section1 = [[UIView alloc] init];
    section1.backgroundColor = __kContentBgColor;
    
    UIView *section2 = [[UIView alloc] init];
    section2.backgroundColor = [UIColor whiteColor];
    
    UIView *section3 = [[UIView alloc] init];
    section3.backgroundColor = [UIColor whiteColor];
    
    UIView *section4 = [[UIView alloc] init];
    section4.backgroundColor = [UIColor whiteColor];
    
    _lastView = section4;
    
    [self.scrollV sd_addSubviews:@[section1,section2,section3,section4]];
    
    
    /* section 1 */
    UILabel *contactLabel_title = [self createLabel];
    contactLabel_title.textColor = titleTextColor;
    contactLabel_title.text = @"联  系  人";
    [section1 addSubview:contactLabel_title];
    
    UILabel *contactLabel = [self createLabel];
    contactLabel.text = _addressDict[@"name"];
    [section1 addSubview:contactLabel];
    self.labelContact = contactLabel;
    
    UILabel *phoneLabel_title = [self createLabel];
    phoneLabel_title.textColor = titleTextColor;
    phoneLabel_title.text = @"联系电话";
    [section1 addSubview:phoneLabel_title];
    
    UILabel *phoneLabel = [self createLabel];
    phoneLabel.text = _addressDict[@"phone"];
    [section1 addSubview:phoneLabel];
    self.labelTell = phoneLabel;
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_arrow"]];
    arrow.userInteractionEnabled = YES;
    arrow.contentMode = UIViewContentModeCenter;
    [section1 addSubview:arrow];
    
    
    UIView *tapView = [[UIView alloc] init];
    tapView.backgroundColor = [UIColor clearColor];
    [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress)]];
    
    UILabel *addressLabel_title = [self createLabel];
    addressLabel_title.textColor = titleTextColor;
    addressLabel_title.text = @"收货地址";
    [section1 addSubview:addressLabel_title];
    
    UILabel *addressLabel = [self createLabel];
    [section1 addSubview:addressLabel];
    addressLabel.text = _addressDict[@"address"];
    addressLabel.numberOfLines = 0;
    addressLabel.adjustsFontSizeToFitWidth = YES;
    self.labelAddress = addressLabel;
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = __kLineColor;
    [section1 addSubview:line1];
    
    UILabel *storeLabel_title = [self createLabel];
    storeLabel_title.textColor = titleTextColor;
    storeLabel_title.text = @"门店地址";
    [section1 addSubview:storeLabel_title];
    
    UILabel *storeLabel = [self createLabel];
    storeLabel.text = self.storeAddress;
    [section1 addSubview:storeLabel];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = __kLineColor;
    [section1 addSubview:line1];
    
    UILabel *getWayLabel_title = [self createLabel];
    getWayLabel_title.textColor = titleTextColor;
    getWayLabel_title.text = @"收货方式";
    [section1 addSubview:getWayLabel_title];
    
    
    UIButton *expressButton = [self createButton];
    //    allSelectButton.selected = self.isAllSelect;
    expressButton.tag = 1;
    [expressButton setTitle:@"  快递到家" forState:UIControlStateNormal];
    [expressButton addTarget:self action:@selector(expressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self expressButtonClick:expressButton];
    
    
    UIButton *storeButton = [self createButton];
    //    allSelectButton.selected = self.isAllSelect;
    storeButton.tag = 2;
    [storeButton setTitle:@"  门店自取" forState:UIControlStateNormal];
    [storeButton addTarget:self action:@selector(expressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = __kLineColor;
    [section1 addSubview:line3];
    
    UITextField *remarkField = [[UITextField alloc] init];
    remarkField.backgroundColor = [UIColor clearColor];
    remarkField.font = Font(15);
    remarkField.placeholder = @"备注";
    [section1 addSubview:remarkField];
    self.remarkF = remarkField;
    
    
    [section1 sd_addSubviews:@[contactLabel_title,contactLabel,phoneLabel_title,phoneLabel,arrow,tapView,addressLabel,addressLabel_title,storeLabel_title,storeLabel,getWayLabel_title,expressButton,storeButton,line1,line2,line3,remarkField]];
    
    
    tapView.sd_layout
    .leftSpaceToView(section1, 0)
    .topSpaceToView(section1, 0)
    .heightIs(cellH_low*3)
    .widthIs(__kWindow_Width);
    
    contactLabel_title.sd_layout
    .leftSpaceToView(section1, margin)
    .topSpaceToView(section1, 0)
    .heightIs(cellH_low)
    .widthIs(cellH_Title_width);
    
    contactLabel.sd_layout
    .leftSpaceToView(contactLabel_title, 0)
    .topEqualToView(contactLabel_title)
    .heightIs(cellH_low)
    .widthIs(__kWindow_Width - cellH_Title_width - margin);
    
    phoneLabel_title.sd_layout
    .leftSpaceToView(section1, margin)
    .topSpaceToView(contactLabel_title, 0)
    .heightIs(cellH_low)
    .widthIs(cellH_Title_width);
    
    phoneLabel.sd_layout
    .leftSpaceToView(phoneLabel_title, 0)
    .topEqualToView(phoneLabel_title)
    .heightIs(cellH_low)
    .widthIs(__kWindow_Width - cellH_Title_width - margin);
    
    arrow.sd_layout
    .rightSpaceToView(section1,margin)
    .topEqualToView(phoneLabel_title)
    .heightIs(cellH_low)
    .widthIs(20);
    
    
    addressLabel_title.sd_layout
    .leftSpaceToView(section1, margin)
    .topSpaceToView(phoneLabel_title, 0)
    .heightIs(cellH_low)
    .widthIs(cellH_Title_width);
    
    addressLabel.sd_layout
    .leftSpaceToView(addressLabel_title, 0)
    .topEqualToView(addressLabel_title)
    .heightIs(cellH_low)
    .widthIs(__kWindow_Width - cellH_Title_width - margin);
    
    line1.sd_layout
    .leftSpaceToView(section1, 0)
    .topSpaceToView(addressLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    storeLabel_title.sd_layout
    .leftSpaceToView(section1, margin)
    .topSpaceToView(line1, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    storeLabel.sd_layout
    .leftSpaceToView(storeLabel_title, 0)
    .topEqualToView(storeLabel_title)
    .heightIs(cellH)
    .widthIs(__kWindow_Width - cellH_Title_width - margin);
    
    line2.sd_layout
    .leftSpaceToView(section1, 0)
    .topSpaceToView(storeLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    getWayLabel_title.sd_layout
    .leftSpaceToView(section1, margin)
    .topSpaceToView(line2, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    expressButton.sd_layout
    .leftSpaceToView(getWayLabel_title, 0)
    .topEqualToView(getWayLabel_title)
    .heightIs(cellH)
    .widthIs(120);
    
    storeButton.sd_layout
    .leftSpaceToView(expressButton, 0)
    .topEqualToView(getWayLabel_title)
    .heightIs(cellH)
    .widthIs(120);
    
    line3.sd_layout
    .leftSpaceToView(section1, 0)
    .topSpaceToView(getWayLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    
    remarkField.sd_layout
    .leftSpaceToView(section1, margin)
    .topEqualToView(line3)
    .heightIs(cellH)
    .widthIs(__kWindow_Width - 2*margin);
    
    
    section1.sd_layout
    .leftSpaceToView(self.scrollV, 0)
    .topSpaceToView(self.scrollV,0)
    .heightIs(cellH_low*3+cellH*3)
    .rightSpaceToView(self.scrollV,0);
    
    /* section 2 */
    
    for (int i = 0; i < self.goodsArr.count; i ++) {
        
        NSDictionary *dict = self.goodsArr[i];
        
        UIView *productCell = [[UIView alloc] init];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [image sd_setImageWithURL:[NSURL URLWithString:dict[@"cover"]] placeholderImage:[UIImage imageNamed:@"allStarLoading"]];
        //        image.image = [UIImage imageNamed:@"product_pic2"];
        
        
        
        UILabel *nameLabel = [self createLabel];
        nameLabel.numberOfLines = 0;
        //        nameLabel.text = @"阿斯顿见佛 史蒂夫奥神队赴澳拍速度发剖啊我肚佛史";
        nameLabel.text = dict[@"title"];
        
        
        
        UILabel *priceLabel = [self createLabel];
        priceLabel.text = [NSString stringWithFormat:@"¥%@",dict[@"pay_amount"]];
        priceLabel.textAlignment = NSTextAlignmentRight;
        
        
        
        UILabel *quanLabel = [self createLabel];
        quanLabel.textAlignment = NSTextAlignmentRight;
        quanLabel.text = [NSString stringWithFormat:@"x%@",dict[@"good_number"]];
        quanLabel.textColor = [UIColor lightGrayColor];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = __kLineColor;
        
        [productCell sd_addSubviews:@[line,image,nameLabel,priceLabel,quanLabel]];
        [section2 sd_addSubviews:@[productCell]];
        
        
        productCell.sd_layout
        .leftSpaceToView(section2, 0)
        .topSpaceToView(section2,productH*i)
        .heightIs(productH)
        .rightSpaceToView(section2,0);
        
        line.sd_layout
        .leftSpaceToView(productCell,0)
        .rightSpaceToView(productCell,0)
        .topSpaceToView(productCell,0)
        .heightIs(__kLine_Width_Height);
        
        
        image.sd_layout
        .leftSpaceToView(productCell, margin)
        .topSpaceToView(productCell,margin)
        .heightIs(productH - 2*margin)
        .widthEqualToHeight();
        
        
        nameLabel.sd_layout
        .leftSpaceToView(productCell, productH + margin)
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
        .topSpaceToView(productCell,productH - 35)
        .heightIs(cellH)
        .widthIs(90);
        
        
    }
    
    
    section2.sd_layout
    .leftSpaceToView(self.scrollV, 0)
    .topSpaceToView(section1,sectionMargin)
    .heightIs(productH*self.goodsArr.count)
    .rightSpaceToView(self.scrollV,0);
    
    /* section 3 */
    UILabel *sendFeeLabel_title = [self createLabel];
    sendFeeLabel_title.textColor = titleTextColor;
    sendFeeLabel_title.text = @"选择支付方式";
    
    UIView *line7 = [[UIView alloc] init];
    line7.backgroundColor = __kLineColor;
    
    
    UIImageView *weixinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wx_logo"]];
    weixinImage.contentMode = UIViewContentModeCenter;
    
    
    UILabel *weixinTitle = [self createLabel];
    weixinTitle.text = @"微信支付";
    
    UIButton *weixinBtn = [self createButton];
    //    allSelectButton.selected = self.isAllSelect;
    [weixinBtn addTarget:self action:@selector(payWayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    weixinBtn.tag = 2;
    //默认选中微信支付
    _payType = @2;
    [self payWayButtonClick:weixinBtn];
    
    
    UIView *line8 = [[UIView alloc] init];
    line8.backgroundColor = __kLineColor;
    
    
    UIImageView *zfbImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zfb_logo"]];
    zfbImage.contentMode = UIViewContentModeCenter;
    
    
    UILabel *zfbTitle = [self createLabel];
    zfbTitle.text = @"支付宝支付";
    
    UIButton *zfbBtn = [self createButton];
    //    allSelectButton.selected = self.isAllSelect;
    [zfbBtn addTarget:self action:@selector(payWayButtonClick:) forControlEvents:
     UIControlEventTouchUpInside];
    zfbBtn.tag = 1;
    UIView *line15 = [[UIView alloc] init];
    line15.backgroundColor = __kLineColor;
    
    [section3 sd_addSubviews:@[sendFeeLabel_title,line7,weixinImage,weixinTitle,line15,zfbImage,zfbTitle,weixinBtn,zfbBtn]];
    
    sendFeeLabel_title.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(section3, 0)
    .heightIs(cellH)
    .widthIs(150);
    
    
    line7.sd_layout
    .leftSpaceToView(section3, 0)
    .topSpaceToView(sendFeeLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    
    weixinImage.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(line7, 0)
    .heightIs(cellH)
    .widthIs(40);
    
    weixinTitle.sd_layout
    .leftSpaceToView(weixinImage, margin)
    .topEqualToView(line7)
    .heightIs(cellH)
    .widthIs(250);
    
    weixinBtn.sd_layout
    .rightSpaceToView(section3,margin)
    .topEqualToView(line7)
    .heightIs(cellH)
    .widthIs(40);
    
    line15.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(weixinImage,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width - 2*margin);
    
    zfbImage.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(line15, 0)
    .heightIs(cellH)
    .widthIs(40);
    
    zfbTitle.sd_layout
    .leftSpaceToView(weixinImage, margin)
    .topEqualToView(line15)
    .heightIs(cellH)
    .widthIs(250);
    
    zfbBtn.sd_layout
    .rightSpaceToView(section3,margin)
    .topEqualToView(line15)
    .heightIs(cellH)
    .widthIs(40);
    
    
    section3.sd_layout
    .leftSpaceToView(self.scrollV, 0)
    .topSpaceToView(section2,sectionMargin)
    .heightIs(cellH*3)
    .rightSpaceToView(self.scrollV,0);
    
    
    
    /* section 4 */
    /**   结算  */
    CGFloat buttonPayW = 100;
    UIButton *buttonPay = [[UIButton alloc] init];
    buttonPay.frame = CGRectMake(__kWindow_Width - buttonPayW, 0,buttonPayW, cellH);
    [buttonPay setTitle:@"提交订单" forState:UIControlStateNormal];
    [buttonPay addTarget:self action:@selector(commitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonPay.backgroundColor = __kThemeColor;
    buttonPay.titleLabel.font = Font(20);
    
    UILabel *totalPriceLabel = [self createLabel];
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    
    for (NSDictionary *dict in self.goodsArr) {
        CGFloat goodPrice = [dict[@"pay_amount"] floatValue]*[dict[@"good_number"] integerValue];
        self.totalPrice = @([self.totalPrice floatValue] + goodPrice);
    }
    
    totalPriceLabel.text = [NSString stringWithFormat:@"共%.02f元",[self
                                                                  .totalPrice floatValue]];
    [section4 sd_addSubviews:@[buttonPay,totalPriceLabel]];
    
    
    buttonPay.sd_layout
    .rightSpaceToView(section4,0)
    .topSpaceToView(section4,0)
    .widthIs(buttonPayW)
    .heightIs(cellH);
    
    totalPriceLabel.sd_layout
    .rightSpaceToView(section4,buttonPayW + 10)
    .topSpaceToView(section4,0)
    .leftSpaceToView(section4,0)
    .heightIs(cellH);
    
    
    section4.sd_layout
    .leftSpaceToView(self.scrollV, 0)
    .topSpaceToView(section3,sectionMargin)
    .heightIs(50)
    .rightSpaceToView(self.scrollV,0);
    
    
}

- (UIButton *)createButton
{
    
    UIButton *allSelectButton = [[UIButton alloc] init];
    [allSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    allSelectButton.titleLabel.font = Font(15);
    [allSelectButton setImage:[UIImage imageNamed:@"checkbox_icon"] forState:UIControlStateNormal];
    [allSelectButton setImage:[UIImage imageNamed:@"checkbox_icon_now"] forState:UIControlStateSelected];
    return allSelectButton;
}

- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = Font(15);
    return label;
}


/**
 *  获取我的地址列表
 */
-(void)requestMyAddressList
{
    
    [[HttpManager shareInstance] get:@"shippings" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        NSArray *temp = response[@"items"];
        for (NSDictionary *dict in temp) {
            if ([dict[@"is_default"] intValue] != 0) {
                self.addressDict = dict;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
    
}



#pragma mark --- 获取结算信息
-(void)requestAddress
{
    [[HttpManager shareInstance] get:@"shippings" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        //        NSLog(@"----返回数据：%@",response);
        
        NSArray *temp = response[@"items"];
        if (temp.count) {
            for (NSDictionary *dict in temp) {
                if ([dict[@"is_default"] intValue]) {
                    _addressDict = dict;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self createUI];
                        
                    });
                    break;
                }
            }
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self createUI];
                
            });
        }
        
        
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self createUI];
            
        });
    }];
    
}



- (void)expressButtonClick:(UIButton *)sender
{
    _selectBtn.selected = NO;
    sender.selected = YES;
    _selectBtn = sender;
    _shipping_type = [NSNumber numberWithInteger:_selectBtn.tag];
}


- (void)payWayButtonClick:(UIButton *)sender
{
    _selectPayBtn.selected = NO;
    sender.selected = YES;
    _selectPayBtn = sender;
    
    _payType = [NSNumber numberWithInteger:sender.tag];
    
}



- (void)selectAddress
{
    CMAddressListViewController *addVc = [[CMAddressListViewController alloc]init];
    addVc.isSettlement = YES;
    
    [addVc setSettlementBlock:^(NSDictionary *dict) {
        self.addressDict = dict;
    }];
    [self.navigationController pushViewController:addVc animated:YES];
    
    
}


- (void)setAddressDict:(NSDictionary *)addressDict
{
    _addressDict = addressDict;
    self.labelContact.text = _addressDict[@"name"];
    self.labelTell.text = _addressDict[@"phone"];
    self.labelAddress.text = _addressDict[@"address"];
}

#pragma mark 提交订单
- (void)commitBtnClick:(UIButton *)sender
{
    
    NSNumber *addressId = self.addressDict[@"id"];
    if (!addressId) {
        [self alertWithMessage:@"请添加收货地址"];
        return;
    }
    
    if (!self.selectBtn) {
        [self alertWithMessage:@"请选择收货方式"];
        return;
    }
    
    if (!self.selectPayBtn) {
        [self alertWithMessage:@"请选择支付方式"];
        return;
    }
    
    NSMutableString *idString = [NSMutableString string];
    for (NSDictionary *dict in self.goodsArr) {
        if (idString.length) {
            [idString appendString:@","];
        }
        [idString appendFormat:@"%@",dict[@"id"]];
    }
    
    NSDictionary *postDic;
    
    
    NSString *payAmountStr = [NSString stringWithFormat:@"%.02f",[self.totalPrice floatValue]];
    NSNumber *payAmount = [NSNumber numberWithFloat:[payAmountStr floatValue]];
    if (self.sourceType == 1) {//商品详情界面直接购买
        postDic = @{@"store_id":@(self.storeId),
                    @"ids":self.cart_Id,
                    @"shipping_id":addressId,
                    @"type":_payType,
                    @"shipping_type":self.shipping_type,
                    @"remark":self.remarkF.text?self.remarkF.text:@""};
    }else{
        postDic = @{@"store_id":@(self.storeId),
                    @"ids":idString,
                    @"shipping_id":addressId,
                    @"type":_payType,
                    @"shipping_type":self.shipping_type,
                    @"remark":self.remarkF.text?self.remarkF.text:@""};
    }
    
    
    
    sender.enabled = NO;
    
    NSLog(@"%@",postDic);
    
    
    
    [[HttpManager shareInstance] post:@"deal_order" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        
        sender.enabled = YES;
        
        NSLog(@"---%@",response);
        
        NSDictionary *dic = (NSDictionary *)response;
        
        //        [self alertWithMessage:response[@"msg"]];
        
        if ([dic[@"result"] intValue] == 1) {//成功
            
            /** 订单编号 */
            self.totalSoNo = [NSString stringWithFormat:@"%@",response[@"id"]];
            
            
            if ([dic[@"is_pay"] boolValue]) {//需要支付
                
                if ([_payType integerValue] == 1) {//支付宝
                    NSLog(@"-------选择了支付宝-------------");
                    
                    NSString *str = dic[@"ali_pay_info"];
                    
                    [self ZhiFuBaoPayWihtOrderInfo:str orderId:self.totalSoNo];
                    
                }else if ([_payType integerValue] == 2){//微信
                    NSLog(@"%@",[dic[@"wx_pay_info"] class]);
                    NSDictionary *ddd = dic[@"wx_pay_info"];
                    NSString *prePayId = ddd[@"prepayid"];
                    NSString *signString = ddd[@"sign"];
                    NSString *time_stamp = ddd[@"timestamp"];
                    NSString *noncestr = ddd[@"noncestr"];
                    
                    [self  wxPayWithOrdeNO: self.totalSoNo   price:[NSString  stringWithFormat:@"%.02f", [payAmount floatValue]*100 ] prePayId:prePayId signString:signString time_stamp:time_stamp noncestr:noncestr];
                }
                
                
            }else{//不需要支付，跳转支付成功后的处理
                
                [self paySuccessAndFailureHandle];
                
            }
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertWithMessage:response[@"msg"]];
                sender.enabled = YES;
            });
        }
        
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"---%@",response);
            
            [self alertWithMessage:response[@"msg"]];
            sender.enabled = YES;
        });
    }];
    
    
}



#pragma mark 支付宝支付


- (void)ZhiFuBaoPayWihtOrderInfo:(NSString *)aliPay_info orderId:(NSString *)orderId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//        NSString *appScheme = myAppScheme;
//        [[AlipaySDK defaultService] payOrder:aliPay_info fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//
//
//            NSLog(@"在线支付----通过支付宝-----reslut = %@",resultDic);
//
//
//#warning 支付成功返回
//
//            if([resultDic[@"resultStatus"] intValue] == 9000)
//            {
//                /** 支付成功  */
//                [MessageAlertView showWithMessage:@"支付成功"];
//                CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
//                [tabbarController pushOrderDetailViewController:self.totalSoNo];
//            }
//            else
//            {
//                /** 支付失败  */
//                [MessageAlertView showWithMessage:@"支付失败"];
//
//                CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
//                [tabbarController pushOrderDetailViewController:self.totalSoNo];
//
//            }
//
//        }];
//
        
        
    });
}


- (void)paySuccessAndFailureHandle
{
    
    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
    [tabbarController pushOrderDetailViewController:self.totalSoNo];
    
}


#pragma mark 微信支付
- (void)wxPayWithOrdeNO:(NSString*)orderNO   price:(NSString*)price prePayId:(NSString *)prePayId signString:(NSString *)signString time_stamp:(NSString *)time_stamp noncestr:(NSString *)noncestr
{
    
    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
    tabbarController.orderNO = orderNO;
    
    //创建支付签名对象 && 初始化支付签名对象
//    WechatPayManager* wxpayManager = [[WechatPayManager alloc]initWithAppID:APP_ID mchID:MCH_ID spKey:PARTNER_ID];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    //生成预支付订单，实际上就是把关键参数进行第一次加密。
    // NSString* device = [[UserManager defaultManager]userId];
    
    
#warning 订单编号
    NSString *orderName = @"畅麦";
//    NSMutableDictionary *dict = [wxpayManager getPrepayWithOrderName:orderName
//                                                               price:price
//                                                             orderNO:orderNO
//                                                            prePayId:prePayId
//                                                          signString:signString
//                                                          time_stamp:time_stamp
//                                                            noncestr:noncestr];
//    
//    if(dict == nil)
//    {
//        //错误提示
//        NSString *debug = [wxpayManager getDebugInfo];
//        NSLog(@"---错误提示--debug----%@",debug);
//        
//        
//        return;
//    }
//    
//    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//    
//    //调起微信支付
//    PayReq* req             = [[PayReq alloc] init];
//    req.openID              = [dict objectForKey:@"appid"];
//    req.partnerId           = [dict objectForKey:@"partnerid"];
//    req.prepayId            = [dict objectForKey:@"prepayid"];
//    req.nonceStr            = [dict objectForKey:@"noncestr"];
//    req.timeStamp          = stamp.intValue;
//    req.package            = [dict objectForKey:@"package"];
//    req.sign                = [dict objectForKey:@"sign"];
//    
//    //    NSLog(@"------req.openID -------%@",req.openID );
//    //
//    //    NSLog(@"------req.partnerId  -------%@",req.partnerId  );
//    //
//    //    NSLog(@"------req.prepayId -------%@",req.prepayId );
//    //    NSLog(@"------req.nonceStr -------%@",req.nonceStr );
//    //    NSLog(@"------timeStamp -------%zd",req.timeStamp );
//    //    NSLog(@"------sign -------%@",req.sign );
//    
//    BOOL flag = [WXApi sendReq:req];
//    
//    NSLog(@"---------------flag------%d",flag);
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        if(!flag)
//        {
//            [MessageAlertView showWithMessage:@"您尚未安装微信"];
//        }
//        
//    });
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
