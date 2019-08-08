//
//  CMMessageViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMMessageViewController.h"

@interface CMMessageViewController ()

@end

@implementation CMMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的消息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableViewFrame:CGRectMake(0, __KViewY + 5, __kWindow_Width, __kWindow_Height - __KViewY - 5) Style:UITableViewStylePlain];
    [self requestData];
}




#pragma mark - 请求 数据
-(void)requestData
{
    
    [[HttpManager shareInstance] get:@"messages" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        //        NSLog(@"----返回数据：%@",response);
        
        self.dataArray = response[@"items"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            id        消息编号    删除用
            //
            //            content        消息内容
            //
            //            dateline    消息时间
            //
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
    return 60;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messageId = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:messageId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = Font(15);
    cell.textLabel.textColor = __kcolorText_Black;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    cell.detailTextLabel.font = Font(13);
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row][@"content"];
    cell.detailTextLabel.text = [MyDate getDateWithTimeStamp:self.dataArray[indexPath.row][@"dateline"]];
    
    //    cell.textLabel.text = @"消息消息";
    //    cell.detailTextLabel.text = @"2017-01-07";
    return cell;
    
}




#pragma mark --- 向左滑动对地址 删除 修改
- (nullable NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteButton=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        /** 删除 */
        NSDictionary *dict = self.dataArray[indexPath.row];
        
        [[HttpManager shareInstance] get:@"delete_msg" parameter:@{@"id":dict[@"dict"]} withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
            
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } failure:^(NSURLSessionDataTask *operation, id response) {
            
        }];
        
    }];
    
    return @[deleteButton];
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
