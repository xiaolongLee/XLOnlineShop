//
//  CMGoodSetViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/19.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMGoodSetViewController.h"
#import "CMGoodDetailViewController.h"
#import "CMGoodParamViewController.h"
//#import <UShareUI/UShareUI.h>
#define childVCCount 2
#define indicatorH 2
#define indicatorW 70
#define topTabBarH 44
@interface CMGoodSetViewController ()
{
    UILabel *label1;
    UILabel *label2;
    NSUInteger currentShowIndex;
    
}
@property (strong, nonatomic) NSDictionary *dataDict;
@property (strong, nonatomic) UIScrollView *contentsScrollView;
@property(nonatomic,strong)UIView *indicatorView;

@property(nonatomic,strong)UIButton *favoriteBtn;
@end

@implementation CMGoodSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加contentView
    [self addContentView];
    
    [self addTopTabBar];
    // 添加子控制器
    [self setupChildVces];
    
    [self setRightBarItem];
    
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:__KFavoriteGood object:nil userInfo:@{@"collect":_dataDict[@"collect"]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFavorite:) name:__KFavoriteGood object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:__KUpdateGoodParamData object:nil];
    
}


- (void)setRightBarItem
{
    
    UIButton *search = [[UIButton alloc] init];
    search.frame = CGRectMake(0, 0, 30, 44);
    [search setImage:[UIImage imageNamed:@"star_icon"] forState:UIControlStateNormal];
    [search setImage:[UIImage imageNamed:@"star_icon_now"] forState:UIControlStateSelected];
    [search addTarget:self action:@selector(favoriteClick:) forControlEvents:UIControlEventTouchUpInside];
    self.favoriteBtn = search;
    
    
    UIButton *add = [[UIButton alloc] init];
    add.frame = CGRectMake(30, 0, 30, 44);
    [add setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(shareGood:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *right = [[UIView alloc] init];
    right.backgroundColor = [UIColor clearColor];
    right.frame = CGRectMake(0, 0, 60, 44);
    [right addSubview:search];
    [right addSubview:add];
    UIBarButtonItem *sitem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = sitem;
}




- (void)addContentView
{
    
    _contentsScrollView = [[UIScrollView alloc] init];
    _contentsScrollView.pagingEnabled = YES;
    _contentsScrollView.bounces = NO;
    _contentsScrollView.showsHorizontalScrollIndicator = NO;
    _contentsScrollView.showsVerticalScrollIndicator = NO;
    //    _contentsScrollView.backgroundColor = [UIColor blackColor];
    _contentsScrollView.delegate = self;
    _contentsScrollView.frame = CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY);
    _contentsScrollView.contentSize = CGSizeMake(__kWindow_Width *childVCCount, __kWindow_Width - __KViewY);
    [self.view addSubview:_contentsScrollView];
    
}



- (void)addTopTabBar
{
    //背景View
    UIView *topTabBar = [[UIView alloc] init];
    topTabBar.frame = CGRectMake(0, 0, __kWindow_Width - 150, topTabBarH);
    topTabBar.backgroundColor = [UIColor clearColor];
    topTabBar.layer.masksToBounds = YES;
    
    CGFloat labelW = topTabBar.width/childVCCount;
    CGFloat labelH = 44;
    label1 = [[UILabel alloc] init];
    label1.backgroundColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.frame = CGRectMake(0, 0, labelW, labelH);
    label1.font = Font(14);
    label1.text = @"图片详情";
    label1.textColor = __kThemeColor;
    label1.tag = 0;
    [label1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTabBarClick:)]];
    label1.userInteractionEnabled =YES;
    [topTabBar addSubview:label1];
    
    label2 = [[UILabel alloc] init];
    label2.backgroundColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.frame = CGRectMake(labelW, 0, labelW, labelH);
    label2.font = label1.font;
    label2.text = @"商品参数";
    label2.tag = 1;
    [label2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTabBarClick:)]];
    label2.userInteractionEnabled =YES;
    [topTabBar addSubview:label2];
    
    
    
    _indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = __kThemeColor;
    _indicatorView.frame = CGRectMake(0, topTabBarH - indicatorH , indicatorW, indicatorH);
    _indicatorView.centerX = label1.centerX;
    [topTabBar addSubview:_indicatorView];
    
    
    self.navigationItem.titleView = topTabBar;
}

/**
 *  添加子控制器
 */
- (void)setupChildVces
{
    // 添加
    CGFloat vcW = _contentsScrollView.frame.size.width;
    CGFloat vcH = _contentsScrollView.frame.size.height;
    CGFloat vcY = 0;
    
    CMGoodDetailViewController  *allSession = [[CMGoodDetailViewController alloc] init];
    allSession.goodId = self.goodId;
    allSession.storeId = self.storeId;
    [self addChildViewController:allSession];
    allSession.view.frame = CGRectMake(0, vcY, vcW, vcH);
    [_contentsScrollView addSubview:allSession.view];
    
    CMGoodParamViewController *patientSession = [[CMGoodParamViewController alloc] init];
    patientSession.goodId = self.goodId;
    patientSession.storeId = self.storeId;
    [self addChildViewController:patientSession];
    patientSession.view.frame = CGRectMake(vcW, vcY, vcW, vcH);
    [_contentsScrollView addSubview:patientSession.view];
    
    
}

/**
 *  顶部tabBar的点击
 */
- (void)topTabBarClick:(UITapGestureRecognizer *)recognizer
{
    
    UILabel *label = (UILabel *)recognizer.view;
    [self setContentsScrollViewContentOffsetWithIndex:(int)label.tag];
    
}

- (void)setContentsScrollViewContentOffsetWithIndex:(int)index
{
    // 计算x方向上的偏移量
    CGFloat offsetX = index * self.contentsScrollView.frame.size.width;
    // 设置偏移量
    CGPoint offset = CGPointMake(offsetX,0);
    [self.contentsScrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    UIViewController *vc1 = self.childViewControllers[currentShowIndex];
    
    [vc1 viewDidDisappear:YES];
    // 获得当前需要显示的子控制器的索引
    currentShowIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    
    
    if (currentShowIndex == 0) {
        label1.textColor = __kThemeColor;
        label2.textColor = [UIColor blackColor];
        // 移动指示条
        [UIView animateWithDuration:0.3 animations:^{
            _indicatorView.centerX = label1.centerX;
        }];
    }else{
        label2.textColor = __kThemeColor;
        label1.textColor = [UIColor blackColor];
        // 移动指示条
        [UIView animateWithDuration:0.3 animations:^{
            _indicatorView.centerX = label2.centerX;
        }];
    }
    
    UIViewController *vc = self.childViewControllers[currentShowIndex];
    
    [vc viewDidAppear:YES];
    
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


#pragma mark - 请求 数据
-(void)loadData:(NSNotification *)notifica
{
    _dataDict = notifica.userInfo[@"data"];
    
}





- (void)changeFavorite:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"collect"] integerValue] == 1) {
        self.favoriteBtn.selected = YES;
    }else{
        self.favoriteBtn.selected = NO;
    }
}


- (void)favoriteClick:(UIButton *)sender
{
    
    if (![[[LoginUser user] isOnLine] boolValue]) {
        
        return;
    }
    
    sender.userInteractionEnabled = NO;
    //    NSDictionary *dict = @{@"id":@(self.goodId)};
    
    /*
     1 . 商品编号    id    int
     2 . 操作类型    type    int    0为取消收藏，1为收藏
     */
    
    
    NSInteger type = 0;
    
    
    if (sender.selected) {
        type = 0;
    }else{
        type = 1;
    }
    
    NSDictionary *dict = @{@"id":@(self.goodId),
                           @"type":@(type)};
    
    
    [[HttpManager shareInstance] get:@"deal_good_collect" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        if ([response[@"result"] intValue] == 1) {
            sender.selected = type;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
            sender.userInteractionEnabled = YES;
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
            sender.userInteractionEnabled = YES;
        });
    }];
    
    
}




- (void)shareGood:(UIButton *)sender
{
    
    
    if (![[[LoginUser user] isOnLine] boolValue]) {
        
        return;
    }
    //    return;
    
    
    
    //显示分享面板
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//        
//        if (platformType == UMSocialPlatformType_WechatSession) {
//            
//            
//            
//        }else if (platformType == UMSocialPlatformType_WechatTimeLine){
//            
//        }else if (platformType == UMSocialPlatformType_WechatFavorite){
//            
//        }else if (platformType == UMSocialPlatformType_Sina){
//            
//            return ;
//        }
//        
//        
//        
//        //创建分享消息对象
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        
//        
//        NSString *shareTitle = [NSString stringWithFormat:@"%@-畅麦网",_dataDict[@"good"][@"title"]];
//        
//        
//        NSString *shareDesTitle = [NSString stringWithFormat:@"%@-畅麦网",_dataDict[@"good"][@"shipping_name"]];
//        
//        
//        //创建网页内容对象
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareDesTitle thumImage:[UIImage imageNamed:@"icon"]];
//        //设置网页地址
//        shareObject.webpageUrl = _dataDict[@"good"][@"url"];
//        
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//        
//        //调用分享接口
//        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//            if (error) {
//                NSLog(@"************Share fail with error %@*********",error);
//            }else{
//                NSLog(@"response data is %@",data);
//            }
//        }];
//        
//        
//        
//        
//    }];
    
    
    //    sender.userInteractionEnabled = NO;
    
    //    NSString *shareText = @"明星特权拍拍，明星都在用。";       //分享内嵌文字
    //    //    UIImage *shareImage = [_topImageView.image imageByScalingAndCroppingForSize:CGSizeMake(60, 60)];          //分享内嵌图片
    //    UIImage *shareImage = .image;          //分享内嵌图片
    //
    //    //调用快速分享接口
    //    [UMSocialSnsService presentSnsIconSheetView:self
    //                                         appKey:UMAppKey
    //                                      shareText:shareText
    //                                     shareImage:shareImage
    //                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
    //                                       delegate:self];
    //
    
}



//#pragma mark 友盟分享回调方法
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//
//        NSDictionary *par = @{@"id":_itemId};
//
//        //调接口 服务端统计分享次数
//        [[HttpManager  shareInstance]post:@"forwardGoodsCount" parameter:par withHUDTitle:nil success:^(AFHTTPRequestOperation *operation, id response) {
//
//
//        } failure:^(AFHTTPRequestOperation *operation, id response) {
//
//        }];
//
//    }
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
