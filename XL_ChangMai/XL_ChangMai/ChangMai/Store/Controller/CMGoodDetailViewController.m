//
//  CMGoodDetailViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMGoodDetailViewController.h"
#import "SDCycleScrollView.h"
#import "MeCellButton.h"
#import "CMShopCarViewController.h"
#import "CMSettleViewController.h"
#import "CMCommentsViewController.h"
#import "CMGoCommentViewController.h"
#define mySpacing 10
#define footViewH 50
@interface CMGoodDetailViewController ()<SDCycleScrollViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollV;
/** 详情 */
@property (nonatomic,strong) UIWebView *webViewDetail;
/** headerView */
@property (nonatomic,strong) UIView *headerView;
/** commentView */
@property (nonatomic,strong) UIView *commentView;

/** 轮播图array */
@property (nonatomic,strong) NSMutableArray *bannerMArray;
/** 轮播图 */
@property (nonatomic,weak) UIImageView *bannerView;

/** 去评价按钮 */
@property (nonatomic,strong) UIButton *commentBtn;
/** 商品名称 */
@property (nonatomic,strong) UILabel *labelGoodsTitle;
/** 现价 */
@property (nonatomic,strong) UILabel *labelNowPrice;
/** 市场价格 */
@property (nonatomic,strong) UILabel *labelDefaultPrice;
/** 是否包邮 */
@property (nonatomic,strong) UILabel *expressFee;
/** 发货方式 */
@property (nonatomic,strong) UIButton *deliverWay;
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;

@end
/** 轮播图高度 */
static float bannerHeight = 250;
@implementation CMGoodDetailViewController

-(NSMutableArray *)bannerMArray
{
    if (!_bannerMArray) {
        _bannerMArray = [NSMutableArray array];
    }
    return _bannerMArray;
}


-(UIWebView *)webViewDetail
{
    if (!_webViewDetail) {
        _webViewDetail = [[UIWebView alloc]init];
        _webViewDetail.delegate = self;
        //        _webViewDetail.scalesPageToFit = YES;
        _webViewDetail.scrollView.contentMode = UIViewContentModeCenter;
        
    }
    return _webViewDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self requestData];
}


- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.frame = CGRectMake(0, 0, __kWindow_Width, __kWindow_Height - __KViewY - footViewH);
    //    scrollV.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollV];
    self.scrollV = scrollV;
    
    /**   footerView  */
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, __kWindow_Height - __KViewY - footViewH, self.view.width, footViewH)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    UIView *line6 = [[UIView alloc] init];
    line6.frame = CGRectMake(0, 0, footerView.width, __kLine_Width_Height);
    line6.backgroundColor = __kLineColor;
    [footerView addSubview:line6];
    
    
    
    CGFloat buttonPayW = 100;
    /**   立即购买  */
    UIButton *buttonPay = [[UIButton alloc] init];
    buttonPay.frame = CGRectMake(__kWindow_Width - buttonPayW, 0,buttonPayW, footViewH);
    [buttonPay setTitle:@"立即购买" forState:UIControlStateNormal];
    [buttonPay addTarget:self action:@selector(buttonPayClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonPay.backgroundColor = __kThemeColor;
    buttonPay.titleLabel.font = Font(17);
    [footerView addSubview:buttonPay];
    
    /**   加入购物车  */
    UIButton *buttonAddCar = [[UIButton alloc] init];
    buttonAddCar.frame = CGRectMake(buttonPay.left - buttonPayW, 0,buttonPayW, footViewH);
    [buttonAddCar setTitle:@"加入购物车" forState:UIControlStateNormal];
    [buttonAddCar addTarget:self action:@selector(buttonAddCarClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonAddCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonAddCar.backgroundColor = __kGreen_Color;
    buttonAddCar.titleLabel.font = buttonPay.titleLabel.font;
    [footerView addSubview:buttonAddCar];
    
    CGFloat leftBtnW = 50;
    /**   客服  */
    MeCellButton *buttonCustomer = [[MeCellButton alloc] init];
    buttonCustomer.frame = CGRectMake(0, 0,leftBtnW, footViewH);
    [buttonCustomer setTitle:@"客服" forState:UIControlStateNormal];
    [buttonCustomer setImage:[UIImage imageNamed:@"footer4"] forState:UIControlStateNormal];
    buttonCustomer.imageView.contentMode = UIViewContentModeCenter;
    buttonCustomer.titleLabel.textAlignment = NSTextAlignmentCenter;
    [buttonCustomer addTarget:self action:@selector(customerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonCustomer setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    buttonCustomer.titleLabel.font = Font(12);
    [footerView addSubview:buttonCustomer];
    
    /**   购物车  */
    MeCellButton *buttonCar = [[MeCellButton alloc] init];
    buttonCar.hidden = YES;
    buttonCar.frame = CGRectMake(buttonCustomer.right, 0,leftBtnW, footViewH);
    [buttonCar setTitle:@"去评价" forState:UIControlStateNormal];
    [buttonCar setImage:[UIImage imageNamed:@"footer4"] forState:UIControlStateNormal];
    buttonCar.imageView.contentMode = UIViewContentModeCenter;
    buttonCar.titleLabel.textAlignment = NSTextAlignmentCenter;
    [buttonCar addTarget:self action:@selector(shopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonCar setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    buttonCar.titleLabel.font = buttonCustomer.titleLabel.font;
    [footerView addSubview:buttonCar];
    _commentBtn = buttonCar;
    
    
    
    /** headerView  包含轮播图250   */
    CGFloat headMargin = 8;
    CGFloat hotViewHeight = 130;
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kWindow_Width, bannerHeight + headMargin + hotViewHeight)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.scrollV addSubview:_headerView];
    
    
    /** 轮播图 */
    UIImageView *bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width, bannerHeight)];
    //    bannerView.image = [UIImage imageNamed:@"banner"];
    bannerView.userInteractionEnabled = YES;
    [_headerView addSubview:bannerView];
    _bannerView = bannerView;
    
    
    UIView *line = [self createDefaultStyleLineFrame:CGRectMake(0, bannerView.bottom, __kWindow_Width, __kLine_Width_Height)];
    [_headerView addSubview:line];
    
    
    /** 名字 */
    self.labelGoodsTitle = [[UILabel alloc] init];
    _labelGoodsTitle.frame = CGRectMake(mySpacing, bannerView.bottom, __kWindow_Width - 2*mySpacing, 40);
    _labelGoodsTitle.numberOfLines = 0;
    _labelGoodsTitle.font = FontBold(18);
    //    _labelGoodsTitle.text = @"阿斯顿立法局哦啊啥的佛阿松地方哦阿桑地方啊啥的发色分";
    [_headerView sd_addSubviews:@[_labelGoodsTitle]];
    
    //    _labelGoodsTitle.sd_layout
    //    .leftSpaceToView(_headerView,mySpacing)
    //    .topSpaceToView(line,0)
    //    .widthIs(__kWindow_Width)
    //    .autoHeightRatio(0);
    
    UIView *line1 = [self createDefaultStyleLineFrame:CGRectMake(0, _labelGoodsTitle.bottom, __kWindow_Width, __kLine_Width_Height)];
    [_headerView addSubview:line1];
    
    /** 现在价格 */
    self.labelNowPrice = [self createLabelWithFrame:CGRectMake(mySpacing, line1.bottom, 100, 40)];
    _labelNowPrice.font = Font(20);
    _labelNowPrice.textColor = __kThemeColor;
    //    _labelNowPrice.text = @"999";
    [_headerView addSubview:_labelNowPrice];
    
    /** 市场价格 */
    self.labelDefaultPrice = [[UILabel alloc] init];
    self.labelDefaultPrice.frame = CGRectMake(_labelNowPrice.right, _labelNowPrice.top + 5, 100, 30);
    _labelDefaultPrice.textColor = [UIColor lightGrayColor];
    //    _labelDefaultPrice.text = @"1999";
    [_headerView addSubview:_labelDefaultPrice];
    
    /** 邮费 */
    _expressFee = [[UILabel alloc] init];
    _expressFee.frame = CGRectMake(__kWindow_Width - mySpacing - 100, _labelNowPrice.top, 100, _labelNowPrice.height);
    _expressFee.textAlignment = NSTextAlignmentRight;
    _expressFee.font = Font(15);
    [_headerView addSubview:_expressFee];
    
    UIView *line2 = [self createDefaultStyleLineFrame:CGRectMake(0, _labelNowPrice.bottom, __kWindow_Width, __kLine_Width_Height)];
    [_headerView addSubview:line2];
    
    
    
    NSArray *titleArr = @[@"  正品保证",@"  保税直邮",@"  海关监督"];
    
    CGFloat btnLeft = 20;
    CGFloat btnW = (__kWindow_Width - 2*btnLeft)/titleArr.count;
    CGFloat btnH = 40;
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i + btnLeft, line2.bottom, btnW, btnH)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = Font(14);
        [_headerView addSubview:btn];
        
        if ([titleArr[i] isEqualToString:@"  保税直邮"]) {
            _deliverWay = btn;
        }
        
    }
    
    _headerView.height = line2.bottom + btnH;
    
    
    
    self.webViewDetail.frame = CGRectMake(0,_headerView.bottom + 9, __kWindow_Width, 0.00001);
    
    [self.scrollV addSubview:_webViewDetail];
    
    self.scrollV.contentSize = CGSizeMake(__kWindow_Width, self.webViewDetail.bottom);
    
}



#pragma mark - 创建label
-(UILabel *)createLabelWithFrame:(CGRect )frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = Font(14);
    return label;
}




#pragma mark - 请求 数据
-(void)requestData
{
    
    
    NSDictionary *dict = @{@"id":@(self.goodId),
                           @"store_id":@(self.storeId?self.storeId:0)};
    NSLog(@"--商品ID:%@",dict);
    
    [[HttpManager shareInstance] get:@"good" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        _dataDict = (NSDictionary *)response;
        NSLog(@"----返回数据：%@",response);
        NSLog(@"----返回数据：%@",[_dataDict objectForKey:@"images"]);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 轮播图
            self.bannerMArray = [_dataDict objectForKey:@"images"];
            
            //            NSMutableArray *imageURLStringGroup = [NSMutableArray array];
            //
            //            for (NSDictionary *dict in _bannerMArray) {
            //                [imageURLStringGroup addObject:dict[@"img_url"]];
            //            }
            //
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, __kWindow_Width, bannerHeight) imageURLStringsGroup:self.bannerMArray ];
            cycleScrollView.backgroundColor = [UIColor clearColor];
            if (self.bannerMArray.count == 1) {
                cycleScrollView.autoScroll = NO;
            }
            
            cycleScrollView.delegate = self;
            //        cycleScrollView.placeholderImage = [UIImage imageNamed:__KPlaceholderAllStarLoading];
            cycleScrollView.autoScrollTimeInterval = 4.0;
            cycleScrollView.infiniteLoop = YES;
            cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            [_bannerView addSubview:cycleScrollView];
            
            
            
            
            
            self.labelGoodsTitle.text = _dataDict[@"good"][@"title"];
            self.labelNowPrice.text = [NSString stringWithFormat:@"¥ %@",_dataDict[@"good"][@"pay_amount"]];
            
            NSString *allLastPrice = _dataDict[@"good"][@"amount"];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:allLastPrice];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:[allLastPrice rangeOfString:allLastPrice]];
            [self.labelDefaultPrice setAttributedText:attri];
            
            
            NSString *webStr = [NSString stringWithFormat:@"%@%@%@",WEBVIEW_HEAD,_dataDict[@"good"][@"content"],WEBVIEW_END];
            webStr = [webStr stringByReplacingOccurrencesOfString:@"\\" withString:@"" options:NSCaseInsensitiveSearch
                                                            range:NSMakeRange(0, webStr.length)];
            NSLog(@"---%@",webStr);
            
            NSMutableString *str = [[NSMutableString alloc] init];
            
            if ([_dataDict[@"good"][@"is_shipping"] boolValue]) {
                [str appendString:@"包邮"];
            }else{
                [str appendString:@"不包邮"];
                
            }
            
            if ([_dataDict[@"good"][@"is_tax"] boolValue]) {
                [str appendString:@"  包税"];
            }else{
                [str appendString:@"  不包税"];
                
            }
            
            
            _expressFee.text = str;
            NSString *deliverTitle = [NSString stringWithFormat:@"  %@",_dataDict[@"good"][@"shipping_name"]];
            [_deliverWay setTitle:deliverTitle forState:UIControlStateNormal];
            
            
            
            
            if ([_dataDict[@"comment_count"] intValue]) {
                
                _commentView = [[UIView alloc] init];
                _commentView.backgroundColor = [UIColor whiteColor];
                [self.scrollV addSubview:_commentView];
                
                UILabel *goodDetail = [[UILabel alloc] init];
                goodDetail.font = Font(15);
                goodDetail.textColor = [UIColor whiteColor];
                goodDetail.backgroundColor = __kThemeColor;
                goodDetail.frame = CGRectMake(0, 0, __kWindow_Width , 40);
                goodDetail.text = [NSString stringWithFormat:@"    商品评价(%@)",_dataDict[@"comment_count"]];
                [_commentView addSubview:goodDetail];
                
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
                cell.frame = CGRectMake(0, goodDetail.bottom, __kWindow_Width, 50);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2;
                cell.imageView.layer.masksToBounds = YES;
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"comments"][@"cover"]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        cell.imageView.image = image;
                    }else{
                        
                    }
                    
                }];
                cell.textLabel.text = _dataDict[@"comments"][@"name"];
                cell.detailTextLabel.text = _dataDict[@"comments"][@"content"];
                [_commentView addSubview:cell];
                
                _commentView.frame = CGRectMake(0, _headerView.bottom + 9, __kWindow_Width, cell.bottom);
                [_commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsComments)]];
                
                self.webViewDetail.top = _commentView.bottom + 9;
                
            }
            
            
            
            
            [self.webViewDetail loadHTMLString:webStr baseURL:[NSURL URLWithString:BASE_URL]];
            
            
            if ([_dataDict[@"is_comment"] boolValue]) {
                _commentBtn.hidden = NO;
            }else{
                _commentBtn.hidden = YES;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:__KFavoriteGood object:nil userInfo:@{@"collect":_dataDict[@"collect"]}];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:__KUpdateGoodParamData object:nil userInfo:@{@"data":_dataDict}];
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
}




-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat width = __kWindow_Width - 15 ;
    NSString *str1 = @"var imgs = document.getElementsByTagName('img');";
    NSString *str2 =[NSString stringWithFormat:@"%@%f%@",@"for (var i=0;i<imgs.length;i++){var img = imgs[i]; img.style.width = '",width,@"px';};"];
    [_webViewDetail stringByEvaluatingJavaScriptFromString:str1];
    [_webViewDetail stringByEvaluatingJavaScriptFromString:str2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGSize contentSize = webView.scrollView.contentSize;
        if (contentSize.height < 10) {
            contentSize = CGSizeMake(0, 0);
        }
        
        _webViewDetail.frame = CGRectMake(0, _headerView.height + 9, __kWindow_Width, contentSize.height);
        _webViewDetail.scrollView.userInteractionEnabled = NO;
        
        if ([_dataDict[@"comment_count"] intValue]) {
            _webViewDetail.top = _commentView.bottom + 9;
        }
        self.scrollV.contentSize = CGSizeMake(__kWindow_Width, self.webViewDetail.bottom);
        //        [self.scrollView setContentOffset:CGPointMake(0,- __KViewY -5)];
    });
    
}


#pragma mark - 加入购物车
- (void)buttonAddCarClick:(UIButton *)sender
{
    if (![[[LoginUser user] isOnLine] boolValue]) {
        
        return;
    }
    
    //    NSDictionary *dict = @{@"id":@(self.goodId)};
    sender.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"id":@(self.goodId),
                           @"num":@1};
    NSLog(@"--商品ID:%@",dict);
    
    [[HttpManager shareInstance] get:@"deal_good_cart" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
            sender.userInteractionEnabled = YES;
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
            sender.userInteractionEnabled = YES;
        });
    }];
    
}


#pragma mark - 收藏
-(void)addFavorite
{
    //    NSDictionary *dict = @{@"id":@(self.goodId)};
    
    /*
     1 . 商品编号    id    int
     2 . 操作类型    type    int    0为取消收藏，1为收藏
     */
    
    
    
    NSInteger type = 1;
    NSDictionary *dict = @{@"id":@(self.goodId),
                           @"type":@(type)};
    
    NSLog(@"----参数：%@",dict);
    [[HttpManager shareInstance] get:@"deal_good_collect" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
            
        });
    }];
    
}



- (void)shopCarBtnClick:(UIButton *)sender
{
    //    if (![[[LoginUser user] isOnLine] boolValue]) {
    //
    //        return;
    //    }
    //    CMShopCarViewController *detailVc = [[CMShopCarViewController alloc]init];
    //    detailVc.title = @"购物车";
    //    detailVc.isInHome = NO;
    //    [self.navigationController pushViewController:detailVc animated:YES];
    //
    
    
    CMGoCommentViewController *detailVc = [[CMGoCommentViewController alloc]init];
    detailVc.goodId = self.goodId;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}



- (void)customerBtnClick:(UIButton *)sender
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_dataDict[@"store_phone"]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}



#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            UITextField *txtName = [alertView textFieldAtIndex:0];
            if (txtName.text.length) {
                
                NSInteger num = [txtName.text integerValue];
                
                //                sender.userInteractionEnabled = NO;
                NSDictionary *dict = @{@"id":@(self.goodId),
                                       @"num":@(num)};
                NSLog(@"--商品ID:%@",dict);
                
                [[HttpManager shareInstance] get:@"deal_good_cart" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
                    NSLog(@"----返回数据：%@",response);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //                        sender.userInteractionEnabled = YES;
                        
                        CMSettleViewController *settle = [[CMSettleViewController alloc] init];
                        
                        NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:_dataDict[@"good"]];
                        [dd setObject:[NSString stringWithFormat:@"%ld",(long)num] forKey:@"good_number"];
                        settle.sourceType = 1;
                        settle.cart_Id = [NSString stringWithFormat:@"%@",response[@"cart_id"]];
                        settle.goodsArr = @[dd];
                        long long storeId =  [[[LoginUser user] store_id] longLongValue];
                        settle.storeId = storeId;
                        settle.storeAddress = [[LoginUser user] store_Address];
                        [self.navigationController pushViewController:settle animated:YES];
                        
                    });
                    
                } failure:^(NSURLSessionDataTask *operation, id response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //                        sender.userInteractionEnabled = YES;
                    });
                }];
                
                
                
            }
            
        }
    }
    
    
}



- (void)buttonPayClick:(UIButton *)sender
{
    if (![[[LoginUser user] isOnLine] boolValue]) {
        
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买数量" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.tag = 100;
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入购买数量";
    txtName.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
    
}


- (void)goodsComments
{
    
    CMCommentsViewController *detailVc = [[CMCommentsViewController alloc]init];
    detailVc.goodId = self.goodId;
    [self.navigationController pushViewController:detailVc animated:YES];
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
