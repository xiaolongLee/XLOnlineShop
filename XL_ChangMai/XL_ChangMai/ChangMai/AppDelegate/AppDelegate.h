//
//  AppDelegate.h
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/6/27.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
/**
 *    配合BaseViewController 里面的 通知 来进行操作token时 跳到登录界面 保证只跳一次
 */
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) BOOL isFirstTime;




@end

