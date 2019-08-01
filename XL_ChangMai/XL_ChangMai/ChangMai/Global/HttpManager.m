//
//  HttpManager.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/22.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "HttpManager.h"
#import <YYCache/YYCache.h>
//YYCache
NSString * const AllStarHttpCache = @"SPHttpCache";
#define NET_ERROR_MSG  @"msg";
@implementation HttpManager
static HttpManager *_instance = nil;

+(HttpManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance  = [[HttpManager alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self.manager.requestSerializer setTimeoutInterval:20];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    }
    return self;
}


- (void)get:(NSString *)url parameter:(NSDictionary *)parameter withHUDTitle:(NSString *)title isCache:(BOOL)isCache success:(ClientManagerBlock)success failure:(ClientManagerBlock)failure {
    if (title.length) {
        
    }
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[parameter allKeys]];
    NSInteger count = [temp count];
    for (int i = 0; i<count; i++) {
        for (int j = 0; j < count -i -1; j++) {
            if ([[temp objectAtIndex:j] compare:[temp objectAtIndex:j+1]]) {
                //同上potions  NSNumericSearch = 64,
                [temp exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                //这里可以用exchangeObjectAtIndex:方法来交换两个位置的数组元素。
            }
        }
    }
    
    //    for (NSString *i in temp) {
    //        NSLog(@"%@", i);
    //    }
    
    NSMutableString *paramString = [NSMutableString string];
    for (NSString *key in temp) {
        [paramString appendFormat:@"%@%@",key,[parameter objectForKey:key]];
    }
    
    LoginUser *user = [LoginUser user];
    long long nowTime = (long long)[[NSDate date] timeIntervalSince1970];
    
    NSString *sourceStr = [NSString stringWithFormat:@"%@%@%@%@%@",user.access_token,paramString,@(nowTime),paramrKey,user.client_id];
    
    NSLog(@"----请求sourceStr：%@",sourceStr);
    
    NSString *signString = [sourceStr md5];
    
    NSMutableString *webPath =  [NSMutableString stringWithFormat:@"%@%@?access_token=%@&timestamp=%@&app_key=%@&client=%@&sign=%@",__kUrlapi,url,user.access_token,@(nowTime),paramrKey,user.client_id,signString];
    
    for (NSString *key in temp) {
        [webPath appendFormat:@"&%@=%@",key,[parameter objectForKey:key]];
    }
    
    webPath = [webPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //url不允许为中文等特殊字符，需要进行字符串的转码为URL字符串，例如空格转换后为“%20”；
    
    
    NSLog(@"----请求地址：%@",webPath);
    
    [self.manager GET:webPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            //            [Tools LogWith:responseObject WithTitle:nil];
            
            NSLog(@"----返回数据：%@",responseObject);
            
            success(task,dict);
            
        } else {
            failure(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        //        [Tools LogWith:error WithTitle:nil];
        
        failure(task,error);
    }];
}

-(void)get:(NSString *)url parameter:(NSDictionary *)parameter withHUDTitle:(NSString *)title success:(ClientManagerBlock)success failure:(ClientManagerBlock)failure
{
    [self get:url parameter:parameter withHUDTitle:title isCache:NO success:success failure:failure];
}


-(void)post:(NSString *)url parameter:(NSDictionary *)parameter formData:(BOOL)formDataType image:(UIImage *)img images:(NSArray *)imageArr name:(NSString *)name withHUDTitle:(NSString *)title isCache:(BOOL)isCache success:(ClientManagerBlock)success failure:(ClientManagerBlock)failure
{
    if (title.length) {
    }
    if (!url.length) {
        NSLog(@"url为空 ----- ");
        return;
    }
    
    LoginUser *user = [LoginUser user];
    
    long long nowTime = (long long)[[NSDate date] timeIntervalSince1970];
    
    NSString *sourceStr = [NSString stringWithFormat:@"%@%@%@%@",user.access_token,@(nowTime),paramrKey,user.client_id];
    
    NSLog(@"----请求sourceStr：%@",sourceStr);
    
    NSString *signString = [sourceStr md5];
    
    NSMutableString *webPath =  [NSMutableString stringWithFormat:@"%@%@?access_token=%@&timestamp=%@&app_key=%@&client=%@&sign=%@",__kUrlapi,url,user.access_token,@(nowTime),paramrKey,user.client_id,signString];
    
    
    webPath = [webPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //url不允许为中文等特殊字符，需要进行字符串的转码为URL字符串，例如空格转换后为“%20”；
    
    
    NSLog(@"----请求地址：%@",webPath);
    
    
    
    //设置YYCache属性
    YYCache *cache = [[YYCache alloc] initWithName:AllStarHttpCache];
    
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    
    
    id cacheData;
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",url,parameter];
    NSLog(@"cacheKey: %@",[cacheKey class]);
    if (isCache) {
        
        
        //根据网址从Cache中取数据
        cacheData = [cache objectForKey:cacheKey];
        
        if (cacheData != 0) {
            //将数据统一处理
            id myResult = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
            success(nil,myResult);
            return;
        }
    }
    
    
    
    
    if (formDataType) {//上传图片
        
        
        [self.manager POST:webPath parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//这里面没做优化,建议用一个单例
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];//文件名
            
            if (name.length) {//单张图片
                NSData *imageData = [Tools imageToData:img];
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg"];//name:file与服务器对应
            }else{//多张图片
                for (int i = 0; i < imageArr.count; i ++) {
                    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                    formatter.dateFormat=@"yyyyMMddHHmmss";
                    NSString *str=[formatter stringFromDate:[NSDate date]];
                    NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
                    UIImage *image = imageArr[i];
                    NSData *imageData = [Tools imageToData:image];
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i+1] fileName:fileName mimeType:@"image/jpg"];
                }
            }
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 请求成功
            if(responseObject){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                if (isCache) {//缓存数据
                    
                    NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    dataString = [self deleteSpecialCodeWithStr:dataString];
                    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                    [cache setObject:requestData forKey:cacheKey];
                }
                
                
                
                success(task,dict);
            } else {
                //                [Tools LogWith:responseObject WithTitle:nil];
                
                failure(task,responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task,error);
            
        }];
        
        
        return;
    }
    
    
    
    [self.manager POST:webPath parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if (isCache) {//缓存数据
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                dataString = [self deleteSpecialCodeWithStr:dataString];
                NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                [cache setObject:requestData forKey:cacheKey];
            }
            
            
            
            success(task,dict);
        } else {
            [Tools LogWith:responseObject WithTitle:nil];
            
            failure(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        //        [Tools LogWith:error WithTitle:nil];
        
        failure(task,error);
    }];
    
    
}


-(void)post:(NSString *)url parameter:(NSDictionary *)parameter withHUDTitle:(NSString *)title success:(ClientManagerBlock)success failure:(ClientManagerBlock)failure
{
    [self post:url parameter:parameter formData:NO image:nil images:nil name:nil withHUDTitle:title isCache:NO success:success failure:failure];
}

-(void)post:(NSString *)url parameter:(NSDictionary *)parameter images:(NSArray *)imagesArr withHUDTitle:(NSString *)title success:(ClientManagerBlock)success failure:(ClientManagerBlock)failure
{
    [self post:url parameter:parameter formData:YES image:nil images:imagesArr name:nil withHUDTitle:title isCache:NO success:success failure:failure];
}


#pragma mark -- 处理json格式的字符串中的换行符、回车符
- (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}

@end
