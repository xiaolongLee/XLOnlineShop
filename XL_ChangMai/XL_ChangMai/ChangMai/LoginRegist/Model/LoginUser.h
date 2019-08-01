//
//  LoginUser.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/23.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginUser : NSObject
{
    NSNumber *_store_id;         //用户最后一次选择的门店编号
    NSString *_store_Address;         //用户最后一次选择的门店地址
}

@property (nonatomic,strong) NSString *name;         //用户名，昵称
@property (nonatomic,strong) NSString *access_token; //登陆后获取的token
@property (nonatomic,strong) NSString *cover;        //头像
@property (nonatomic,strong) NSNumber *score;        //账户余额
@property (nonatomic,strong) NSNumber *client_id;   //用户终端编号，用来确定是哪个终端登陆的
@property (nonatomic,strong) NSNumber *sex;         //用户性别，1男2女
@property (nonatomic,strong) NSNumber *store_id;         //用户最后一次选择的门店编号
@property (nonatomic,strong) NSString *store_Address;         //用户最后一次选择的门店地址
@property (nonatomic,strong) NSString *phone;         //手机号
@property (nonatomic,strong) NSNumber *userId;           //用户Id
@property (nonatomic,strong) NSNumber *auth;        //是否加V的标示 1加V 0 不加V
@property (nonatomic,strong) NSNumber *bonusPoint; //积分
@property (nonatomic,strong) NSNumber *verify; //帐号审核状态  0未审核 1已通过 2已拒绝
@property (nonatomic,strong) NSString *wbUid; //微博id
@property (nonatomic,strong) NSString *wbName; //微博名字
@property (nonatomic,strong) NSString *wxUid; //微信id
@property (nonatomic,strong) NSString *wxName; //微信名字

/** userCode */
@property (nonatomic,copy) NSString * userCode;



/** 是否在线 */
@property (nonatomic,strong) NSNumber  *isOnLine;//1在线 0不在线
/** 登录成功回调 */
@property (nonatomic,assign) void(^loginSuccess)();


/**
 *    登录成功，保存用户信息
 */
- (void)loginSuccessUpdateUserData:(id)responseObject;
///**
// *    保存用户选择的店铺
// */
//- (void)saveStoreId:(NSNumber *)storeId;

+(id)user;

/**
 *    自动登录
 */
-(void)autoLogin;
/**
 *    注销
 */
-(void)logout;
/**
 *    注销,不跳到首页
 */
-(void)logoutNotGoHome;
//当登录或者注册时,返回的数据直接使用这个方法进行解析
-(void)parsingData:(NSData *)data complete:(void(^)(BOOL,NSString *))cb;

/**
 *  注册或者登录使用同一个接口
 *
 *  @param params  参数列表
 *  @param isLogin 标识是否是登录操作
 *  @param cb      回调
 */
-(void)connectWithParams:(NSDictionary *)params isLogin:(BOOL)isLogin complete:(void(^)(BOOL,NSString *))cb;
/**
 *  第三方登录
 *
 *  @param params  参数列表
 *  @param cb      回调
 */
-(void)thirdPartyLoginInWithParams:(NSDictionary *)params  complete:(void(^)(BOOL result,NSDictionary *response))cb;
/**
 *  第三方注册
 *
 *  @param params  参数列表
 *  @param cb      回调
 */
-(void)thirdPartyRegistWithParams:(NSDictionary *)params  complete:(void(^)(BOOL result,NSDictionary *response))cb;

/**
 *  刷新个人信息
 */
-(void)refreshPersonalInformationSuccess:(void(^)())success;
@end

NS_ASSUME_NONNULL_END
