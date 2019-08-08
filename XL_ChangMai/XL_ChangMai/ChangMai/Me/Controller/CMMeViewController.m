//
//  CMMeViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMMeViewController.h"
#import "CMAccountViewController.h"
#import "CMMessageViewController.h"
#import "CMFavoriteViewController.h"
#import "CMOrderListViewController.h"
#import "CMBalanceViewController.h"
#import "CMLoginViewController.h"
#import "CMAddressListViewController.h"
#import "CMProfileViewController.h"
#import "CMCouponViewController.h"
#import "LoginUser.h"
@interface CMMeViewController ()
/** 背景图片 */
@property (nonatomic,strong) UIImageView *topView;

/** isLogin */
@property (nonatomic,assign) BOOL  isLogin;
/** 用户头像 */
@property (nonatomic,strong)UIImageView *useHeadView;
/** 用户登陆状态，名称 */
@property (nonatomic,strong)UILabel *useNameLabel;

/** LoginUser */
@property (nonatomic,strong) LoginUser *user;
@end

@implementation CMMeViewController
-(LoginUser *)user
{
    if (!_user) {
        _user = [LoginUser user];
    }
    return _user;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    //    [self performSelectorInBackground:@selector(refreshPersonalInformation) withObject:nil];
    
    
    if (!self.user.access_token.length) {
        _isLogin = NO;
        
    }else
    {/** 已登录 */
        _isLogin = YES;
        
    }
    
    [self resetUI];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = nil;
    
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logInSuccess) name:__KNotiLoginIn object:nil];
    //注销成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutSuccess) name:__KNotiLoginOut object:nil];
    /** 异地登录 */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OutLine) name:__KNotiOutLine object:nil];
    

}

-(void)resetUI
{
    self.tableView = nil;
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self setUpUI];
}




- (void)setUpUI
{
    // 个人中心默认背景图片
    _topView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, __kWindow_Width, 200)];
    _topView.image = [UIImage imageNamed:@"myCenter_banner_pic"];
    _topView.contentMode = UIViewContentModeScaleAspectFill;
    _topView.clipsToBounds = YES;
    _topView.userInteractionEnabled = YES;
    
    
    /** 头像 */
    CGFloat HeadW = 50;
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake((__kWindow_Width - HeadW)*0.5, 50, HeadW, HeadW)];
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLogin)];
    [headView addGestureRecognizer:headTap];
    headView.image = [UIImage imageNamed:@"my_photo"];
    headView.layer.cornerRadius = headView.height * 0.5f;
    headView.clipsToBounds = YES;
    // 打开交互
    headView.userInteractionEnabled = YES;
    [_topView addSubview:headView];
    self.useHeadView = headView;
    
    /** 用户名 */
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) , __kWindow_Width, 50)];
    labelName.textAlignment = NSTextAlignmentCenter;
    labelName.text = @"未登陆";
    labelName.textColor = [UIColor whiteColor];
    labelName.font = [UIFont boldSystemFontOfSize:15];
    [_topView addSubview:labelName];
    self.useNameLabel = labelName;
    
    UIButton *balanceBtn = [[UIButton alloc] init];
    balanceBtn.hidden = YES;
    [balanceBtn setDefaultStyle];
    CGFloat balanceWidth = 120;
    balanceBtn.frame = CGRectMake((__kWindow_Width - balanceWidth)/2, labelName.bottom, balanceWidth, __kBUTTON_Height);
    [balanceBtn setImage:[UIImage imageNamed:@"my_icon1"] forState:UIControlStateNormal];
    //    [balanceBtn setTitle:@"  我的余额" forState:UIControlStateNormal];
    [balanceBtn addTarget:self action:@selector(balanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:balanceBtn];
    
    
    self.dataArray =[NSMutableArray arrayWithArray:@[@{@"imgName":@"my_icon2",
                                                       @"title":@"我的订单",
                                                       @"className":@"CMOrderListViewController"},
                                                     @{@"imgName":@"my_icon3",
                                                       @"title":@"我的消息",
                                                       @"className":@"CMMessageViewController"},
                                                     @{@"imgName":@"my_icon4",
                                                       @"title":@"我的账户",
                                                       @"className":@"CMAccountViewController"},
                                                     @{@"imgName":@"my_icon5",
                                                       @"title":@"我的收藏",
                                                       @"className":@"CMFavoriteViewController"},
                                                     @{@"imgName":@"my_icon6",
                                                       @"title":@"我的收货地址",
                                                       @"className":@"CMAddressListViewController"}
                                                     //                                                     @{@"imgName":@"my_icon7",
                                                     //                                                       @"title":@"我的优惠券",
                                                     //                                                       @"className":@"CMCouponViewController"}
                                                     ]];
    
    
    
    
    if (_isLogin) {
        
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBGImage)];
        //        [_topView addGestureRecognizer:tap];
        
        // 头像
        [headView sd_setImageWithURL:[NSURL URLWithString:_user.cover] placeholderImage:[UIImage imageNamed:@"my_photo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            headView.image = image?image:[UIImage imageNamed:@"my_photo"];
        }];
        
        
        labelName.text = _user.name;
        
        balanceBtn.hidden = NO;
        
        NSString *titleStr = [NSString stringWithFormat:@"  余额 ¥%.02f",[_user.score floatValue]];
        NSAttributedString *attrString = [NSString getAttributedText:titleStr SpecialText:[NSString stringWithFormat:@"¥%.02f",[_user.score floatValue]] Font:Font(14) Color:__kThemeColor];
        [balanceBtn setAttributedTitle:attrString forState:UIControlStateNormal];
        
        CGSize balanceSize = [titleStr sizeWithFont:Font(14)];
        CGFloat balanceWidth = balanceSize.width + 70;
        balanceBtn.frame = CGRectMake((__kWindow_Width - balanceWidth)/2, labelName.bottom, balanceWidth, __kBUTTON_Height);
        
        
        
        
    }else       /** 没有登录 去登录 */
    {
        
        
        
        
    }
    
    
    
    CGFloat tableViewY = __KViewY + 1;
    [self createTableViewFrame:CGRectMake(0, tableViewY, __kWindow_Width, __kWindow_Height - tableViewY - __KtabBarHeight) Style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = _topView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}


#pragma mark 异地登录
- (void)OutLine
{
    //    [[LoginUser user] logoutNotGoHome];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        _isLogin = NO;
    //        [self resetUI];
    //    });
    //
    
}


#pragma mark 登录成功
- (void)logInSuccess
{
    
}

#pragma mark 注销成功
- (void)logOutSuccess
{
    
}


- (void)goToLogin
{
    if (_isLogin) {
        CMProfileViewController *profile = [[CMProfileViewController alloc] init];
        [self.navigationController pushViewController:profile animated:YES];
    }else{
        CMLoginViewController *loginVC = [[CMLoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{

        }];
    }

    
    
}


- (void)balanceBtnClick:(UIButton *)sender
{
    //    CMBaseViewController *vc = [CMBaseViewController new];
    //    [self.navigationController pushViewController:vc animated:YES];
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
    return 50;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = Font(15);
    cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.row][@"imgName"]];
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < (self.dataArray.count - 1)) {
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 50 - __kLine_Width_Height, __kWindow_Width, __kLine_Width_Height);
        line.backgroundColor = __kLineColor;
        [cell.contentView addSubview:line];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![[[LoginUser user] isOnLine] boolValue]) {
        return;
    }
    
    NSString *className = self.dataArray[indexPath.row][@"className"];
    UIViewController *vc = [NSClassFromString(className) new];
    [self.navigationController pushViewController:vc animated:YES];
    
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
