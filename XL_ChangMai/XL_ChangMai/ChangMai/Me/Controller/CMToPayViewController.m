//
//  CMToPayViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMToPayViewController.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"
//#import "Order.h"
//#import "ApiXml.h"
//#import "DataSigner.h"
//微信支付
//#import "WechatPayManager.h"
#import "CMTabBarController.h"
#define cellH 50

@interface CMToPayViewController ()
/**支付类型 1 支付宝支付，2 微信支付，3 银联支付*/
@property (nonatomic,strong) NSNumber * payType;
@end

@implementation CMToPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付";
    //默认微信支付
    _payType = @1;
    [self createUI];
}

- (void)createUI
{
    [self createTableViewFrame:CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY) Style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    footView.frame = CGRectMake(0, 0, __kWindow_Width, 100);
    
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(60,footView.height - 50, __kWindow_Width - 2*60, 50);
    backBtn.layer.cornerRadius = 25;
    backBtn.layer.masksToBounds = YES;
    [backBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:backBtn];
    
    self.tableView.tableFooterView = footView;
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"image":@"wx_logo",@"title":@"微信支付",@"selected":@NO}];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:@{@"image":@"zfb_logo",@"title":@"支付宝支付",@"selected":@YES}];
    
    self.dataArray = [NSMutableArray arrayWithArray:@[dict1,dict]];
}


- (void)payBtnClick:(UIButton *)sender
{
    
    NSDictionary *postDict = @{@"id":[NSNumber numberWithInt:[self.soNo intValue]],
                               @"score":self.totalPrice,
                               @"type":_payType};
    
    [[HttpManager shareInstance] post:@"order_pay" parameter:postDict withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        
        sender.enabled = YES;
        NSLog(@"---%@",response);
        
        NSDictionary *dic = (NSDictionary *)response;
        
        //        [self alertWithMessage:response[@"msg"]];
        
        if ([dic[@"result"] intValue] == 1) {//成功
            
            if ([dic[@"is_pay"] boolValue]) {//需要支付
                
                if ([_payType integerValue] == 1) {//支付宝
                    NSLog(@"-------选择了支付宝-------------");
                    
                    NSString *str = dic[@"ali_pay_info"];
                    
                    [self ZhiFuBaoPayWihtOrderInfo:str orderId:self.soNo];
                    
                }else if ([_payType integerValue] == 2){//微信
                    NSLog(@"%@",[dic[@"wx_pay_info"] class]);
                    NSDictionary *ddd = dic[@"wx_pay_info"];
                    NSString *prePayId = ddd[@"prepayid"];
                    NSString *signString = ddd[@"sign"];
                    NSString *time_stamp = ddd[@"timestamp"];
                    NSString *noncestr = ddd[@"noncestr"];
                    
                    [self  wxPayWithOrdeNO: self.soNo   price:[NSString  stringWithFormat:@"%.02f", [self.totalPrice floatValue]*100 ] prePayId:prePayId signString:signString time_stamp:time_stamp noncestr:noncestr];
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

#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return self.dataArray.count;
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return self.dataArray.count;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001f;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return cellH + 10;
    }
    
    return 0.0000001f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor clearColor];
        headView.frame = CGRectMake(0, 0, __kWindow_Width, cellH + 10);
        
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.frame = CGRectMake(0, 10, __kWindow_Width, cellH);
        hintLabel.backgroundColor = [UIColor whiteColor];
        hintLabel.text = @"     选择支付方式";
        hintLabel.textColor = [UIColor lightGrayColor];
        hintLabel.font = Font(17);
        [headView addSubview:hintLabel];
        
        UIView *line = [self createDefaultStyleLineFrame:CGRectMake(0, headView.height - __kLine_Width_Height, __kWindow_Width, __kLine_Width_Height)];
        [headView addSubview:line];
        
        return headView;
    }
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        UILabel *label = [[UILabel alloc] init];
        label.font = Font(15);
        label.text = @"支付金额:";
        label.frame = CGRectMake(20, 0, 80, cellH);
        [cell.contentView addSubview:label];
        
        UILabel *amountLabel = [[UILabel alloc] init];
        amountLabel.font = Font(15);
        amountLabel.textColor = __kThemeColor;
        amountLabel.text = [NSString stringWithFormat:@"%@",self.totalPrice];
        amountLabel.frame = CGRectMake(label.right + 5, 0, __kWindow_Width - label.right, cellH);
        [cell.contentView addSubview:amountLabel];
        
    }else if (indexPath.section == 1){
        NSDictionary *dict = self.dataArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
        cell.textLabel.text = dict[@"title"];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"radio_icon_now"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"radio_icon"] forState:UIControlStateNormal];
        btn.selected = [dict[@"selected"] boolValue];
        btn.tag = indexPath.row + 1;
        [btn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = CGRectMake(0, 0, 40, 40);
        cell.accessoryView = btn;
        
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    ShoppingModel *model = self.dataListArray[indexPath.section];
    //    GoodsDetailViewController *goodsVc = [[GoodsDetailViewController alloc]init];
    //    goodsVc.itemId = model.itemId;
    //    [self.navigationController pushViewController:goodsVc animated:YES];
    //
    
}


- (void)selectPayWay:(UIButton *)sender
{
    
    for (int i = 0; i < self.dataArray.count; i++) {
        NSMutableDictionary *dict = self.dataArray[i];
        if (i == sender.tag - 1) {
            [dict setObject:@YES forKey:@"selected"];
        }else{
            [dict setObject:@NO forKey:@"selected"];
        }
    }
    
    _payType  = [NSNumber numberWithInteger:sender.tag];
    
    [self.tableView reloadData];
}




#pragma mark 支付宝支付


- (void)ZhiFuBaoPayWihtOrderInfo:(NSString *)aliPay_info orderId:(NSString *)orderId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = myAppScheme;
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
//
//                CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
//                [tabbarController pushOrderDetailViewController:self.soNo];
//
//            }
//            else
//            {
//                /** 支付失败  */
//                [MessageAlertView showWithMessage:@"支付失败"];
//
//                CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
//                [tabbarController pushOrderDetailViewController:self.soNo];
//
//            }
//
//        }];
        
        
        
    });
}




- (void)paySuccessAndFailureHandle
{
    
    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
    [tabbarController pushOrderDetailViewController:self.soNo];
    
}



#pragma mark 微信支付
- (void)wxPayWithOrdeNO:(NSString*)orderNO   price:(NSString*)price prePayId:(NSString *)prePayId signString:(NSString *)signString time_stamp:(NSString *)time_stamp noncestr:(NSString *)noncestr
{
    
    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
    tabbarController.orderNO = orderNO;
    
    //创建支付签名对象 && 初始化支付签名对象
//    WechatPayManager* wxpayManager = [[WechatPayManager alloc]initWithAppID:APP_ID mchID:MCH_ID spKey:PARTNER_ID];
//
//    //获取到实际调起微信支付的参数后，在app端调起支付
//    //生成预支付订单，实际上就是把关键参数进行第一次加密。
//    // NSString* device = [[UserManager defaultManager]userId];
//
//
//#warning 订单编号
//    NSString *orderName = @"畅麦";
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        if(!flag)
//        {
//            [MessageAlertView showWithMessage:@"您尚未安装微信"];
//        }
        
    });
    
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
