//
//  CMRegistViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/30.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMRegistViewController.h"
#import "RegModel.h"
#import "SSKeychain.h"
@interface CMRegistViewController ()
{
    NSInteger restOfTime;
}
/** scrollView */
@property (nonatomic,strong) UIScrollView *scrollView;
// ----- 定时器 -----
/** Timer */
@property (nonatomic,strong) NSTimer *timerBegin;
/** 手机号 */
@property (nonatomic,strong) UITextField *textFieldPhone;
/** 密码 */
@property (nonatomic,strong) UITextField *textFieldPassword;
/** 确认密码 */
@property (nonatomic,strong) UITextField *textFieldCheckPassword;
/** 验证码 */
@property (nonatomic,strong) UITextField *textFieldCode;
/** 注册 */
@property (nonatomic,strong) UIButton *submitBtn;
/** 查看协议 */
@property (nonatomic,strong) UIButton *protocolBtn;


/** 获取验证码 */
@property (nonatomic,strong) UIButton *vcodeBtn;

/** _phoneNum */
@property (nonatomic,copy) NSString * phoneNum;

@property (nonatomic,assign)BOOL canGetVcode;
@end

@implementation CMRegistViewController

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
    // Do any additional setup after loading the view.
    self.title = @"用户注册";
     self.view.backgroundColor = [UIColor whiteColor];
    //默认可以获取验证码
    _canGetVcode = YES;
    //创建空的注册对象
    [[RegModel sharedRegModel] createEmpty];
    
    
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
    
    
    _textFieldPhone = [self createDefaultStyleTextFieldFrame:CGRectMake(__kScreenMargin, logoImageView.bottom + __kScreenMargin, __kWindow_Width - 2*__kScreenMargin, __kTextField_Height)];
    _textFieldPhone.placeholder = @"请输入手机号码";
    _textFieldPhone.keyboardType = UIKeyboardTypeNumberPad;
    [loginView addSubview:_textFieldPhone];
    
    _textFieldPassword = [self createDefaultStyleTextFieldFrame:CGRectMake(__kScreenMargin, _textFieldPhone.bottom + __kScreenMargin, __kWindow_Width - 2*__kScreenMargin, __kTextField_Height)];
    _textFieldPassword.placeholder = @"请输入密码";
    _textFieldPassword.secureTextEntry = YES;
    [loginView addSubview:_textFieldPassword];
    
    _textFieldCheckPassword = [self createDefaultStyleTextFieldFrame:CGRectMake(__kScreenMargin, _textFieldPassword.bottom + __kScreenMargin, __kWindow_Width - 2*__kScreenMargin, __kTextField_Height)];
    _textFieldCheckPassword.placeholder = @"请再次输入密码";
    _textFieldCheckPassword.secureTextEntry = YES;
    [loginView addSubview:_textFieldCheckPassword];
    
    _vcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _vcodeBtn.frame = CGRectMake(__kWindow_Width - myWith6(100) - __kScreenMargin, _textFieldCheckPassword.bottom + __kScreenMargin, myWith6(100), __kTextField_Height);
    [_vcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_vcodeBtn setTitleColor:__kGreen_Color forState:UIControlStateNormal];
    _vcodeBtn.titleLabel.font = Font(15);
    [_vcodeBtn addTarget:self action:@selector(getverifyCode:) forControlEvents:UIControlEventTouchUpInside];
    _vcodeBtn.tag = 30000;
    _vcodeBtn.layer.borderWidth = 1;
    _vcodeBtn.layer.borderColor = __kGreen_Color.CGColor;
    _vcodeBtn.layer.masksToBounds = YES;
    _vcodeBtn.layer.cornerRadius = 19;
    [loginView addSubview:_vcodeBtn];
    
    
    _textFieldCode = [self createDefaultStyleTextFieldFrame:CGRectMake(__kScreenMargin, _textFieldCheckPassword.bottom + __kScreenMargin, _vcodeBtn.left - __kScreenMargin - 15, __kTextField_Height)];
    _textFieldCode.placeholder = @"请输入验证码";
    _textFieldCode.keyboardType = UIKeyboardTypeNumberPad;
    [loginView addSubview:_textFieldCode];
    loginView.height = _textFieldCode.bottom + 30;
    
    
    CGFloat btnMargin = 60;
    CGFloat cornerRadius = 25;
    _submitBtn = [[UIButton alloc] init];
    [_submitBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    _submitBtn.frame = CGRectMake(btnMargin, loginView.bottom + 30, __kWindow_Width - 2*btnMargin, 50);
    _submitBtn.layer.cornerRadius = cornerRadius;
    _submitBtn.layer.masksToBounds = YES;
    [_submitBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_submitBtn];
    
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(0, _submitBtn.bottom + 40, __kWindow_Width, 20);
    hintLabel.text = @"点击“确认同意”，既代表同意";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = Font(12);
    [self.scrollView addSubview:hintLabel];
    
    
    _protocolBtn = [[UIButton alloc] init];
    [_protocolBtn setTitle:@"《畅麦注册使用协议》" forState:UIControlStateNormal];
    _protocolBtn.frame = CGRectMake(btnMargin, hintLabel.bottom, __kWindow_Width - 2*btnMargin, 20);
    _protocolBtn.titleLabel.font = hintLabel.font;
    [_protocolBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_protocolBtn setTitleColor:__kGreen_Color forState:UIControlStateNormal];
    [_protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_protocolBtn];
    
    self.scrollView.contentSize = CGSizeMake(__kWindow_Width, _protocolBtn.bottom + 20);
}


#pragma mark - 获取验证码
-(void)getverifyCode:(UIButton *)sender
{
    [self.view endEditing:YES];
    _phoneNum = [_textFieldPhone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_phoneNum.length != 11) {
        if (_phoneNum.length == 0) {
            [MessageAlertView showWithMessage:@"请输入手机号"];
            return;
        }else
            [MessageAlertView showWithMessage:@"请正确输入手机号"];
        return;
    }else
    {
        if (![self isValidateMobile:_phoneNum]) {
            [MessageAlertView showWithMessage:@"请正确输入手机号"];
            return;
        }
    }
    if (!_canGetVcode)
        return;
    if (_canGetVcode == YES) {
        _canGetVcode = NO;
    }
    
    
    
    NSDictionary *param = @{@"phone":_phoneNum};
    [[HttpManager shareInstance] get:@"send_phone_code" parameter:param withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        [Tools LogWith:response WithTitle:@"---找回密码----"];
        [MessageAlertView showWithMessage:response[@"msg"]];
        
        //获取验证码成功开始倒计时
        [_vcodeBtn setTitle:@"重新发送(60s)" forState:UIControlStateNormal];
        restOfTime = 60;
        _timerBegin = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        NSLog(@"获取验证码 ==== ");
        
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        [Tools LogWith:response WithTitle:@"---找回密码----"];
        [MessageAlertView showWithMessage:response[@"msg"]];
        
        _canGetVcode = YES;
    }];
    
    
}



-(void)updateTimer:(NSTimer *)timer
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        restOfTime--;
        if (restOfTime <= 0) {
            [_vcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            _canGetVcode = YES;
            [timer invalidate];
            _timerBegin = nil;
        }else
        {
            _canGetVcode = NO;
            [_vcodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%lds)",restOfTime] forState:UIControlStateNormal];
        }
        
    }];
}


- (void)protocolBtnClick:(UIButton *)sender
{
    
}


#pragma mark 提交按钮的点击
-(void)registClick:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    
    _phoneNum = [_textFieldPhone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_phoneNum.length != 11) {
        if (_phoneNum.length == 0) {
            [MessageAlertView showWithMessage:@"请输入手机号"];
            return;
        }else
            [MessageAlertView showWithMessage:@"请正确输入手机号"];
        return;
    }else
    {
        if (![self isValidateMobile:_phoneNum]) {
            [MessageAlertView showWithMessage:@"请正确输入手机号"];
            return;
        }
    }
    
    NSString *vcode = _textFieldCode.text;
    if (vcode.length !=6 ) {
        [MessageAlertView showWithMessage:@"请正确输入验证码"];
        return;
    }
    NSString *newPassword = _textFieldPassword.text;
    
    if (!_textFieldPassword.text.length) {
        [MessageAlertView showWithMessage:@"请设置密码"];
        return;
    }
    
    if (![_textFieldCheckPassword.text isEqualToString:_textFieldPassword.text]) {
        [MessageAlertView showWithMessage:@"两次输入密码不一致"];
        return;
    }
    
    
    
    
    
    [[RegModel sharedRegModel] setLoginId:_phoneNum];
    [[RegModel sharedRegModel] setPassWord:newPassword];
    
    
    NSDictionary *postDic = @{@"phone":_phoneNum,
                              @"password":_textFieldPassword.text,
                              @"confirm_password":_textFieldCheckPassword.text,
                              @"messageNumber":vcode};
    
    [[HttpManager shareInstance] post:@"register" parameter:postDic withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        
        [MessageAlertView showWithMessage:response[@"msg"]];
        
        NSLog(@"----注册成功：%@",response);
        /**
         *    将密码保存到钥匙串
         */
        [SSKeychain setPassword:_textFieldPassword.text forService:__kService account:_phoneNum];
        
        [[LoginUser user] loginSuccessUpdateUserData:response];
        
        [self registSuccess];
        
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
        [MessageAlertView showWithMessage:response[@"msg"]];
        
    }];
    
    
}



- (void)backBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)registSuccess
{
    for (UIView *vv in self.scrollView.subviews) {
        [vv removeFromSuperview];
    }
    
    UIView *loginView = [[UIView alloc] init];
    loginView.backgroundColor = __kContentBgColor;
    loginView.frame = CGRectMake(0, __KViewY, __kWindow_Width, 340);
    [self.scrollView addSubview:loginView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"succeed_icon"]];
    logoImageView.frame = CGRectMake(0, 40, __kWindow_Width, 124);
    logoImageView.contentMode = UIViewContentModeCenter;
    [loginView addSubview:logoImageView];
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(0, logoImageView.bottom + 10, __kWindow_Width, 20);
    hintLabel.text = @"注册成功";
    hintLabel.textColor = __kGreen_Color;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = Font(17);
    [loginView addSubview:hintLabel];
    loginView.height = hintLabel.bottom + 30;
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(60, loginView.bottom + 30, __kWindow_Width - 2*60, 50);
    backBtn.layer.cornerRadius = 25;
    backBtn.layer.masksToBounds = YES;
    [backBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:backBtn];
    
    
    
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
