//
//  CMHomeViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMHomeViewController.h"
#import "SDCycleScrollView.h"           //轮播图
#import "CMTabBarController.h"
#import "CMStoreViewController.h"
#import "XLGoodsCollectionViewCell.h"
#import "CMHotCellView.h"
//#import "CMSearchGoodViewController.h"
#import "CMStoreGoodsViewController.h"
//#import "CMGoodSetViewController.h"
//#import "CMGoodsViewController.h"
#define headRightViewHeight 30
#define sectionMargin 9
@interface CMHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
{
    NSString *_locatedAddress;
    CGFloat lat;
    CGFloat lng;
}
/** headerView */
@property (nonatomic,strong) UIView *headerView;
/** 顶部热销hotView */
@property (nonatomic,strong) UIView *hotView;

/** 轮播图array */
@property (nonatomic,strong) NSMutableArray *bannerMArray;
/** 轮播图 */
@property (nonatomic,weak) UIImageView *bannerView;

/** 会员专享区 collectionView */
@property (nonatomic,strong) UICollectionView *collectionView;
/** 会员专享 数据源 */
@property (nonatomic,strong) NSMutableArray *dataCArray;
/** 会员专享 布局 */
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
/** 会员专享 显示行数 */
@property (nonatomic,assign) NSInteger lineNum;

/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;
//@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end

@implementation CMHomeViewController
static NSString *GoodsCollctionID = @"GoodsCollctionID1";
/** 轮播图高度 */
static float bannerHeight = 250;

- (NSMutableArray *)bannerMArray {
    if (!_bannerMArray) {
        _bannerMArray = [NSMutableArray array];
    }
    return _bannerMArray;
}

- (NSMutableArray *)dataCArray {
    if (!_dataCArray) {
        _dataCArray = [NSMutableArray array];
    }
    return _dataCArray;
}


- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        /** 设置滚动方向 */
        flowLayout.scrollDirection  = UICollectionViewScrollDirectionVertical;
        CGFloat itemWidth = (__kWindow_Width - 10)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 80);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = __kViewBgColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"JNGoodsCollectionCell" bundle:nil] forCellWithReuseIdentifier:GoodsCollctionID];
    }
    
    return _collectionView;
}

- (UIView *)headerView {
    if (!_headerView) {
         /** headerView  包含轮播图250  间隙 8  明星案例 130  = 378    */
        CGFloat headMargin = 8;
        CGFloat hotViewHeight = 130;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width  , bannerHeight + headMargin + hotViewHeight)];
        
         /** 轮播图 */
        UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __kWindow_Width, bannerHeight)];
        bannerView.image = [UIImage imageNamed:@"banner"];
        bannerView.userInteractionEnabled = YES;
        [_headerView addSubview:bannerView];
        _bannerView = bannerView;
        
        /** 明星案例 */
        UIView *hotView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bannerView.frame) + headMargin, __kWindow_Width, hotViewHeight)];
        hotView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:hotView];
        _hotView = hotView;
        
        
        
    }
    
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
