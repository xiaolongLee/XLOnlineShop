//
//  main.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/6/27.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//全局变量
int const serviceId = 116226;//此处填写在鹰眼管理后台创建的服务的ID
NSString *const AK = @"Yfl213qakw1IBtr3egqlokPbcGHeLLHg";//此处填写您在API控制台申请得到的ak，该ak必须为iOS类型的ak
NSString *const MCODE = @"com.eReach.Monitor";//此处填写您申请iOS类型ak时填写的安全码
double const EPSILON = 0.0001;




int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
