//
//  CMDiscoverViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMDiscoverViewController.h"
#import "DiscoverCell.h"
#import "CMWebViewController.h"
@interface CMDiscoverViewController ()
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;
@end

@implementation CMDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTable];
    [self requestData];
}


- (void)creatTable
{
    [self createTableViewFrame:CGRectMake(5, __KViewY, __kWindow_Width - 2*5, __kWindow_Height - __KtabBarHeight - __KViewY) Style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverCell" bundle:nil] forCellReuseIdentifier:@"discoverCell"];
    
}


#pragma mark - 请求 数据
-(void)requestData
{
    
    [[HttpManager shareInstance] get:@"pages" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        //        NSLog(@"----返回数据：%@",response);
        _dataDict = (NSDictionary *)response;
        self.dataArray = _dataDict[@"items"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
        });
        
        
        
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"%@",response);
    }];
    
    
    
}

#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
    //    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 191.f;
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
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoverCell" forIndexPath:indexPath];
    cell.dataDict = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *model = self.dataArray[indexPath.section];
    CMWebViewController *goodsVc = [[CMWebViewController alloc]init];
    goodsVc.webId = model[@"id"];
    goodsVc.webVcTitle = model[@"title"];
    [self.navigationController pushViewController:goodsVc animated:YES];
    //
    
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
