//
//  LoginUser.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/23.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "LoginUser.h"
#import "SSKeychain.h"
#import "AppDelegate.h"
#import "RegModel.h"
@implementation LoginUser

static LoginUser *_u = nil;

+(id)user {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _u = [[LoginUser alloc] init];
    });
    
    return _u;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLogin) name:UIApplicationDidFinishLaunchingNotification object:nil];
    }
    
    return self;
}

/**
 *    自动登录
 */

- (void)autoLogin {
    //  判断网络连接是否正常,  正常?连接:显示网络异常
    NSLog(@"======自动登录");
    //登录类型是否是第三方登录
    NSNumber *loginType = [[NSUserDefaults standardUserDefaults] valueForKey:__kLoginType];
    
    NSString *loginId = [[NSUserDefaults standardUserDefaults] valueForKey:__kUserPhone];
    
    NSLog(@"====loginId==%@",loginId);
    
    if (!loginId && !loginId.length) {
        return;
    }
    
    if ([loginType boolValue]) {
        NSError *err = nil;
        NSString *paramString = [SSKeychain passwordForService:__kService account:loginId];
        NSData *paramData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *paramDict = [NSJSONSerialization JSONObjectWithData:paramData options:NSJSONReadingMutableLeaves error:&err];
        if (paramDict && !err) {
            [self thirdPartyLoginInWithParams:paramDict complete:^(BOOL result, NSDictionary * _Nonnull response) {
                if (result) {
                    self.isOnLine = @YES;
                    NSLog(@"自动登录成功---");
                }else{
                    [MessageAlertView showWithMessage:@"登录失败"];
                }
            }];
        }
    }else{
        NSString *password = [SSKeychain passwordForService:__kService account:loginId];
        NSLog(@"====passowrd==%@",password);
        
        if (loginId == nil || password == nil  ) {
            NSLog(@" ===== 取消自动登录");
            return;
        }
        
        NSDictionary *dic = @{@"phone":loginId,@"password":password};
        
        [[HttpManager shareInstance] post:@"login" parameter:dic withHUDTitle:nil success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull response) {
            NSLog(@"----登录成功：%@",response);
            
            /**
             *    将密码保存到钥匙串
             */
            [SSKeychain setPassword:password forService:__kService account:loginId];
            
            [self loginSuccessUpdateUserData:response];
            
        } failure:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull response) {
            
            [MessageAlertView showWithMessage:response[@"msg"]];
            
        }];
        
    }
}

#pragma mark 登录成功 保存数据
- (void)loginSuccessUpdateUserData:(id)responseObject {
    
    NSDictionary *res = @{};
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        res = (NSDictionary *)responseObject;
    }
    
    
    //    {
    //        "access_token" = Um6vKjIbHcriJBhrKyV2CFwuUc2rr8fK;
    //        "client_id" = 01797661311205822543743259844243;
    //        cover = "http://changmai.zhixuandajiankang.com/files/images/my-photo.png";
    //        msg = "\U64cd\U4f5c\U6210\U529f";
    //        name = "";
    //        phone = 18621729625;
    //        result = 1;
    //        score = 0;
    //        sex = 1;
    //    }
    //
    
    if ([[res objectForKey:@"result"] intValue] == 1) {//登录成功
        NSLog(@"%@",res);
        
        /** 缓存用户数据到内存 */
        [self setValuesForKeysWithDictionary:res];
        
        /** 缓存用户数据到本地 */
        [self saveDataToLocalisThirdLogin:NO];
        
        self.isOnLine = @YES;
        
        NSLog(@"isOnLineYes=====%d=======",[[[LoginUser user] isOnLine] boolValue]);
        
        /** 发通知 登录成功  刷新需要刷新的UI */
        [[NSNotificationCenter defaultCenter]postNotificationName:__KNotiLoginIn object:nil];
    }
    
}

// log NSSet with UTF8
// if not ,log will be \Uxxx

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    
    return str;
}

-(void)saveDataToLocalisThirdLogin:(BOOL)isThirdLogin {
    /**
     *    登录成功以后,在NSUserDefaults里面标示下
     */
    [[NSUserDefaults standardUserDefaults]setValue:__kLogined forKey:__kLogined];
    /**
     *    保存用户名 手机号  token
     */
    if (isThirdLogin) {//第三方登录保存usid
        NSLog(@"userId:%@",[[RegModel sharedRegModel] usid]);
        
        
        if ([[[RegModel sharedRegModel] type] integerValue] == 1) {//微博登陆
            NSLog(@"userId:%@",_wbUid);
            
            [[NSUserDefaults standardUserDefaults]setValue:_wbUid forKey:__kUserPhone];
        }else if ([[[RegModel sharedRegModel] type] integerValue] == 2){//微信登陆
            NSLog(@"userId:%@",_wxUid);
            
            [[NSUserDefaults standardUserDefaults]setValue:_wxUid forKey:__kUserPhone];
        }
        
    }else{
        [[NSUserDefaults standardUserDefaults]setValue:_phone forKey:__kUserPhone];

    }
    
    //保存登录类型
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:isThirdLogin] forKey:__kLoginType];
    
    [[NSUserDefaults standardUserDefaults]setValue:_access_token forKey:__kToken];
    [[NSUserDefaults standardUserDefaults]setValue:_name forKey:__kUserName];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

/**
 *  需要修改本地文件:__kLogined从NSUserDefauts中删除
 *  密码从钥匙串中删除
 *  设置当前的单例对象(loginuser)的数据为空
 *  界面上回到登录注册选择界面
 */
-(void)logout{
    [self clearInfo];
}
- (void)clearInfo{
    
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:__kLogined];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:__kUserPhone];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:__kLoginType];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [SSKeychain deletePasswordForService:__kService account:_phone];
    _u.userId = @-1;
    _u.access_token = nil;
    _u.isOnLine = @NO;
    _u.phone = nil;
    _u.name = nil;
    _u.cover = nil;
    _u.userCode = nil;
    _u.sex = nil;
    _u.bonusPoint = nil;
    _u.verify = nil;
    
    _u.wbUid = nil;
    _u.wbName = nil;
    _u.wxUid = nil;
    _u.wxName = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"uid"]) {
        _userId = [NSNumber numberWithUnsignedLongLong:[value longLongValue]];
    }
}

-(NSNumber *)userId
{
    if (!_userId) {
        //        [[NSNotificationCenter defaultCenter]postNotificationName:__KNotiLogin object:nil];
        return @-1;
    }
    return _userId;
}

- (void)setStore_id:(NSNumber *)store_id
{
    _store_id = store_id;
    NSString *key = [NSString stringWithFormat:@"%@_storeId",self.userId];
    [[NSUserDefaults standardUserDefaults] setValue:_store_id forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSNumber *)store_id
{
    if (![_store_id intValue]) {
        NSString *key = [NSString stringWithFormat:@"%@_storeId",self.userId];
        NSNumber *storeId = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        _store_id = storeId;
        return _store_id;
    }
    return _store_id;
}

- (void)setStore_Address:(NSString *)store_Address
{
    _store_Address = store_Address;
    NSString *key = [NSString stringWithFormat:@"%@_storeAddress",self.userId];
    [[NSUserDefaults standardUserDefaults] setValue:_store_Address forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (NSString *)store_Address
{
    if (!_store_Address.length) {
        NSString *key = [NSString stringWithFormat:@"%@_storeAddress",self.userId];
        NSString *store_Address = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        _store_Address = store_Address;
        return _store_Address;
    }
    return _store_Address;
}

-(NSString *)phone
{
    if (!_phone) {
        //        [[NSNotificationCenter defaultCenter]postNotificationName:__KNotiLogin object:nil];
        return @"";
    }
    return _phone;
}

-(NSString *)access_token
{
    if (!_access_token) {
        return @"";
    }
    return _access_token;
}



-(NSString *)userCode
{
    if (!_userCode) {
        [[NSNotificationCenter defaultCenter]postNotificationName:__KNotiLogin object:nil];
        return nil;
    }
    return _userCode;
}


-(NSString *)cover
{
    if (_cover.length) {
        //        return [[__kUrlPrefix stringByAppendingString:_avatar] stringByAppendingString:__kurlSuffixPersonalHead];
        //                return  [__kUrlPrefix stringByAppendingString:_avatar] ;
        return _cover;
    }
    else
        return @"";
}



-(NSString *)name
{
    if (!_name.length) {
        return @" ";
    }else
        return _name;
}

- (void)setisOnLine:(NSNumber *)isOnLine
{
    _isOnLine = isOnLine;
    [[NSNotificationCenter defaultCenter]postNotificationName:__KNotiOnLine
                                                       object:nil];
}


- (NSNumber *)isOnLine
{
    if (![_isOnLine boolValue]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:__KNotiLogin object:nil];
        return @NO;
    }
    return _isOnLine;
    
}

@end
