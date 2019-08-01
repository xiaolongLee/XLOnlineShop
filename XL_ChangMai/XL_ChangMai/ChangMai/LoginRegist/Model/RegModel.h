//
//  RegModel.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/23.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegModel : NSObject
+(RegModel*)sharedRegModel;
-(void)createEmpty;
/**
 *  注册手机
 */
@property (nonatomic,strong) NSString *loginId;
/**
 *  注册密码
 */
@property (nonatomic,strong) NSString *passWord;
/**
 *  用户名
 */
@property (nonatomic,strong) NSString *username;
/**
 *  性别 1男 0女
 */
@property (nonatomic,strong) NSString *sex;
/**
 *  头像地址
 */
@property (nonatomic,strong) NSString *iconUrl;
/**
 *  第三方注册的用户ID
 */
@property (nonatomic,strong) NSString *usid;
/**
 *  第三方授权的accessToken
 */
@property (nonatomic,strong) NSString *accessToken;
/**
 *  微信的openid
 */
@property (nonatomic,strong) NSString *openid;
/**
 *  第三方注册类型 1微博 2微信
 */
@property (nonatomic,strong) NSNumber *type;
@end

NS_ASSUME_NONNULL_END
