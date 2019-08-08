//
//  CMProfileViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/30.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMProfileViewController.h"
#define cellH 50
#define rightMargin 40
@interface CMProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;
@property (strong, nonatomic)UIImageView *imageHead;
@property (strong, nonatomic)  UILabel *labelUserName;
@property (strong, nonatomic)  UILabel *labelUserSex;
@property (strong, nonatomic)  UILabel *labelUserPhone;
@end

@implementation CMProfileViewController

- (UIImageView *)imageHead
{
    if (!_imageHead) {
        
        _imageHead = [[UIImageView alloc] init];
        _imageHead.backgroundColor = [UIColor lightGrayColor];
        _imageHead.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _imageHead;
}




- (UILabel *)labelUserName
{
    if (!_labelUserName) {
        _labelUserName = [[UILabel alloc] init];
        _labelUserName.textAlignment = NSTextAlignmentRight;
        _labelUserName.font = Font(15);
        _labelUserName.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    }
    return _labelUserName;
}


- (UILabel *)labelUserSex
{
    if (!_labelUserSex) {
        _labelUserSex = [[UILabel alloc] init];
        _labelUserSex.textAlignment = NSTextAlignmentRight;
        _labelUserSex.font = Font(15);
        _labelUserSex.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    }
    return _labelUserSex;
}



- (UILabel *)labelUserPhone
{
    if (!_labelUserPhone) {
        _labelUserPhone = [[UILabel alloc] init];
        _labelUserPhone.textAlignment = NSTextAlignmentRight;
        _labelUserPhone.font = Font(15);
        _labelUserPhone.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    }
    return _labelUserPhone;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableViewFrame:CGRectMake(0, __KViewY + 1, __kWindow_Width, __kWindow_Height - __KViewY - 1) Style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self requestData];
}


#pragma mark - 请求 数据
-(void)requestData
{
    
    [[HttpManager shareInstance] get:@"account" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        //        NSLog(@"----返回数据：%@",response);
        _dataDict = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //                2.    name    用户昵称，可能会没有
            //
            //                3.    phone    用户手机号
            //
            //                4.    cover    用户头像
            //
            //                5.    score    账户余额
            //
            //                6.    sex    用户性别，1男2女
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
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 4){
        return 150;
    }
    return 50;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = Font(15);
    cell.textLabel.textColor = __kcolorText_Black;
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    cell.detailTextLabel.font = Font(15);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, cell.height - __kLine_Width_Height, __kWindow_Width, __kLine_Width_Height);
    line.backgroundColor = __kLineColor;
    
    if (indexPath.row == 0) {
        //        cell.textLabel.text = @"设置头像";
        
        NSString *urlStr = _dataDict[@"cover"];
        //
        [self.imageHead sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@""]];
        
        
        CGFloat headH = 50;
        _imageHead.frame = CGRectMake(__kScreenMargin, 10, headH, headH);
        _imageHead.layer.cornerRadius = headH/2;
        _imageHead.layer.masksToBounds = YES;
        
        [cell.contentView addSubview:self.imageHead];
        line.top = 80 - __kLine_Width_Height;
        [cell.contentView addSubview:line];
        return cell;
    }else if (indexPath.row == 1){
        
        cell.textLabel.text = @"昵称";
        self.labelUserName.frame = CGRectMake(__kWindow_Width - rightMargin - 150, 0, 150, cellH);
        [cell.contentView addSubview:self.labelUserName];
        [cell.contentView addSubview:line];
        if (![_dataDict[@"name"] isKindOfClass:[NSNull class]]) {
            self.labelUserName.text = _dataDict[@"name"]?_dataDict[@"name"]:@"";
        }
        
        
        return cell;
    }else if (indexPath.row == 2){
        
        cell.textLabel.text = @"性别";
        self.labelUserSex.frame = CGRectMake(__kWindow_Width - rightMargin - 150, 0, 150, cellH);
        [cell.contentView addSubview:self.labelUserSex];
        [cell.contentView addSubview:line];
        
        if (_dataDict[@"sex"] == nil) {
            _labelUserSex.text = @"请选择";
        }else if ([_dataDict[@"sex"] integerValue] == 1){
            _labelUserSex.text = @"男";
        }else if ([_dataDict[@"sex"] integerValue] == 2){
            _labelUserSex.text = @"女";
        }
        
        
        return cell;
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"手机";
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.labelUserPhone.frame = CGRectMake(__kWindow_Width - rightMargin - 150, 0, 150, cellH);
        [cell.contentView addSubview:self.labelUserPhone];
        if (![_dataDict[@"phone"] isKindOfClass:[NSNull class]]) {
            self.labelUserPhone.text = _dataDict[@"phone"]?_dataDict[@"phone"]:@"";
        }
        
        return cell;
    }else if (indexPath.row == 4){
        UIButton *logoutBtn = [[UIButton alloc] init];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        logoutBtn.frame = CGRectMake(60, 50, __kWindow_Width - 2*60, 50);
        logoutBtn.layer.cornerRadius = 25;
        logoutBtn.layer.masksToBounds = YES;
        [logoutBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:logoutBtn];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"相机", nil];
        sheet.tag = 100;
        [sheet showInView:self.view];
        
    }else if (indexPath.row == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *txtName = [alert textFieldAtIndex:0];
        txtName.placeholder = @"请输入昵称";
        [alert show];
    }else if (indexPath.row == 2){
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        sheet.tag = 102;
        [sheet showInView:self.view];
        
        
    }else if (indexPath.row == 3){
        
    }
    
    
}


#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        //获取txt内容即可
        NSDictionary *postDic = @{@"name":txt.text};
        
        [[HttpManager shareInstance] post:@"deal_edit_sex" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
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
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            
            NSLog(@"本地上传 ");
            //相册:判断手机是否支持相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                [self loadImageFromSource:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            }
            else
            {
                NSLog(@"无法访问相册");
            }
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"相机 ");
            //相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self loadImageFromSource:UIImagePickerControllerSourceTypeCamera];
            }
            else
            {
                NSLog(@"无法访问相机");
            }
        }
    }else if (actionSheet.tag == 102){
        if (buttonIndex == 0) {
            
            NSLog(@"男 ");
            
            NSDictionary *postDic = @{@"sex":@1};
            
            [[HttpManager shareInstance] post:@"deal_edit_sex" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self alertWithMessage:response[@"msg"]];
                    
                });
                
                [self requestData];
                
            } failure:^(NSURLSessionDataTask *operation, id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertWithMessage:response[@"msg"]];
                });
                
            }];
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"女 ");
            
            NSDictionary *postDic = @{@"sex":@2};
            
            [[HttpManager shareInstance] post:@"deal_edit_sex" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
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
    }
}

-(void)loadImageFromSource:(UIImagePickerControllerSourceType)type
{
    /**
     *  是一个集成了访问图片的功能的控件
     */
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = type;
    imagePicker.delegate = self;
    //设置了这个参数后,选择图片完成时,会出现裁剪窗口
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    
    [[HttpManager shareInstance] post:@"deal_edit_avatar" parameter:@{} image:img name:@"cover" withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        
        [self requestData];
        /** 修改个人中心的头像 */
        if (self.setHead) {
            _setHead();
        }
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
    
    NSLog(@"%@",img);
    
    
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}



- (void)logoutBtnClick:(UIButton *)sender
{
    
    
    
    [[HttpManager shareInstance] post:@"logout" parameter:nil withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        //        [Tools LogWith:response WithTitle:@"---登录成功----"];
        
        NSLog(@"----登出成功：%@",response);
        
        [[LoginUser user] logout];
        
        [MessageAlertView showWithMessage:response[@"msg"]];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
        [MessageAlertView showWithMessage:response[@"msg"]];
        
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
