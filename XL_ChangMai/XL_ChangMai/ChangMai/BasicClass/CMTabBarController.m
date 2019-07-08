//
//  CMTabBarController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/4.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMTabBarController.h"
#import "CMBaseViewController.h"
#import "CMHomeViewController.h"
#import "CMStoreViewController.h"
#import "CMDiscoverViewController.h"
#import "CMShopCarViewController.h"
#import "CMMeViewController.h"
#import "CMLoginViewController.h"
#import "CMStoreGoodsViewController.h"
#import "CMOrderDetailViewController.h"
#import "CMBaseNavigationController.h"
#define kClassKey  @"rootVCClassString"
#define kTitleKey  @"title"
#define kImgKey    @"imageName"
#define kSelImgKey @"selectedImageName"
@interface CMTabBarController ()

@end

@implementation CMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *childItemArray = @[
                                @{kClassKey : @"CMHomeViewController",
                                  kTitleKey : @"首页",
                                  kImgKey : @"footer1",
                                  kSelImgKey : @"footer1-2"},
                                
                                @{kClassKey : @"CMStoreViewController",
                                  kTitleKey : @"门店",
                                  kImgKey : @"footer2",
                                  kSelImgKey : @"footer2-2"},
                                
                                @{kClassKey : @"CMDiscoverViewController",
                                  kTitleKey : @"发现",
                                  kImgKey : @"footer3",
                                  kSelImgKey : @"footer3-2"},
                                
                                @{kClassKey : @"CMShopCarViewController",
                                  kTitleKey : @"购物车",
                                  kImgKey : @"footer4",
                                  kSelImgKey : @"footer4-2"},
                                
                                @{kClassKey : @"CMMeViewController",
                                  kTitleKey : @"我的",
                                  kImgKey : @"footer5",
                                  kSelImgKey : @"footer5-2"}];
    
    [childItemArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        if ([vc isKindOfClass:[CMShopCarViewController class]]) {
            CMShopCarViewController *vcShopCar = (CMShopCarViewController *)vc;
            vcShopCar.isInHome = YES;
        }
        
        CMBaseNavigationController *nav = [[CMBaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem  *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : __kThemeColor} forState:UIControlStateSelected];
        [self addChildViewController:nav];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLogin) name:__KNotiLogin object:nil];
}

- (void)goToLogin{
    CMLoginViewController *loginVC = [[CMLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if ([item.title isEqualToString:@"门店"]) {
        int storeId = 0;
        if (storeId == 0) {
            CMStoreViewController *store = [[CMStoreViewController alloc] init];
            store.title = @"门店";
            
        }else {
            CMStoreGoodsViewController *goodsVc = [[CMStoreGoodsViewController alloc] init];
           // goodsVc.storeId =
            
        }
    }else if ([item.title isEqualToString:@"购物车"]) {
        
    }
}

- (void)updateTabNavigationRootController:(UINavigationController *)vController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CMBaseNavigationController *nav = [self.childViewControllers objectAtIndex:1];
        [nav setViewControllers:@[vController]];
        self.selectedIndex =1;
    });
}

- (void)pushOrderDetailViewController:(NSString *)orderId {
    CMBaseNavigationController *nav = self.selectedViewController;
    [nav popToRootViewControllerAnimated:NO];
    CMOrderDetailViewController  *detail = [[CMOrderDetailViewController alloc] init];
   // detail.soNo = orderId;
    [nav pushViewController:detail animated:YES];
    self.orderNO = @"";
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
