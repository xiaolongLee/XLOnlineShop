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
#import "CMStoreCell.h"
#import "CMHomeImageCell.h"
#import "CMSearchGoodViewController.h"
#import "CMStoreGoodsViewController.h"
#import "CMGoodSetViewController.h"
#import "CMGoodsViewController.h"
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
        
        CMHotCellView *leftCell = [[CMHotCellView alloc] initWithFrame:CGRectMake(0, 0,__kWindow_Width/2,hotViewHeight )];
        leftCell.tag = 888;
        leftCell.type = 1;
        [_hotView addSubview:leftCell];
        
        CMHotCellView *rightCell = [[CMHotCellView alloc] initWithFrame:CGRectMake(__kWindow_Width/2, 0,__kWindow_Width/2,hotViewHeight )];
        rightCell.tag = 999;
        rightCell.type = 2;
        [_hotView addSubview:rightCell];
        
        UIView *line = [self createDefaultStyleLineFrame:CGRectMake(leftCell.right, 0, __kLine_Width_Height, hotViewHeight)];
        [_hotView addSubview:line];
        
    }
    
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    _lineNum = 2;
    [self createUI];
    [self performSelectorInBackground:@selector(requestData) withObject:nil];
    
    
//    [self.locService startUserLocationService];
}

- (void)createUI{
    UIView *statusView = [[UIView alloc] init];
    statusView.backgroundColor = [UIColor whiteColor];
    statusView.frame = CGRectMake(0, 0, __kWindow_Width, 20);
    [self.view addSubview:statusView];
    
    
    CGFloat searchViewH = 50;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, __kWindow_Width, searchViewH)];
    [searchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchGoods)]];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(0, 0, 50, searchViewH);
    [locationBtn setImage:[UIImage imageNamed:@"top_location"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:locationBtn];
    
    
    
    UITextField *_textFieldSearch = [[UITextField alloc]initWithFrame:CGRectMake(locationBtn.right, 5, __kWindow_Width - locationBtn.right - 10, searchViewH - 10)];
    _textFieldSearch.userInteractionEnabled = NO;
    _textFieldSearch.backgroundColor = __kColor(251, 251, 251);
    _textFieldSearch.layer.cornerRadius = 20;
    _textFieldSearch.clipsToBounds = YES;
    _textFieldSearch.font = Font(14);
    _textFieldSearch.layer.borderColor = __kColor(200, 200, 200).CGColor;
    _textFieldSearch.layer.borderWidth = 1;
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"seek_icon"];
    searchIcon.frame = CGRectMake(0, 0, 35, _textFieldSearch.height);
    searchIcon.contentMode = UIViewContentModeCenter;
    
    _textFieldSearch.placeholder = @"请输入商品名称";
    _textFieldSearch.leftView = searchIcon;
    _textFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    
    [searchView addSubview:_textFieldSearch];
    
    [self createTableViewFrame:CGRectMake(0, searchView.bottom, __kWindow_Width, __kWindow_Height - searchView.bottom - __KtabBarHeight) Style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - 请求 数据
-(void)requestData{
    NSDictionary *dict = @{@"lng":@(lng),
                           @"lat":@(lat)};
    NSLog(@"---经纬度：%@",dict);
    
    [[HttpManager shareInstance] get:@"index" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull response) {
        NSLog(@"----返回数据：%@",response);
        _dataDict = (NSDictionary *)response;
  
        dispatch_async(dispatch_get_main_queue(), ^{
            // 轮播图
            self.bannerMArray = [_dataDict objectForKey:@"rotate"];
            
            self.dataCArray = [_dataDict objectForKey:@"goods"];
            _lineNum = (self.dataCArray.count + 1)/2;
            
            NSMutableArray *imageURLStringGroup = [NSMutableArray array];
            
            for (NSDictionary *dict in _bannerMArray) {
                [imageURLStringGroup addObject:dict[@"img_url"]];
            }
            
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, __kWindow_Width, bannerHeight) imageNamesGroup:imageURLStringGroup];
            cycleScrollView.backgroundColor = [UIColor clearColor];
            if (imageURLStringGroup.count == 1) {
                cycleScrollView.autoScroll= NO;
            }
            cycleScrollView.delegate = self;
            cycleScrollView.autoScrollTimeInterval = 4.0;
            cycleScrollView.infiniteLoop= YES;
            cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            [_bannerView addSubview: cycleScrollView];
            
            // 热销
            CMHotCellView *hotcell1 = [_headerView viewWithTag:888];
            
            // 爆款
            CMHotCellView *hotcell2 = [_headerView  viewWithTag:999];
            
            [hotcell1 setPictureClickblock:^{
                int storeId =  [[[LoginUser user] store_id] intValue];
                if (storeId == 0) {
                    CMStoreViewController *store = [[CMStoreViewController alloc] init];
                    store.title = @"门店";
                    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
                    [tabbarController updateTabNavigationRootController:store];
                    return;
                }
                
                CMGoodsViewController *goods = [[CMGoodsViewController alloc] init];
                goods.producutTitle = @"热销";
                goods.sourceType = 5;
                goods.storeId = storeId;
                [self.navigationController pushViewController:goods animated:YES];
            }];
            
            [hotcell2 setPictureClickblock:^{
                int storeId =  [[[LoginUser user] store_id] intValue];
                if (storeId == 0) {
                    CMStoreViewController *store = [[CMStoreViewController alloc] init];
                    store.title = @"门店";
                    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
                    [tabbarController updateTabNavigationRootController:store];
                    return;
                }
                
                CMGoodsViewController *goods = [[CMGoodsViewController alloc] init];
                goods.producutTitle = @"爆款";
                goods.sourceType = 3;
                goods.storeId = storeId;
                [self.navigationController pushViewController:goods animated:YES];
            }];
            
            
            
            [self.tableView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull response) {
        
    }];
}

- (void)searchGoods
{
    CMSearchGoodViewController *store = [[CMSearchGoodViewController alloc] init];
    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
    [tabbarController updateTabNavigationRootController:store];
}

- (void)locationBtnClick
{
    CMStoreViewController *store = [[CMStoreViewController alloc] init];
    store.title = @"门店";
    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
    [tabbarController updateTabNavigationRootController:store];
}

#pragma mark tableView delegate And datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *arr = _dataDict[@"stores"];
        return arr.count;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [CMStoreCell cellHeight];
    }else if (indexPath.section == 1){
        return [CMHomeImageCell cellHeight];
    }else if (indexPath.section == 2){
         return self.flowLayout.itemSize.height*_lineNum + self.flowLayout.minimumLineSpacing*_lineNum;
    }
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *arr = _dataDict[@"stores"];
        if (arr.count == 0) {
            return 0;
        }
        return 50;
    }else if (section == 1){
        return 43;
    }else if (section == 2){
        return 40;
    }
    return 0.0000001f;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *arr = _dataDict[@"stores"];
        if (arr.count == 0) {
            return 0;
        }
        return 30;
    }else if (section == 1){
        return 0.0000001f;
    }else if (section == 2){
        return 0.0000001f;
    }
    return 0.0000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *arr = _dataDict[@"stores"];
        if (arr.count == 0) {
            return [[UIView alloc] init];
        }
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor clearColor];
        headView.frame = CGRectMake(0, 0, __kWindow_Width, 50);
        
        UIImageView *headImageV = [[UIImageView alloc] init];
        headImageV.image = [UIImage imageNamed:@"home_stores_top"];
        headImageV.userInteractionEnabled = YES;
        headImageV.frame = CGRectMake(0, sectionMargin, __kWindow_Width, 13);
        headImageV.contentMode = UIViewContentModeScaleToFill;
        [headView addSubview:headImageV];
        
        
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.frame = CGRectMake(0, headImageV.bottom, __kWindow_Width, 30);
        hintLabel.backgroundColor = [UIColor whiteColor];
        hintLabel.text = @"   门店体验";
        hintLabel.textColor = [UIColor blackColor];
        hintLabel.font = Font(17);
        [headView addSubview:hintLabel];
        
        UIView *rightV = [self createRightViewFrame:CGRectMake(__kWindow_Width - 50 - __kScreenMargin, headImageV.bottom, 50, headRightViewHeight)];
        [rightV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreClick_Store)]];
        [headView addSubview:rightV];
        [rightV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationBtnClick)]];
        
        return headView;
    }else if (section == 1){
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor whiteColor];
        headView.frame = CGRectMake(0, 0, __kWindow_Width, 43);
        
        UIImageView *headImageV = [[UIImageView alloc] init];
        headImageV.image = [UIImage imageNamed:@"h_news_porduct_bg"];
        headImageV.userInteractionEnabled = YES;
        headImageV.frame = headView.bounds;
        headImageV.contentMode = UIViewContentModeScaleToFill;
        [headView addSubview:headImageV];
        
        
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.frame = CGRectMake(0, 0, __kWindow_Width, headView.height);
        hintLabel.backgroundColor = [UIColor clearColor];
        hintLabel.text = @"   新品专栏";
        hintLabel.textColor = [UIColor blackColor];
        hintLabel.font = Font(17);
        [headView addSubview:hintLabel];
        return headView;
    }else if (section == 2){
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor clearColor];
        headView.frame = CGRectMake(0, 0, __kWindow_Width, 40);
        
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.frame = CGRectMake(0,10, __kWindow_Width, headView.height - 10);
        hintLabel.backgroundColor = [UIColor clearColor];
        hintLabel.text = @"   会员专享区";
        hintLabel.textColor = [UIColor blackColor];
        hintLabel.font = Font(17);
        [headView addSubview:hintLabel];
        
        UIView *rightV = [self createRightViewFrame:CGRectMake(__kWindow_Width - 50 - __kScreenMargin, 10, 50, headRightViewHeight)];
        [rightV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreClick_Member)]];
        [headView addSubview:rightV];
        
        return headView;
    }
    return [UIView new];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *arr = _dataDict[@"stores"];
        if (arr.count == 0) {
            return [[UIView alloc] init];
        }
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = __kViewBgColor;
        footView.frame = CGRectMake(0, 0, __kWindow_Width, 30);
        
        UIImageView *bottomImage = [[UIImageView alloc] init];
        bottomImage.backgroundColor = __kViewBgColor;
        bottomImage.image = [UIImage imageNamed:@"home_stores_bottom"];
        bottomImage.frame = CGRectMake(0, 0, __kWindow_Width, 13);
        bottomImage.contentMode = UIViewContentModeScaleToFill;
        [footView addSubview:bottomImage];
        
        return footView;
    }else if (section == 1){
        return [UIView new];
    }else if (section == 2){
        return [UIView new];
    }
    return [UIView new];
}

- (UIView *)createRightViewFrame:(CGRect)rightFrame
{
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor clearColor];
    rightView.frame = rightFrame;
    
    CGFloat arrowW = 8;
    UIImageView *headImageV1 = [self createArrowImageViewFrame:CGRectMake(rightView.width - arrowW, 0, arrowW, headRightViewHeight)];
    [rightView addSubview:headImageV1];
    
    UIImageView *headImageV2 = [self createArrowImageViewFrame:CGRectMake(rightView.width - 2*arrowW, 0, arrowW, headRightViewHeight)];
    [rightView addSubview:headImageV2];
    
    
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.frame = CGRectMake(0, 0, headImageV2.left, headRightViewHeight);
    moreLabel.backgroundColor = [UIColor clearColor];
    moreLabel.text = @"更多 ";
    moreLabel.textAlignment = NSTextAlignmentRight;
    moreLabel.textColor = [UIColor lightGrayColor];
    moreLabel.font = Font(15);
    [rightView addSubview:moreLabel];
    return rightView;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        NSArray *arr = _dataDict[@"stores"];
        CMStoreCell *cell = [CMStoreCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDict = arr[indexPath.row];
        return cell;
    }else if (indexPath.section == 1){
        CMHomeImageCell *cell = [CMHomeImageCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setPictureClickblock:^{
            
            int storeId =  [[[LoginUser user] store_id] intValue];
            if (storeId == 0) {
                CMStoreViewController *store = [[CMStoreViewController alloc] init];
                store.title = @"门店";
                CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
                [tabbarController updateTabNavigationRootController:store];
                return;
            }
            
            CMGoodsViewController *goods = [[CMGoodsViewController alloc] init];
            goods.producutTitle = @"新品专栏";
            goods.sourceType = 4;
            goods.storeId = storeId;
            [self.navigationController pushViewController:goods animated:YES];
            
        }];
        cell.dataDict = _dataDict;
        
        return cell;
    }else if (indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.collectionView.frame = CGRectMake(0, 0, __kWindow_Width, (self.flowLayout.itemSize.height + self.flowLayout.minimumLineSpacing)*_lineNum);
        [cell.contentView addSubview:self.collectionView];
        [self.collectionView reloadData];
        
        //        CMMemberCell *cell = [CMMemberCell cellWithTableView:tableView];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [cell reloadCollectionData];
        //        });
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//门店
        NSArray *arr = _dataDict[@"stores"];
        CMStoreGoodsViewController *store = [[CMStoreGoodsViewController alloc] init];
        store.storeId = [arr[indexPath.row][@"id"] longLongValue];
        CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
        [tabbarController updateTabNavigationRootController:store];
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollctionID forIndexPath:indexPath];
    cell.dataDict = self.dataCArray[indexPath.row];
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
    detailVc.goodId = [self.dataCArray[indexPath.item][@"id"] longLongValue];
    detailVc.storeId = storeId;
    [self.navigationController pushViewController:detailVc animated:YES];
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataCArray.count;
}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//
//}

#pragma mark 会员专享 更多
- (void)MoreClick_Member
{
    int storeId =  [[[LoginUser user] store_id] intValue];
    if (storeId == 0) {
        CMStoreViewController *store = [[CMStoreViewController alloc] init];
        store.title = @"门店";
        CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
        [tabbarController updateTabNavigationRootController:store];
        return;
    }
    
    CMGoodsViewController *goods = [[CMGoodsViewController alloc] init];
    goods.producutTitle = @"会员专享";
    goods.sourceType = 6;
    goods.storeId = storeId;
    [self.navigationController pushViewController:goods animated:YES];
    
    
}


#pragma mark 门店 更多
- (void)MoreClick_Store
{
    CMStoreViewController *store = [[CMStoreViewController alloc] init];
    store.title = @"门店";
    CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
    [tabbarController updateTabNavigationRootController:store];
    return;
    
}


@end
