//
//  CMExpressViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMExpressViewController.h"
#import "CMExpressCell.h"
#define cellH 50
#define cellH_low 30
@interface CMExpressViewController ()

@end

@implementation CMExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"快递信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableViewFrame:CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY) Style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self requestData];
}


#pragma mark - 请求 数据
-(void)requestData
{
    
    NSDictionary *dict = @{@"id":self.soNo};
    [[HttpManager shareInstance] get:@"express" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        self.dataArray = response[@"express"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
        });
    }];
    
    
    
}

#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
    //    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *temp = self.dataArray[section][@"items"];
    return temp.count;
    //    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CMExpressCell cellHeight];
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9.0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  cellH_low*2 + cellH;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSDictionary *dict = self.dataArray[section];
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, __kWindow_Width, cellH_low*2 + cellH);
    
    UILabel *label = [[UILabel alloc] init];
    label.font = Font(15);
    label.text = @"快递单号:";
    label.textColor = [UIColor lightGrayColor];
    label.frame = CGRectMake(20, 0, 80, cellH_low);
    [headView addSubview:label];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.font = Font(15);
    //        amountLabel.textColor = __kThemeColor;
    amountLabel.frame = CGRectMake(label.right + 5, 0, __kWindow_Width - label.right, cellH_low);
    amountLabel.text = [NSString stringWithFormat:@"%@",dict[@"courier_no"]];
    [headView addSubview:amountLabel];
    
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = Font(15);
    label1.text = @"信息来源:";
    label1.textColor = [UIColor lightGrayColor];
    label1.frame = CGRectMake(20, label.bottom, 80, cellH_low);
    [headView addSubview:label1];
    
    UILabel *amountLabel1 = [[UILabel alloc] init];
    amountLabel1.font = Font(15);
    //        amountLabel1.textColor = __kThemeColor;
    amountLabel1.frame = CGRectMake(label1.right + 5, label.bottom, __kWindow_Width - label1.right, cellH_low);
    amountLabel1.text = [NSString stringWithFormat:@"%@",dict[@"courier_title"]];
    [headView addSubview:amountLabel1];
    
    
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(0, amountLabel1.bottom , __kWindow_Width, cellH);
    hintLabel.backgroundColor = [UIColor whiteColor];
    hintLabel.text = @"     物流跟踪";
    hintLabel.font = Font(17);
    [headView addSubview:hintLabel];
    
    UIView *line = [self createDefaultStyleLineFrame:CGRectMake(0, headView.height - __kLine_Width_Height, __kWindow_Width, __kLine_Width_Height)];
    [headView addSubview:line];
    
    return headView;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *temp = self.dataArray[indexPath.section][@"items"];
    CMExpressCell *cell = [CMExpressCell cellWithTableView:tableView];
    cell.dataDict = temp[indexPath.row];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
