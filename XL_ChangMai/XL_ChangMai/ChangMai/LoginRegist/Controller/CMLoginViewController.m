//
//  CMLoginViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMLoginViewController.h"
#import "CMRegistViewController.h"
#import "SSKeychain.h"
//#import <UMSocialCore/UMSocialCore.h>
//#import "WXApi.h"
@interface CMLoginViewController ()
/** scrollView */
@property (nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *registBtn;
@property (strong, nonatomic)  UITextField *textFieldPhone;
@property (strong, nonatomic)  UITextField *textFieldPassword;
@end

@implementation CMLoginViewController

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self.view insertSubview:_scrollView atIndex:0];
    }return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdPartyLogin:) name:__KLoginInWeChat object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdPartyLogin:) name:__KLoginInWeiBo object:nil];
    
    
    [self createUI];
}


- (void)createUI
{
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *loginView = [[UIView alloc] init];
    loginView.backgroundColor = __kContentBgColor;
    loginView.frame = CGRectMake(0, __KViewY, __kWindow_Width, 340);
    [self.scrollView addSubview:loginView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.frame = CGRectMake(0, 0, __kWindow_Width, 185);
    logoImageView.contentMode = UIViewContentModeCenter;
    [loginView addSubview:logoImageView];
    
    
    _textFieldPhone = [self creatTextField];
    _textFieldPhone.placeholder = @"请输入手机号码";
    _textFieldPhone.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldPhone.frame = CGRectMake(__kScreenMargin, logoImageView.bottom + __kScreenMargin, __kWindow_Width - 2*__kScreenMargin, __kTextField_Height);
    [loginView addSubview:_textFieldPhone];
    
    _textFieldPassword = [self creatTextField];
    _textFieldPassword.placeholder = @"请输入密码";
    _textFieldPassword.secureTextEntry = YES;
    _textFieldPassword.frame = CGRectMake(__kScreenMargin, _textFieldPhone.bottom + __kScreenMargin, __kWindow_Width - 2*__kScreenMargin, __kTextField_Height);
    [loginView addSubview:_textFieldPassword];
    
    
    CGFloat btnMargin = 60;
    CGFloat cornerRadius = 25;
    _loginBtn =  [UIButton buttonWithType:UIButtonTypeCustom];;
    [_loginBtn setTitle:@"确认登录" forState:UIControlStateNormal];
    _loginBtn.frame = CGRectMake(btnMargin, loginView.bottom + 30, __kWindow_Width - 2*btnMargin, 50);
    _loginBtn.layer.cornerRadius = cornerRadius;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_loginBtn];
    
    
    _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registBtn.frame = CGRectMake(btnMargin, _loginBtn.bottom + 30, __kWindow_Width - 2*btnMargin, 50);
    _registBtn.layer.cornerRadius = cornerRadius;
    _registBtn.layer.masksToBounds = YES;
    [_registBtn setBackgroundColor:__kGreen_Color forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_registBtn];
    
    UILabel *hintLabel2 = [[UILabel alloc] init];
    hintLabel2.frame = CGRectMake(0, _registBtn.bottom + 30, __kWindow_Width, 45);
    hintLabel2.backgroundColor = __kViewBgColor;
    hintLabel2.text = @"————————— 其他方式登录 —————————";
    hintLabel2.textColor = [UIColor lightGrayColor];
    hintLabel2.textAlignment = NSTextAlignmentCenter;
    hintLabel2.font = Font(13);
    [self.scrollView addSubview:hintLabel2];
    
    CGFloat loginBtnMargin = 30;
    CGFloat loginBtnW = 50;
    CGFloat loginBtnX = (__kWindow_Width - loginBtnW*2 - loginBtnMargin)/2;
    CGFloat loginBtnY = hintLabel2.bottom + 10;
    
    
    UIButton *weChatBtn = [[UIButton alloc] init];
    weChatBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW,loginBtnW);
    [weChatBtn addTarget:self action:@selector(weChatClick:) forControlEvents:UIControlEventTouchUpInside];
    [weChatBtn setImage:[UIImage imageNamed:@"third_login_weixin"] forState:UIControlStateNormal];
    [self.scrollView addSubview:weChatBtn];
    
    UIButton *weiboBtn = [[UIButton alloc] init];
    weiboBtn.frame = CGRectMake(loginBtnX + loginBtnW + loginBtnMargin, loginBtnY, loginBtnW,loginBtnW);
    [weiboBtn addTarget:self action:@selector(weiboClick:) forControlEvents:UIControlEventTouchUpInside];
    [weiboBtn setImage:[UIImage imageNamed:@"third_login_weibo"] forState:UIControlStateNormal];
    [self.scrollView addSubview:weiboBtn];
    
    
    
    self.scrollView.contentSize = CGSizeMake(__kWindow_Width, weiboBtn.bottom);
}

- (UITextField *)creatTextField
{
    UITextField *textF = [[UITextField alloc]  init];
    textF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, __kTextField_Height)];
    textF.leftViewMode = UITextFieldViewModeAlways;
    textF.backgroundColor = [UIColor whiteColor];
    textF.font = Font(15);
    textF.layer.borderWidth = 1;
    textF.layer.borderColor = __kLineColor.CGColor;
    return textF;
}







#pragma mark - 第三方登录
- (void)weChatClick:(UIButton *)sender {
    
//    if ([WXApi isWXAppInstalled]) {
//        SendAuthReq *req = [[SendAuthReq alloc] init];
//        req.scope = @"snsapi_userinfo";
//        req.state = @"App";
//        [WXApi sendReq:req];
//    }
//    else {
//        
//        [MessageAlertView showWithMessage:@"请先安装微信客户端"];
//    }
    
    
    //
    //    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
    //
    //        UMSocialUserInfoResponse *resp = result;
    //
    //        // 第三方登录数据(为空表示平台未提供)
    //        // 授权数据
    //        NSLog(@" uid: %@", resp.uid);
    //        NSLog(@" openid: %@", resp.openid);
    //        NSLog(@" accessToken: %@", resp.accessToken);
    //        NSLog(@" refreshToken: %@", resp.refreshToken);
    //        NSLog(@" expiration: %@", resp.expiration);
    //
    //        // 用户数据
    //        NSLog(@" name: %@", resp.name);
    //        NSLog(@" iconurl: %@", resp.iconurl);
    //        NSLog(@" gender: %@", resp.gender);
    //
    //        // 第三方平台SDK原始数据
    //        NSLog(@" originalResponse: %@", resp.originalResponse);
    //
    //        [self thirdPartyLoginType:1 token:resp.accessToken];
    //
    //    }];
    
}

- (void)weiboClick:(UIButton *)sender {
    
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
//
//        UMSocialUserInfoResponse *resp = result;
//
//        // 第三方登录数据(为空表示平台未提供)
//        // 授权数据
//        NSLog(@" uid: %@", resp.uid);
//        NSLog(@" openid: %@", resp.openid);
//        NSLog(@" accessToken: %@", resp.accessToken);
//        NSLog(@" refreshToken: %@", resp.refreshToken);
//        NSLog(@" expiration: %@", resp.expiration);
//
//        // 用户数据
//        NSLog(@" name: %@", resp.name);
//        NSLog(@" iconurl: %@", resp.iconurl);
//        NSLog(@" gender: %@", resp.gender);
//
//        // 第三方平台SDK原始数据
//        NSLog(@" originalResponse: %@", resp.originalResponse);
//
//        [self thirdPartyLoginType:2 token:resp.accessToken];
//
//    } ];
    
}


- (void)thirdPartyLogin:(NSNotification *)notification
{
    NSInteger loginType = [[notification.userInfo objectForKey:@"type"] integerValue];
    NSString *code = [notification.userInfo objectForKey:@"code"];
    [self thirdPartyLoginType:loginType token:code];
}

/**
 * 第三方登录
 * 1 微信
 * 2 微博
 */
- (void)thirdPartyLoginType:(NSInteger)loginType token:(NSString *)tokenString
{
    
    NSDictionary *paramDic = @{@"code":tokenString};
    
    NSString *urlStr = @"";
    if (loginType == 1) {
        urlStr = @"weixin_login";
    }else if (loginType == 2){
        urlStr = @"weibo_login";
    }
    
    
    
    
    [[HttpManager shareInstance] get:urlStr parameter:paramDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        //        [Tools LogWith:response WithTitle:@"---登录成功----"];
        
        NSLog(@"----登录成功：%@",response);
        
        /**
         *    将密码保存到钥匙串
         */
        //  [SSKeychain setPassword:_password forService:__kService account:_loginId];
        
        [[LoginUser user] loginSuccessUpdateUserData:response];
        
        [MessageAlertView showWithMessage:response[@"msg"]];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        [Tools LogWith:response WithTitle:@"---找回密码----"];
        [MessageAlertView showWithMessage:response[@"msg"]];
        
    }];
    
}

- (void)loginClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSString *_loginId = [_textFieldPhone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_loginId.length !=11 || ![self isValidateMobile:_loginId] ) {
        [MessageAlertView showWithMessage:@"请正确输入手机号"];
        return;
    }
    
    NSString *_password = _textFieldPassword.text;
    if (_password.length == 0) {
        return;
    }
    
    
    
    NSDictionary *paramDic = @{@"phone":_loginId,@"password":_password};
    
    
    [[HttpManager shareInstance] post:@"login" parameter:paramDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        //        [Tools LogWith:response WithTitle:@"---登录成功----"];
        
        NSLog(@"----登录成功：%@",response);
        if ([response[@"result"] boolValue]) {
            /**
             *    将密码保存到钥匙串
             */
            [SSKeychain setPassword:_password forService:__kService account:_loginId];
            
            [[LoginUser user] loginSuccessUpdateUserData:response];
            
            [MessageAlertView showWithMessage:response[@"msg"]];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }else{
            [MessageAlertView showWithMessage:response[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        [Tools LogWith:response WithTitle:@"---找回密码----"];
        [MessageAlertView showWithMessage:response[@"msg"]];
        
    }];
    
    
}


- (void)registClick:(UIButton *)sender
{
    CMRegistViewController *registerVc = [[CMRegistViewController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
}




- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
