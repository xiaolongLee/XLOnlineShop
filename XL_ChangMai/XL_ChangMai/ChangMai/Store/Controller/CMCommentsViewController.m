//
//  CMCommentsViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMCommentsViewController.h"
#import "CMCommentCell.h"
@interface CMCommentsViewController ()

@end

@implementation CMCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品评价";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableViewFrame:CGRectMake(0, __KViewY + 5, __kWindow_Width, __kWindow_Height - __KViewY - 5) Style:UITableViewStylePlain];
    [self requestData];
}




#pragma mark - 请求 数据
-(void)requestData
{
    
    NSDictionary *postDict = @{@"id":@(self.goodId)};
    [[HttpManager shareInstance] get:@"comments" parameter:postDict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        //        self.dataArray = response[@"comments"];
        [self.dataArray addObjectsFromArray:response[@"comments"]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            content        评论内容
            //            comment_date    评论时间
            //            name        评论人
            //            star        星级
            //            cover        评论人头像
            //            images        评论图片
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
    
    
    
    
}






#pragma mark tableView delegate And datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[CMCommentCell cellWithTableView:tableView] cellHeightWith:self.dataArray[indexPath.row]];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMCommentCell *cell = [CMCommentCell cellWithTableView:tableView];
    cell.dataDict = self.dataArray[indexPath.row];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    [self.navigationController pushViewController:vc animated:YES];
    
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
