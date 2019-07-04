//
//  AppHeader.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/4.
//  Copyright © 2019 李小龙. All rights reserved.
//

#ifndef AppHeader_h
#define AppHeader_h

/** 服务器 */
//#define __kUrlapi  @"http://api.all-star.top/allstar_api/"

/** 测试服务器地址 */
#define __kUrlapi   @"http://changmai.zhixuandajiankang.com/api/"

/** 测试服务器 本地地址 */
//#define __kUrlapi   @"http://192.168.31.133:8080/allstar_api/"


#define paramrKey @"gm8Pyx3sbuCdqsspYylv3rhh9Bt40vn7"

#define Font(s) [UIFont systemFontOfSize:(s)]

#define FontBold(s) [UIFont boldSystemFontOfSize:(s)]


/** 视图背景颜色 */
#define __kViewBgColor  [UIColor colorWithHexString:@"#eeeee"]

/** 内容背景颜色 */
#define __kContentBgColor  [UIColor colorWithHexString:@"#fbfbfb"]

/** 主题颜色 */
#define __kThemeColor  [UIColor colorWithHexString:@"#f25b7f"]

// RGB颜色
#define __kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// RGB颜色
#define __kColorR_G_B_A(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 随机色
#define __kColorRandom HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/** 分割线颜色 */
//#define __kLineColor  [UIColor colorWithRed:0.88f green:0.87f blue:0.92f alpha:1.00f]
#define __kLineColor    [UIColor colorWithHexString:@"e5e5e5"]

#define __kFontColor [UIColor colorWithRed:0.08f green:0.08f blue:0.20f alpha:1.00f]

#define __kcolorNavi  [UIColor colorWithRed:0.07f green:0.02f blue:0.37f alpha:1.00f]

//#define __kcolorBtn  [UIColor colorWithRed:0.07f green:0.02f blue:0.37f alpha:1.00f]
#define __kcolorBtn    [UIColor colorWithHexString:@"#4a4cc8"]

#define __kcolorText_Black    [UIColor colorWithHexString:@"#464646"]

#define __kGreen_Color    [UIColor colorWithHexString:@"5bd6c1"]

/** 屏幕宽度 */
#define __kWindow_Width  [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define __kWindow_Height [UIScreen mainScreen].bounds.size.height

/*宽 根据6的屏宽比*/
#define myWith6(w) [UIScreen mainScreen].bounds.size.width / 375.0 * (w)

/*高 根据6的屏高比 */
#define myHeight6(h) [UIScreen mainScreen].bounds.size.height / 667.0 * (h)

#define __kViewWidth  ([UIScreen mainScreen].bounds.size.width - 30)

/** 一条线的高度或宽度 */
#define __kLine_Width_Height 1.0/2

#define __kScreenMargin 10       //距屏幕边距

#define __KViewY 64         //导航栏的最大Y值
#define __KtabBarHeight 49  //标签栏高度

#define __kBUTTON_Height 40  //按钮默认高度

#define __kTextField_Height 40  //按钮默认高度

#define __kCORNERRADIUS_BUTTON_LITTLE 3
#define __kCORNERRADIUS_BUTTON 20


#define __kID @"16"
/** @"yyyy-MM-dd HH:mm:ss" */
#define __kTimeFormatyMdHms @"yyyy-MM-dd HH:mm:ss"
#define __kTimeFormatyMd    @"yyyy-MM-dd"
#define __kTimeFormatyMdHm    @"MM-dd HH:mm"
#define __kLogined @"logined"
#define __kUserPhone @"userPhone"
#define __kService @"service"
#define __kUserName @"username"
#define __kToken @"token"
#define __kType @"type"
#define __kLoginType @"loginType"

/** 记录上一次登录的号码 */
#define __kLastPhone @"lastPhone"


#define __kUUID @"serviceUUID"
#define __kRemeberPassword @"remeberPassword"

/** 发通知  让用户去登录 */
#define __KNotiLogin @"NotificationLogin"

#define __KNotiOnLine @"NotificationOnLine"
/** 异地登录 */
#define __KNotiOutLine @"NotificationOutLine"

/* 首页 */
#define __KNotiGoToHomePage @"gotoHomePage"

#define __KNotiGoToStarCirclePage @"StarCirclePage"
#define __KNotiGoToBrandPage @"GoToBrandPage"
/* 个人中心 */
#define __KNotiGoToPersonalPage @"GoToPersonalPage"

#define __KNotiPaySuccess @"PaySuccess"
#define __KNotiWXPayFailure @"WXPayFailure"

/** 注销的时候 发送一个通知 */
#define __KNotiLoginOut @"KNotiLoginOut"
/** 登录成功的时候 发送一个通知 */
#define __KNotiLoginIn @"KNotiLoginIn"
/** 登录界面点击返回 发送一个通知 */
#define __KLoginInGoBack @"KLoginInGoBack"

/** 微信登陆授权成功 发送一个通知 */
#define __KLoginInWeChat @"KLoginInWeChat"
/** 微博登陆授权成功 发送一个通知 */
#define __KLoginInWeiBo @"KLoginInWeiBo"

/** 商品详情参数 */
#define __KGoodDetailData @"KGoodDetailData"
/** 收藏商品，取消收藏 */
#define __KFavoriteGood @"KFavoriteGood"
/** 更新商品参数界面数据 */
#define __KUpdateGoodParamData @"UpdateGoodParamData"


/**
 * 网络状况改变的通知
 */
#define  kNetworkStatusFailedNotification @"kNetworkStatusFailedNotification"

#define concernSuccessAlertString @"感谢你的支持"

#define concernFailedAlertString @"这是一个忧伤的故事"

#define likeSuccessAlertString @"你的喜欢是我最大的支持"

#define cacelLikedAlertString @"不喜欢我了，让我冷静一会"

#define recommendAuthorityAlertString @"目前只对开放哦~"

//友盟key
#define UMAppKey @"58a85b13c62dca12be000bab"


#define WEBVIEW_HEAD @"<html><header><meta name=\"viewport\" content=\"width=device-width - 20, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\"><style>p,body{margin:10;padding:0}img {max-width: 100%;}</style></header><body>"
#define WEBVIEW_END @"</body></html>"


#define BASE_URL  @"http://changmai.zhixuandajiankang.com"


typedef void(^ResponseCallback)(id result);

/* 订单状态 1 待支付 2 待发货 3 待收货 4 交易完成 5 已取消*/
#define ORDERSTATUSDECRIPTION_MAP @{\
@(1):@"待支付",\
@(2):@"待发货",\
@(3):@"待收货",\
@(4):@"交易完成",\
@(5):@"已取消",\
}






//------------------------- 支付宝支付 ------------------------

// 回调地址 --开发环境
#define  NOTIFYURL  [NSString  stringWithFormat:@"%@alipayNotifyPayment",__kUrlapi]
// 应用注册scheme
#define myAppScheme @"ChangMaiAliPay"



//全名星的
//------------------------- 微信支付 ------------------------

#define APP_ID          @"wxc0d4922ace6e8444"               //商户APPID

//#define APP_SECRET      @"1e9c0eca9aca9c5cbaccb2544bb00689"  //appsecret

// 商户号，填写商户对应参数
#define MCH_ID          @"1432116702"                       // 商户号

// 商户API密钥，填写相应参数
#define PARTNER_ID      @"2e006133aba28d03468b33f6194192ff"//商户密钥

//// 支付结果回调页面--生产环境
#define NOTIFY_URL     [NSString  stringWithFormat:@"%@wchatNotifyPayment",__kUrlapi]


//------------------------- 新浪微博 ------------------------

#define weiBo_APP_ID          @"1109642927"               //商户APPID


// 商户号，填写商户对应参数
//#define MCH_ID          @"1302358301"                       // 商户号

// 商户API密钥，填写相应参数
#define weiBo_APP_Secret      @"780be5dd6a1a9c51166c8dc4dfe808fa"//商户密钥

//// 回调页面--生产环境
#define weiBo_Redirect_URL     @"https://api.weibo.com/oauth2/default.html"


#endif /* AppHeader_h */
