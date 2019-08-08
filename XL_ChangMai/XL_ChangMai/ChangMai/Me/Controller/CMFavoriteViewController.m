//
//  CMFavoriteViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMFavoriteViewController.h"
#import  "XLGoodsCollectionViewCell.h"
#import "CMGoodSetViewController.h"
#import "CMStoreViewController.h"
#import "CMTabBarController.h"
@interface CMFavoriteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSInteger _pageSize;
    NSInteger _currentPage;
    NSNumber *_sort;    /** 默认排序 为1*/
    
    
    BOOL _isMore;
}
/** 是否刷新 */
@property (nonatomic,assign) BOOL  isRefresh;
/** 瀑布流 */
@property (nonatomic,strong) UICollectionView *collectionView;


@end

static NSString *GoodsCollctionID = @"GoodsCollctionID1";
@implementation CMFavoriteViewController

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWidth = (__kWindow_Width - 10)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth + 80);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        CGFloat collectionY = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, collectionY, __kWindow_Width, __kWindow_Height - collectionY) collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = __kViewBgColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"JNGoodsCollectionCell" bundle:nil] forCellWithReuseIdentifier:GoodsCollctionID];
        //        [_collectionView registerClass:[LGLastGoodItemCell class] forCellWithReuseIdentifier:GoodsCollctionID];
        [self.view addSubview:_collectionView];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        //        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            self.isRefresh = YES;
        //            [self requestGoods];
        //            [_collectionView.mj_header endRefreshing];
        //        }];
        //
        //        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //            self.isRefresh = NO;
        //            _currentPage ++;
        //            [self requestGoods];
        //        }];
        //
        //        /* 开启 自动刷新 */
        //        [self.collectionView.mj_header beginRefreshing];
        
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /** 初始化默认值 */
    _pageSize = 10;
    _currentPage = 1;
    _sort = @(1);
    _isRefresh = YES;
    self.title = @"我的收藏";
    [self requestData];
}




#pragma mark - 请求 数据
-(void)requestData
{
    
    [[HttpManager shareInstance] get:@"collect" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        //        NSLog(@"----返回数据：%@",response);
        self.dataArray = response[@"items"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
    
    
}



#pragma mark - 请求商品数据
-(void)requestGoods
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    
    //    [postDic setObject:@(_pageSize) forKey:@"pageSize"];
    //    [postDic setObject:@(_currentPage) forKey:@"currentPage"];
    //    [postDic setObject:_sort forKey:@"sort"];
    //    LoginUser *user = [LoginUser user];
    //    NSNumber *loginType = user.type;
    //    [postDic setObject:loginType forKey:@"type"];
    
    //    [[HttpManager shareInstance]post:@"allGoodsNew" parameter:postDic withHUDTitle:nil success:^(AFHTTPRequestOperation *operation, id response) {
    //        NSInteger totalCount = [response[@"totalCount"] integerValue];
    //        _searchResultDict = response?response:@{};
    //
    //
    //
    //        if (_isRefresh) {
    //            self.dataMArray = [JNGoodsModel getArrayWithArray:response[@"objList"]];
    //
    //            if (self.dataMArray.count == totalCount) {
    //                [_collectionView.mj_footer endRefreshingWithNoMoreData];
    //            }else
    //                [_collectionView.mj_footer resetNoMoreData];
    //            [_collectionView.mj_header endRefreshing];
    //        }else
    //        {
    //            [self.dataMArray addObjectsFromArray:[JNGoodsModel getArrayWithArray:response[@"objList"]]];
    //            if (self.dataMArray.count == totalCount) {
    //                [_collectionView.mj_footer endRefreshingWithNoMoreData];
    //            }else
    //                [_collectionView.mj_footer endRefreshing];
    //            [_collectionView.mj_header endRefreshing];
    //
    //        }
    //
    //        [self.collectionView reloadData];
    //        if (self.dataMArray.count == 0) {
    //            _collectionView.mj_footer.hidden = YES;
    //            [EmptyImageView showInView:self.view];
    //        }else{
    //            [EmptyImageView hideFromView:self.view];
    //        }
    //        [Tools LogWith:response WithTitle:@"商品搜索结果"];
    //
    //    } failure:^(AFHTTPRequestOperation *operation, id response) {
    //        if (!_isRefresh) {
    //            _currentPage --;
    //        }
    //    }];
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollctionID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //    cell.modelGoods = self.dataMArray[indexPath.row];
    cell.dataDict = self.dataArray[indexPath.item];
    return cell;
}
#pragma mark - 点击图片查看详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int storeId =  [[[LoginUser user] store_id] intValue];
    if (storeId == 0) {
        CMStoreViewController *store = [[CMStoreViewController alloc] init];
        store.title = @"门店";
        CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
        [tabbarController updateTabNavigationRootController:store];
        return;
    }
    CMGoodSetViewController *detailVc = [[CMGoodSetViewController alloc]init];
    //    detailVc.itemId = model._id;
    detailVc.goodId = [self.dataArray[indexPath.item][@"gid"] longLongValue];
    detailVc.storeId = storeId;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
    //    return 10;
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
