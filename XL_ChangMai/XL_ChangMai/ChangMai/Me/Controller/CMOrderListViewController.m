//
//  CMOrderListViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMOrderListViewController.h"
#import "CMOrderCell.h"
#import "CMOrderDetailViewController.h"
#import "CMToPayViewController.h"
#import "CMExpressViewController.h"
@interface CMOrderListViewController ()
/** 选择订单类型的按钮 */
@property (nonatomic,strong) UIButton *selectBtn;
/** 订单类型 */
@property (nonatomic,strong) NSNumber *order_type;
@end

@implementation CMOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    //设置默认值
    _order_type = @0;
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(requestData) withObject:nil];
}

#pragma mark - 请求 数据
-(void)requestData
{
    
    NSDictionary *dict = @{@"st":_order_type};
    
    [[HttpManager shareInstance] get:@"orders" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        self.dataArray = response[@"items"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
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
            
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
    
    
    
    
}



- (void)createUI
{
    NSArray *titleArr = @[@"全部",@"待付款",@"待收货",@"待评价"];
    
    CGFloat btnW = __kWindow_Width/titleArr.count;
    
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, __KViewY + 3, __kWindow_Width,40);
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, topView.height)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:__kThemeColor forState:UIControlStateSelected];
        btn.titleLabel.font = Font(12);
        [btn addTarget:self action:@selector(orderType:) forControlEvents:UIControlEventTouchUpInside];
        if ([titleArr[i] isEqualToString:@"全部"]) {
            btn.selected = YES;
            _selectBtn = btn;
        }
        [topView addSubview:btn];
        
    }
    
    if (titleArr.count > 1) {
        for (int i = 0; i < titleArr.count - 1; i ++) {
            UIView *line = [self createDefaultStyleLineFrame:CGRectMake(btnW*(i+1), 5, __kLine_Width_Height, topView.height - 2*5)];
            line.tag = 100 + i;
            [topView addSubview:line];
        }
    }
    
    
    
    [self createTableViewFrame:CGRectMake(0, topView.bottom, __kWindow_Width, __kWindow_Height - topView.bottom) Style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
    //    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CMOrderCell cellHeight:self.dataArray[indexPath.section]];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001f;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMOrderCell *cell = [CMOrderCell cellWithTableView:tableView];
    cell.dict = self.dataArray[indexPath.section];
    [cell setPayblock:^(NSDictionary *dict) {
        CMToPayViewController *toPay = [[CMToPayViewController alloc] init];
        toPay.soNo = [NSString stringWithFormat:@"%@",dict[@"id"]];
        toPay.totalPrice = [NSString stringWithFormat:@"%@",dict[@"amount"]];
        [self.navigationController pushViewController:toPay animated:YES];
    }];
    
    /** 确认收货 */
    [cell setChargeblock:^(NSDictionary *dict) {
        /** _id 订单ID */
        
        NSDictionary *postDic = @{@"id":dict[@"id"]};
        
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
        
        
    }];
    
    /** 删除订单 */
    [cell setDeleteOrder:^(NSDictionary *dict) {
        /** _id 订单ID */
        
        NSDictionary *postDic = @{@"id":dict[@"id"]};
        
        [[HttpManager shareInstance] get:@"deal_delete_order" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertWithMessage:response[@"msg"]];
            });
            [self requestData];
            
        } failure:^(NSURLSessionDataTask *operation, id response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertWithMessage:response[@"msg"]];
            });
        }];
        
        
    }];
    
    /** 取消订单 */
    [cell setCancleOrder:^(NSDictionary *dict) {
        /** _id 订单ID */
        
        NSDictionary *postDic = @{@"id":dict[@"id"]};
        
        [[HttpManager shareInstance] get:@"deal_cancel_order" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertWithMessage:response[@"msg"]];
            });
            [self requestData];
            
        } failure:^(NSURLSessionDataTask *operation, id response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertWithMessage:response[@"msg"]];
            });
        }];
        
        
    }];
    
    
    /** 查看物流 */
    [cell setBlockCheckInvoice:^(NSDictionary *dict) {
        CMExpressViewController *toPay = [[CMExpressViewController alloc] init];
        toPay.soNo = [NSString stringWithFormat:@"%@",dict[@"id"]];
        [self.navigationController pushViewController:toPay animated:YES];
    }];
    
    /** 申请退款 */
    [cell setBlockCheckInvoice:^(NSDictionary *dict) {
        CMExpressViewController *toPay = [[CMExpressViewController alloc] init];
        toPay.soNo = [NSString stringWithFormat:@"%@",dict[@"id"]];
        [self.navigationController pushViewController:toPay animated:YES];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    ShoppingModel *model = self.dataListArray[indexPath.section];
    CMOrderDetailViewController *detail = [[CMOrderDetailViewController alloc]init];
    //        goodsVc.itemId = model.itemId;
    detail.soNo = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"id"]];
    [self.navigationController pushViewController:detail animated:YES];
    //
    
}


- (void)orderType:(UIButton *)sender
{
    _selectBtn.selected = NO;
    sender.selected = YES;
    _selectBtn = sender;
    if ([sender.titleLabel.text isEqualToString:@"全部"]) {
        _order_type = @0;
    }else if ([sender.titleLabel.text isEqualToString:@"待付款"]) {
        _order_type = @5;
    }else if ([sender.titleLabel.text isEqualToString:@"待收货"]) {
        _order_type = @8;
    }else if ([sender.titleLabel.text isEqualToString:@"待评价"]) {
        _order_type = @10;
    }
    [self performSelectorInBackground:@selector(requestData) withObject:nil];
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
