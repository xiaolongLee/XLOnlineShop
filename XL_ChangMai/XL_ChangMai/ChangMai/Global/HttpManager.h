//
//  HttpManager.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/22.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClientManagerBlock)(NSURLSessionDataTask *operation, id response);
@interface HttpManager : NSObject
@property (nonatomic,strong) AFHTTPSessionManager *manager;

+(HttpManager *)shareInstance;
-(void)get:(NSString *)url parameter:(NSDictionary *)parameter withHUDTitle:(NSString *)title success:(ClientManagerBlock)success
    failure:(ClientManagerBlock)failure;

-(void)post:(NSString *)url parameter:(NSDictionary *)parameter withHUDTitle:(NSString *)title success:(ClientManagerBlock)sucess
    failure:(ClientManagerBlock)failure;

-(void)post:(NSString *)url parameter:(NSDictionary *)parameter withHUDTitle:(NSString *)title isCache:(BOOL)isCache sucess:(ClientManagerBlock)sucess failure:(ClientManagerBlock)failure;

- (void)post:(NSString *)url parameter:(NSDictionary *)parameter image:(UIImage *)img name:(NSString *)name withHUDTitle:(NSString *)title success:(ClientManagerBlock)success failure:(ClientManagerBlock)failure;

-(void)post:(NSString *)url parameter:(NSDictionary *)parameter images:(NSArray *)imagesArr withHUDTitle:(NSString *)title success:(ClientManagerBlock)success failure:(ClientManagerBlock)failure;

-(void)get:(NSString *)url parameter:(NSDictionary *)parameter withHUDTitle:(NSString *)title isCache:(BOOL)isCache success:(ClientManagerBlock)success failure:(ClientManagerBlock)failure;
@end

NS_ASSUME_NONNULL_END
