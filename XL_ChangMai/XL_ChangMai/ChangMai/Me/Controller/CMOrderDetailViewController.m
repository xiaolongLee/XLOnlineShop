//
//  CMOrderDetailViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMOrderDetailViewController.h"
#import "CMToPayViewController.h"
#import "CMRefundViewController.h"
#define margin 10
#define cellH 50
#define cellH_low 40
#define cellH_Title_width 80
#define productH 90
#define sectionMargin 9
#define titleTextColor [UIColor lightGrayColor]
@interface CMOrderDetailViewController ()
@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,strong)UIView *lastView;
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;
@end

@implementation CMOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = @"我的订单";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(requestData) withObject:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"--%f",_lastView.bottom);
    
    self.scrollV.contentSize = CGSizeMake(__kWindow_Width, _lastView.bottom);
    
}

- (void)createUI
{
    
    self.tableView = nil;
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.frame = CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY);
    scrollV.backgroundColor = __kViewBgColor;
    [self.view addSubview:scrollV];
    self.scrollV = scrollV;
    
    
    UIView *section1 = [[UIView alloc] init];
    section1.backgroundColor = [UIColor whiteColor];
    
    UIView *section2 = [[UIView alloc] init];
    section2.backgroundColor = [UIColor whiteColor];
    
    UIView *section3 = [[UIView alloc] init];
    section3.backgroundColor = [UIColor whiteColor];
    
    UIView *section4 = [[UIView alloc] init];
    section4.backgroundColor = [UIColor whiteColor];
    
    UIView *section5 = [[UIView alloc] init];
    section5.backgroundColor = [UIColor whiteColor];
    _lastView = section5;
    
    [self.scrollV sd_addSubviews:@[section1,section2,section3,section4,section5]];
    
    
    /* section 1 */
    UILabel *contactLabel_title = [self createLabel];
    contactLabel_title.textColor = titleTextColor;
    contactLabel_title.text = @"联  系  人";
    [section1 addSubview:contactLabel_title];
    
    UILabel *contactLabel = [self createLabel];
    contactLabel.text = _dataDict[@"order"][@"shipping_name"];
    [section1 addSubview:contactLabel];
    
    
    UILabel *phoneLabel_title = [self createLabel];
    phoneLabel_title.textColor = titleTextColor;
    phoneLabel_title.text = @"联系电话";
    [section1 addSubview:phoneLabel_title];
    
    UILabel *phoneLabel = [self createLabel];
    phoneLabel.text = _dataDict[@"order"][@"shipping_name"];
    [section1 addSubview:phoneLabel];
    
    
    UILabel *addressLabel_title = [self createLabel];
    addressLabel_title.textColor = titleTextColor;
    addressLabel_title.text = @"收货地址";
    [section1 addSubview:addressLabel_title];
    
    UILabel *addressLabel = [self createLabel];
    addressLabel.text = _dataDict[@"order"][@"shipping_address"];
    [section1 addSubview:addressLabel];
    //    addressLabel.text = @"上海市浦东新区阿里斯顿见佛啊结束的发生地发生了地方阿斯顿发送的";
    addressLabel.numberOfLines = 0;
    addressLabel.adjustsFontSizeToFitWidth = YES;
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = __kLineColor;
    [section1 addSubview:line1];
    
    UILabel *storeLabel_title = [self createLabel];
    storeLabel_title.textColor = titleTextColor;
    storeLabel_title.text = @"门店地址";
    [section1 addSubview:storeLabel_title];
    
    UILabel *storeLabel = [self createLabel];
    storeLabel.text = _dataDict[@"store_address"];
    [section1 addSubview:storeLabel];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = __kLineColor;
    [section1 addSubview:line1];
    
    UILabel *getWayLabel_title = [self createLabel];
    getWayLabel_title.textColor = titleTextColor;
    getWayLabel_title.text = @"收货方式";
    [section1 addSubview:getWayLabel_title];
    
    UILabel *getWayLabel = [self createLabel];
    getWayLabel.text = _dataDict[@"order"][@"shipping_type_name"];
    [section1 addSubview:getWayLabel];
    
    [section1 sd_addSubviews:@[contactLabel_title,contactLabel,phoneLabel_title,phoneLabel,addressLabel,addressLabel_title,storeLabel_title,storeLabel,line1,line2]];
    
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
    
    getWayLabel.sd_layout
    .leftSpaceToView(getWayLabel_title, 0)
    .topEqualToView(getWayLabel_title)
    .heightIs(cellH)
    .widthIs(__kWindow_Width - cellH_Title_width - margin);
    
    section1.sd_layout
    .leftSpaceToView(self.scrollV, 0)
    .topSpaceToView(self.scrollV,0)
    .heightIs(cellH_low*3+cellH*2)
    .rightSpaceToView(self.scrollV,0);
    
    /* section 2 */
    /** 编号 */
    UILabel *orderNoLabel = [self createLabel];
    //    orderNoLabel.text = @"订单号:32319827971974";
    orderNoLabel.text = [NSString stringWithFormat:@"订单号：%@",_dataDict[@"order"][@"order_sn"]];
    /** 状态 */
    UILabel *stateLabel = [self createLabel];
    stateLabel.textColor = __kThemeColor;
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.text = _dataDict[@"order"][@"status_name"];
    [section2 sd_addSubviews:@[orderNoLabel, stateLabel]];
    
    
    orderNoLabel.sd_layout
    .leftSpaceToView(section2, margin)
    .topSpaceToView(section2,0)
    .heightIs(cellH)
    .rightSpaceToView(section2,150);
    
    stateLabel.sd_layout
    .widthIs(150)
    .topSpaceToView(section2,0)
    .heightIs(cellH)
    .rightSpaceToView(section2,margin);
    
    
    NSArray *goodArr = _dataDict[@"goods"];
    
    for (int i = 0; i < goodArr.count; i ++) {
        NSDictionary *prodcutDict = goodArr[i];
        
        UIView *productCell = [[UIView alloc] init];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [image sd_setImageWithURL:[NSURL URLWithString:prodcutDict[@"cover"]] placeholderImage:[UIImage imageNamed:@"allStarLoading"]];
        //        image.image = [UIImage imageNamed:@"product_pic2"];
        
        
        
        UILabel *nameLabel = [self createLabel];
        nameLabel.numberOfLines = 0;
        //        nameLabel.text = @"阿斯顿见佛 史蒂夫奥神队赴澳拍速度发剖啊我肚佛史";
        nameLabel.text = prodcutDict[@"good_name"];
        
        
        
        UILabel *priceLabel = [self createLabel];
        priceLabel.text = [NSString stringWithFormat:@"¥%@",prodcutDict[@"pay_amount"]];
        //        priceLabel.text = @"1元";
        priceLabel.textAlignment = NSTextAlignmentRight;
        
        
        
        UILabel *quanLabel = [self createLabel];
        quanLabel.textAlignment = NSTextAlignmentRight;
        quanLabel.text = [NSString stringWithFormat:@"x%@",prodcutDict[@"good_number"]];
        //        quanLabel.text = @"x1";
        quanLabel.textColor = [UIColor lightGrayColor];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = __kLineColor;
        
        [productCell sd_addSubviews:@[line,image,nameLabel,priceLabel,quanLabel]];
        [section2 sd_addSubviews:@[productCell]];
        
        
        productCell.sd_layout
        .leftSpaceToView(section2, 0)
        .topSpaceToView(section2,productH*i + cellH)
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
    .heightIs(cellH+productH*goodArr.count)
    .rightSpaceToView(self.scrollV,0);
    
    /* section 3 */
    UILabel *goodPriceLabel_title = [self createLabel];
    goodPriceLabel_title.textColor = titleTextColor;
    goodPriceLabel_title.text = @"商品价格";
    
    UILabel *goodPriceLabel = [self createLabel];
    goodPriceLabel.textAlignment = NSTextAlignmentRight;
    goodPriceLabel.textColor = titleTextColor;
    goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",_dataDict[@"order"][@"all_amount"]];
    
    
    UIView *line11 = [[UIView alloc] init];
    line11.backgroundColor = __kLineColor;
    
    UILabel *sendFeeLabel_title = [self createLabel];
    sendFeeLabel_title.textColor = titleTextColor;
    sendFeeLabel_title.text = @"配送费";
    
    UILabel *sendFeeLabel = [self createLabel];
    sendFeeLabel.textAlignment = NSTextAlignmentRight;
    sendFeeLabel.textColor = titleTextColor;
    CGFloat sendFee = [_dataDict[@"order"][@"shipping_amount"] floatValue];
    if (sendFee) {
        sendFeeLabel.text = [NSString stringWithFormat:@"¥%f",sendFee];
    }else{
        sendFeeLabel.text = @"包邮";
    }
    
    
    
    UIView *line7 = [[UIView alloc] init];
    line7.backgroundColor = __kLineColor;
    
    
    UILabel *taxFeeLabel_title = [self createLabel];
    taxFeeLabel_title.textColor = titleTextColor;
    taxFeeLabel_title.text = @"税费";
    
    UILabel *taxFeeLabel = [self createLabel];
    taxFeeLabel.textAlignment = NSTextAlignmentRight;
    taxFeeLabel.textColor = titleTextColor;
    CGFloat taxFee = [_dataDict[@"order"][@"tax_amount"] floatValue];
    if (sendFee) {
        taxFeeLabel.text = [NSString stringWithFormat:@"¥%f",taxFee];
    }else{
        taxFeeLabel.text = @"包税";
    }
    
    
    UIView *line12 = [[UIView alloc] init];
    line12.backgroundColor = __kLineColor;
    
    
    UILabel *totalPriceLabel_title = [self createLabel];
    totalPriceLabel_title.textColor = titleTextColor;
    totalPriceLabel_title.text = @"订单总价";
    
    
    UILabel *totalPriceLabel = [self createLabel];
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    //    totalPriceLabel.text = @"124124元";
    totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",_dataDict[@"order"][@"amount"]];
    
    UIView *line8 = [[UIView alloc] init];
    line8.backgroundColor = __kLineColor;
    
    
    UILabel *payPriceLabel_title = [self createLabel];
    payPriceLabel_title.textColor = titleTextColor;
    payPriceLabel_title.text = @"实付款";
    
    
    UILabel *payPriceLabel = [self createLabel];
    payPriceLabel.textAlignment = NSTextAlignmentRight;
    payPriceLabel.textColor = __kThemeColor;
    //    payPriceLabel.text = @"100";
    payPriceLabel.text = [NSString stringWithFormat:@"¥%@",_dataDict[@"order"][@"pay_amount"]];
    
    
    
    [section3 sd_addSubviews:@[goodPriceLabel_title,goodPriceLabel,sendFeeLabel_title,sendFeeLabel,taxFeeLabel_title,taxFeeLabel,totalPriceLabel_title,totalPriceLabel,payPriceLabel_title,payPriceLabel,line11,line12,line7,line8]];
    
    goodPriceLabel_title.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(section3, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    goodPriceLabel.sd_layout
    .rightSpaceToView(section3,margin)
    .topEqualToView(goodPriceLabel_title)
    .heightIs(cellH)
    .widthIs(250);
    
    line11.sd_layout
    .leftSpaceToView(section3, 0)
    .topSpaceToView(goodPriceLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    sendFeeLabel_title.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(line11, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    sendFeeLabel.sd_layout
    .rightSpaceToView(section3,margin)
    .topEqualToView(sendFeeLabel_title)
    .heightIs(cellH)
    .widthIs(250);
    
    line7.sd_layout
    .leftSpaceToView(section3, 0)
    .topSpaceToView(sendFeeLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    taxFeeLabel_title.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(line7, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    taxFeeLabel.sd_layout
    .rightSpaceToView(section3,margin)
    .topEqualToView(taxFeeLabel_title)
    .heightIs(cellH)
    .widthIs(250);
    
    line12.sd_layout
    .leftSpaceToView(section3, 0)
    .topSpaceToView(taxFeeLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    totalPriceLabel_title.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(line12, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    totalPriceLabel.sd_layout
    .rightSpaceToView(section3,margin)
    .topEqualToView(totalPriceLabel_title)
    .heightIs(cellH)
    .widthIs(250);
    
    line8.sd_layout
    .leftSpaceToView(section3, 0)
    .topSpaceToView(totalPriceLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    
    payPriceLabel_title.sd_layout
    .leftSpaceToView(section3, margin)
    .topSpaceToView(line8, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    payPriceLabel.sd_layout
    .rightSpaceToView(section3,margin)
    .topEqualToView(payPriceLabel_title)
    .heightIs(cellH)
    .widthIs(250);
    
    
    section3.sd_layout
    .leftSpaceToView(self.scrollV, 0)
    .topSpaceToView(section2,sectionMargin)
    .heightIs(cellH*5)
    .rightSpaceToView(self.scrollV,0);
    
    /* section 4 */
    UILabel *payWayLabel_title = [self createLabel];
    payWayLabel_title.textColor = titleTextColor;
    payWayLabel_title.text = @"支付方式";
    
    UILabel *payWayLabel = [self createLabel];
    payWayLabel.text = _dataDict[@"order"][@"pay_type_name"];
    
    
    UIView *line9 = [[UIView alloc] init];
    line9.backgroundColor = __kLineColor;
    
    
    
    UILabel *payTimeLabel_title = [self createLabel];
    payTimeLabel_title.textColor = titleTextColor;
    payTimeLabel_title.text = @"支付时间";
    
    
    UILabel *payTimeLabel = [self createLabel];
    //    payTimeLabel.text = @"2016:10:19";
    payTimeLabel.text = _dataDict[@"order"][@"pay_date"];
    
    
    UIView *line10 = [[UIView alloc] init];
    line10.backgroundColor = __kLineColor;
    
    
    UILabel *hintLabel = [self createLabel];
    hintLabel.text = @"坐等收货";
    
    
    
    [section4 sd_addSubviews:@[payWayLabel_title,payWayLabel,payTimeLabel_title,payTimeLabel,hintLabel,line9,line10]];
    
    payWayLabel_title.sd_layout
    .leftSpaceToView(section4, margin)
    .topSpaceToView(section4, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    payWayLabel.sd_layout
    .leftSpaceToView(payWayLabel_title,0)
    .topEqualToView(payWayLabel_title)
    .heightIs(cellH)
    .widthIs(__kWindow_Width - cellH_Title_width - margin);
    
    line9.sd_layout
    .leftSpaceToView(section4, 0)
    .topSpaceToView(payWayLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    
    payTimeLabel_title.sd_layout
    .leftSpaceToView(section4, margin)
    .topSpaceToView(line9, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    payTimeLabel.sd_layout
    .leftSpaceToView(payTimeLabel_title,0)
    .topEqualToView(payTimeLabel_title)
    .heightIs(cellH)
    .widthIs(__kWindow_Width - cellH_Title_width - margin);
    
    line10.sd_layout
    .leftSpaceToView(section4, 0)
    .topSpaceToView(payTimeLabel_title,0)
    .heightIs(__kLine_Width_Height)
    .widthIs(__kWindow_Width);
    
    
    hintLabel.sd_layout
    .leftSpaceToView(section4, margin)
    .topSpaceToView(line10, 0)
    .heightIs(cellH)
    .widthIs(cellH_Title_width);
    
    section4.sd_layout
    .leftSpaceToView(self.scrollV, 0)
    .topSpaceToView(section3,sectionMargin)
    .heightIs(cellH*3)
    .rightSpaceToView(self.scrollV,0);
    
    /* section 5 */
    /** 操作按钮 */
    UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn setTitleColor:__kThemeColor forState:UIControlStateNormal];
    operationBtn.titleLabel.font = Font(15);
    operationBtn.layer.borderColor = __kThemeColor.CGColor;
    operationBtn.layer.borderWidth = 1;
    operationBtn.layer.cornerRadius = 20;
    operationBtn.layer.masksToBounds = YES;
    [operationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    [operationBtn addTarget:self action:@selector(choseOperation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /** 申请退款 */
    UIButton *operationBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn1 setTitleColor:__kThemeColor forState:UIControlStateNormal];
    operationBtn1.titleLabel.font = Font(15);
    operationBtn1.layer.borderColor = __kThemeColor.CGColor;
    operationBtn1.layer.borderWidth = 1;
    operationBtn1.layer.cornerRadius = 20;
    operationBtn1.layer.masksToBounds = YES;
    [operationBtn1 setTitle:@"申请退款" forState:UIControlStateNormal];
    [operationBtn1 addTarget:self action:@selector(choseOperation1:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /** 申请退货 */
    UIButton *operationBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn2 setTitleColor:__kThemeColor forState:UIControlStateNormal];
    operationBtn2.titleLabel.font = Font(15);
    operationBtn2.layer.borderColor = __kThemeColor.CGColor;
    operationBtn2.layer.borderWidth = 1;
    operationBtn2.layer.cornerRadius = 20;
    operationBtn2.layer.masksToBounds = YES;
    [operationBtn2 setTitle:@"申请退货" forState:UIControlStateNormal];
    [operationBtn2 addTarget:self action:@selector(choseOperation2:) forControlEvents:UIControlEventTouchUpInside];
    [section5 sd_addSubviews:@[operationBtn,operationBtn1,operationBtn2]];
    
    
    int orderStatus = [_dataDict[@"order"][@"status"] intValue];
    /** 订单状态
     2 => '已取消',
     3 => '无效',
     4 => '退货',
     5 => '未付款',
     6 => '已付款',
     7 => '已确认',
     8 => '已发货',
     9 => '已收货',  */
    switch (orderStatus) {
        case 2:{
            operationBtn.hidden = YES;
            operationBtn1.hidden = YES;
            operationBtn2.hidden = YES;
        }
            break;
        case 3:{
            operationBtn.hidden = YES;
            operationBtn1.hidden = YES;
            operationBtn2.hidden = YES;
        }
        case 4:{
            [operationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            operationBtn.hidden = NO;
        }
        case 5:{
            [operationBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            operationBtn.hidden = NO;
            operationBtn1.hidden = YES;
            operationBtn2.hidden = YES;
        }
            break;
        case 6:{
            operationBtn.hidden = YES;
            operationBtn1.hidden = NO;
            operationBtn2.hidden = YES;
        }
            break;
        case 7:{
            operationBtn.hidden = YES;
            operationBtn1.hidden = NO;
            operationBtn2.hidden = YES;
        }
            break;
        case 8:{
            [operationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            operationBtn.hidden = NO;
            operationBtn1.hidden = NO;
            operationBtn2.hidden = NO;
        }
            break;
        case 9:{
            [operationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            operationBtn.hidden = NO;
            operationBtn1.hidden = YES;
            operationBtn2.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    operationBtn.sd_layout
    .rightSpaceToView(section5,margin)
    .topSpaceToView(section5,5)
    .widthIs(80)
    .heightIs(40);
    
    
    operationBtn1.sd_layout
    .leftSpaceToView(section5,margin)
    .topSpaceToView(section5,5)
    .widthIs(80)
    .heightIs(40);
    
    
    operationBtn2.sd_layout
    .leftSpaceToView(section5,margin*2+80)
    .topSpaceToView(section5,5)
    .widthIs(80)
    .heightIs(40);
    
    section5.sd_layout
    .leftSpaceToView(self.scrollV, 0)
    .topSpaceToView(section4,sectionMargin)
    .heightIs(50)
    .rightSpaceToView(self.scrollV,0);
    
    
}


- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = Font(15);
    return label;
}





#pragma mark - 请求 数据
-(void)requestData
{
    
    NSDictionary *dict = @{@"id":self.soNo};
    
    [[HttpManager shareInstance] get:@"order" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        //            1.goods        购买的商品
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
        //
        //            2.discount_array    优惠信息
        //
        //            title        优惠名称
        //
        //            num        优惠金额
        //
        //            3.order
        //
        //            shipping_name    收货人名称
        //
        //            shipping_phone    收货人联系电话
        //
        //            shipping_id_card    收货人身份证
        //
        //            shipping_address    收货人地址
        //
        //            shipping_type_name    收货类型名称
        //
        //            order_sn    订单编码
        //
        //            status_name    订单状态名称
        //
        //            status        订单状态（判断用）
        //
        //            shipping_amount    运费
        //
        //            all_amount    总金额
        //
        //            score        使用余额
        //
        //            pay_amount    实际付款金额
        //
        //            pay_type_name    支付类型名称
        //
        //            pay_status    支付状态名称
        //
        //            pay_date    支付时间
        //
        //            remark        用户备注
        //
        //            4. store_address    门店地址
        
        self.dataDict = (NSDictionary *)response;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self createUI];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
    
    
    
    
}



- (void)choseOperation:(UIButton *)sender
{
    
    int orderStatus = [_dataDict[@"order"][@"status"] intValue];
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
            [self deleteOrder];
        }
            break;
        case 3:{
            [self deleteOrder];
        }
            break;
        case 4:{
            
        }
            break;
        case 5:{
            [self pay:_dataDict[@"order"]];
        }
            break;
        case 6:{
            
        }
            break;
        case 7:{
            
        }
            break;
        case 8:{
            [self charge];
        }
            break;
        case 9:{
            [self deleteOrder];
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark 退款
- (void)choseOperation1:(UIButton *)sender
{
    
    CMRefundViewController *toPay = [[CMRefundViewController alloc] init];
    toPay.soNo = self.soNo;
    toPay.type = 1;
    [self.navigationController pushViewController:toPay animated:YES];
}

#pragma mark 退货
- (void)choseOperation2:(UIButton *)sender
{
    
    CMRefundViewController *toPay = [[CMRefundViewController alloc] init];
    toPay.soNo = self.soNo;
    toPay.type = 2;
    [self.navigationController pushViewController:toPay animated:YES];
}


#pragma mark 去支付
- (void)pay:(NSDictionary *)dict
{
    
    CMToPayViewController *toPay = [[CMToPayViewController alloc] init];
    //    toPay.soNo = [NSString stringWithFormat:@"%@",dict[@"order_sn"]];
    toPay.soNo = self.soNo;
    toPay.totalPrice = [NSString stringWithFormat:@"%@",dict[@"all_amount"]];
    [self.navigationController pushViewController:toPay animated:YES];
}
#pragma mark 确认收货
- (void)charge
{
    /** _id 订单ID */
    
    NSDictionary *postDic = @{@"id":self.soNo};
    
    [[HttpManager shareInstance] get:@"deal_receipt_order" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self alertWithMessage:response[@"msg"]];
            
        });
        
        [self requestData];
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:response[@"msg"]];
        });
        
    }];
    
    
}




#pragma mark 删除订单
- (void)deleteOrder
{
    /** _id 订单ID */
    
    NSDictionary *postDic = @{@"id":self.soNo};
    
    [[HttpManager shareInstance] get:@"deal_delete_order" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:response[@"msg"]];
        });
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:response[@"msg"]];
        });
    }];
    
    
}



#pragma mark 取消订单
- (void)cancelOrder:(NSDictionary *)dict
{
    /** _id 订单ID */
    
    NSDictionary *postDic = @{@"id":dict[@"id"]};
    
    [[HttpManager shareInstance] get:@"deal_cancel_order" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:response[@"msg"]];
        });
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:response[@"msg"]];
        });
    }];
    
    
    
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
