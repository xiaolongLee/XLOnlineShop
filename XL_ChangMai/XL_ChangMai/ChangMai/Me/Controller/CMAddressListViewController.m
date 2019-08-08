//
//  CMAddressListViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/2.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMAddressListViewController.h"
#import "CMAddressCell.h"
#import "CMAddAddressViewController.h"
@interface CMAddressListViewController ()

@property(nonatomic,strong)UIView *emptyView;

@end

@implementation CMAddressListViewController

-(UIView *)emptyView
{
    if (!_emptyView) {
        
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = __kViewBgColor;
        headView.frame = CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height);
        
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"-address_icon"]];
        logoImageView.frame = CGRectMake(0, 40, __kWindow_Width, 124);
        logoImageView.contentMode = UIViewContentModeCenter;
        [headView addSubview:logoImageView];
        
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.frame = CGRectMake(0, logoImageView.bottom + 10, __kWindow_Width, 20);
        hintLabel.text = @"还没有收获地址？";
        hintLabel.textColor = [UIColor lightGrayColor];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.font = Font(17);
        [headView addSubview:hintLabel];
        
        
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setTitle:@"新增收获地址" forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(60, hintLabel.bottom + 50, __kWindow_Width - 2*60, 50);
        backBtn.layer.cornerRadius = 25;
        backBtn.layer.masksToBounds = YES;
        [backBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(addAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:backBtn];
        
        _emptyView = headView;
    }
    return _emptyView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(requestData) withObject:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收获地址管理";
    [self createUI];
}


- (void)createUI
{
    if (/* DISABLES CODE */ (0)) {
        [self.view addSubview:self.emptyView];
    }else{
        
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor clearColor];
        headView.frame = CGRectMake(0, __kWindow_Height - 60, __kWindow_Width, 60);
        
        
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setTitle:@"新增收获地址" forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(60,5, __kWindow_Width - 2*60, 50);
        backBtn.layer.cornerRadius = 25;
        backBtn.layer.masksToBounds = YES;
        [backBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(addAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:backBtn];
        [self.view addSubview:headView];
        
        [self createTableViewFrame:CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY - headView.height) Style:UITableViewStyleGrouped];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}


#pragma mark - 请求 数据
-(void)requestData
{
    
    [[HttpManager shareInstance] get:@"shippings" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        self.dataArray = response[@"items"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
}


-(void)setDefaultAddress:(NSDictionary *)dataDict
{
    [ProgressAlertView showWithMessage:@"加载中..."];
    NSDictionary *dict = @{@"id":dataDict[@"id"]};
    [[HttpManager shareInstance] get:@"change_shipping_default" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressAlertView hideHUD];
            [MessageAlertView showWithMessage:response[@"msg"]];
            [self requestData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressAlertView hideHUD];
            [MessageAlertView showWithMessage:response[@"msg"]];
        });
    }];
    
}

-(void)deleteAddress:(NSDictionary *)dataDict
{
    [ProgressAlertView showWithMessage:@"加载中..."];
    NSDictionary *dict = @{@"id":dataDict[@"id"]};
    [[HttpManager shareInstance] get:@"delete_shipping" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        //        NSLog(@"----返回数据：%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ProgressAlertView hideHUD];
            [MessageAlertView showWithMessage:response[@"msg"]];
            [self requestData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressAlertView hideHUD];
            [MessageAlertView showWithMessage:response[@"msg"]];
        });
    }];
    
}


-(void)editAddress:(NSDictionary *)dataDict
{
    
    CMAddAddressViewController *goodsVc = [[CMAddAddressViewController alloc]init];
    goodsVc.addressId = [dataDict[@"id"] longLongValue];
    [self.navigationController pushViewController:goodsVc animated:YES];
    
}

- (void)addAddressBtnClick:(UIButton *)sender
{
    CMAddAddressViewController *add = [[CMAddAddressViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
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
    return [CMAddressCell cellHeight];
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
    CMAddressCell *cell = [CMAddressCell cellWithTableView:tableView];
    [cell setSetDefaultAddress:^(NSDictionary *dataDict) {
        [self setDefaultAddress:dataDict];
    }];
    
    
    [cell setDeleteAddress:^(NSDictionary *dataDict) {
        [self deleteAddress:dataDict];
    }];
    
    [cell setEditAddress:^(NSDictionary *dataDict) {
        [self editAddress:dataDict];
    }];
    
    cell.dataDict = self.dataArray[indexPath.section];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSettlement){
        if (self.settlementBlock) {
            _settlementBlock(self.dataArray[indexPath.section]);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    
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
