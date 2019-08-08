//
//  CMAccountViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMAccountViewController.h"
#import "CMAcountCell.h"
#import "CMChargeViewController.h"
@interface CMAccountViewController ()
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;
@end

@implementation CMAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的账户";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableViewFrame:CGRectMake(0, __KViewY + 2, __kWindow_Width, __kWindow_Height - __KViewY - 2) Style:UITableViewStylePlain];
    [self requestData];
}




#pragma mark - 请求 数据
-(void)requestData
{
    
    [[HttpManager shareInstance] get:@"scores" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        _dataDict = response;
        self.dataArray = _dataDict[@"items"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //            1. items    列表
            //
            //            dateline    时间
            //
            //            score        金额
            //
            //            type        类型
            //
            //
            //            2. score    余额
            
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
    
    
    
    
}





#pragma mark tableView delegate And datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.dataArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else if (indexPath.section == 1){
        return [CMAcountCell cellHeight];
    }
    return 0.0001f;
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 50;
    }
    return 0.0000001f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.0000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor clearColor];
        headView.frame = CGRectMake(0, 0, __kWindow_Width, 50);
        
        
        
        NSArray *titleArr = @[@"时间",@"项目",@"收支"];
        CGFloat margin = 20;
        CGFloat labelW = (__kWindow_Width - 2*margin)/3;
        CGFloat labelH = 40;
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        topView.frame = CGRectMake(0, 10, __kWindow_Width, labelH);
        [headView addSubview:topView];
        
        UIView *line = [self createDefaultStyleLineFrame:CGRectMake(0, headView.height - __kLine_Width_Height, __kWindow_Width, __kLine_Width_Height)];
        [headView addSubview:line];
        
        for (int i = 0; i < titleArr.count; i ++) {
            
            UILabel *namelable = [[UILabel alloc] init];
            namelable.font = Font(15);
            namelable.textColor = [UIColor lightGrayColor];
            namelable.frame = CGRectMake(margin + labelW*i, 0, labelW, labelH);
            namelable.text = titleArr[i];
            [topView addSubview:namelable];
        }
        
        
        return headView;
    }
    return [UIView new];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = Font(15);
        cell.textLabel.textColor = __kcolorText_Black;
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        cell.detailTextLabel.font = Font(13);
        
        UILabel *payLabel = [[UILabel alloc]init];
        payLabel.font = Font(15);
        payLabel.frame = CGRectMake(20, 0, 150, 50);
        payLabel.text = [NSString stringWithFormat:@"我的余额：¥%@",_dataDict[@"score"]];
        
        [cell.contentView addSubview:payLabel];
        
        UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [operationBtn setTitleColor:__kThemeColor forState:UIControlStateNormal];
        operationBtn.titleLabel.font = Font(15);
        operationBtn.layer.borderColor = __kThemeColor.CGColor;
        operationBtn.layer.borderWidth = 1;
        operationBtn.layer.cornerRadius = 20;
        operationBtn.layer.masksToBounds = YES;
        [operationBtn setTitle:@"充值" forState:UIControlStateNormal];
        [operationBtn addTarget:self action:@selector(choseOperation:) forControlEvents:UIControlEventTouchUpInside];
        operationBtn.frame = CGRectMake(__kWindow_Width - 80 - 20, 5, 80, 40);
        [cell.contentView addSubview:operationBtn];
        
        return cell;
    }else if (indexPath.section == 1){
        CMAcountCell *acountCell = [CMAcountCell cellWithTableView:tableView];
        acountCell.dataDict = self.dataArray[indexPath.row];
        return acountCell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)choseOperation:(UIButton *)sender
{
    CMChargeViewController *charge = [[CMChargeViewController alloc] init];
    [self.navigationController pushViewController:charge animated:YES];
    
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
