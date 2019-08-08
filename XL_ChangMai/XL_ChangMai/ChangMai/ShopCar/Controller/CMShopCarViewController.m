//
//  CMShopCarViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMShopCarViewController.h"
#import "XLGoodsCollectionViewCell.h"
#import "CMShopCarTopView.h"
#import "ShoppingCarCell.h"
#import "CMSettleViewController.h"
#import "LoginUser.h"
#import "CMStoreViewController.h"
#import "CMTabBarController.h"
#import "CMGoodSetViewController.h"
#define footViewH 50
#define topViewId @"topViewId"
@interface CMShopCarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSInteger _pageSize;
    NSInteger _currentPage;
    NSNumber *_sort;    /** 默认排序 为1*/
    BOOL _isMore;
}

/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;

/** 是否全选 */
@property (nonatomic,assign) BOOL isAllSelect;
/** 全选 */
@property (nonatomic,weak) UIButton *btnAllSelect;

/** 总金额 */
@property (nonatomic,weak) UILabel *labelTotalAmt;

/** 总金额 */
@property (nonatomic,strong) NSNumber * totalPrice;

/** topView */
@property (nonatomic,strong) UIView *topView;

/** 是否刷新 */
@property (nonatomic,assign) BOOL  isRefresh;
/** 瀑布流 */
@property (nonatomic,strong) UICollectionView *collectionView;

/** 数据源 */
@property (nonatomic,strong) NSMutableArray *dataMArray;

@end

static NSString *GoodsCollctionID = @"GoodsCollctionID1";

@implementation CMShopCarViewController
-(UIView *)topView
{
    if (!_topView) {
        
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = __kViewBgColor;
        headView.frame = CGRectMake(0, 0, __kWindow_Width, 364);
        
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopping_cart_icon"]];
        logoImageView.frame = CGRectMake(0, 40, __kWindow_Width, 124);
        logoImageView.contentMode = UIViewContentModeCenter;
        [headView addSubview:logoImageView];
        
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.frame = CGRectMake(0, logoImageView.bottom + 10, __kWindow_Width, 20);
        hintLabel.text = @"购物车还是空着？";
        hintLabel.textColor = [UIColor lightGrayColor];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.font = Font(17);
        [headView addSubview:hintLabel];
        
        
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(60, hintLabel.bottom + 50, __kWindow_Width - 2*60, 50);
        backBtn.layer.cornerRadius = 25;
        backBtn.layer.masksToBounds = YES;
        [backBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(findClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:backBtn];
        
        UILabel *hintLabel1 = [[UILabel alloc] init];
        hintLabel1.frame = CGRectMake(0, backBtn.bottom + 40, __kWindow_Width, 20);
        hintLabel1.text = @"————————— 为您推荐 —————————";
        hintLabel1.textColor = [UIColor lightGrayColor];
        hintLabel1.textAlignment = NSTextAlignmentCenter;
        hintLabel1.font = Font(13);
        [headView addSubview:hintLabel1];
        
        
        headView.height = hintLabel1.bottom + 10;
        
        NSLog(@"----%f",headView.height);
        
        _topView = headView;
    }
    return _topView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWidth = (__kWindow_Width - 10)/2;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth + 80);
        flowLayout.headerReferenceSize = CGSizeMake(__kWindow_Width, 364);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        
        [_collectionView registerClass:[CMShopCarTopView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:topViewId];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"JNGoodsCollectionCell" bundle:nil] forCellWithReuseIdentifier:GoodsCollctionID];
        //        [_collectionView registerClass:[LGLastGoodItemCell class] forCellWithReuseIdentifier:GoodsCollctionID];
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
        /* 开启 自动刷新 */
        //        [self.collectionView.mj_header beginRefreshing];
        
    }
    return _collectionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.isInHome) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[[LoginUser user] access_token] length]) {
        [self performSelectorInBackground:@selector(requestData) withObject:nil];
    }
    
}

- (void)creatUI
{
    
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    self.collectionView = nil;
    self.tableView = nil;
    
    self.dataMArray = _dataDict[@"goods"];
    NSInteger goodCount = [self.dataMArray count];
    
    if (goodCount) {
        
        CGRect collectFrame = CGRectZero;
        
        if (self.isInHome) {
            collectFrame = CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY - __KtabBarHeight);
        }else{
            collectFrame = CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY);
        }
        
        self.collectionView.frame = collectFrame;
        
        [self.view addSubview:self.collectionView];
        
        [self.collectionView reloadData];
        
    }else{
        
        CGRect talbeFrame = CGRectZero;
        if (self.isInHome) {
            talbeFrame = CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY - __KtabBarHeight - footViewH);
        }else{
            talbeFrame = CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY - footViewH);
        }
        [self createTableViewFrame:talbeFrame Style:UITableViewStylePlain];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCarCell" bundle:nil] forCellReuseIdentifier:@"shopping"];
        //        self.tableView.editing = YES;
        
        UIView *tableHeadView = [[UIView alloc] init];
        tableHeadView.frame = CGRectMake(0, 0, __kWindow_Width, 130);
        CGFloat margin = 10;
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stores_pic2"]];
        [imgV sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"store"][@"cover"]] placeholderImage:[UIImage imageNamed:@"stores_pic1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                imgV.image = image;
            }else{
                imgV.image = [UIImage imageNamed:@"stores_pic1"];
            }
        }];
        
        imgV.frame = CGRectMake(margin, margin, tableHeadView.width - 2*margin, tableHeadView.height - 2*margin);
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        [tableHeadView addSubview:imgV];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = CGRectMake(imgV.left, imgV.top,imgV.width, 50);
        titleLabel.backgroundColor = __kColorR_G_B_A(0, 0, 0, 0.7);
        //        titleLabel.text = @"人民广场店\n南京东路";
        titleLabel.text = [NSString stringWithFormat:@"%@\n%@",_dataDict[@"store"][@"title"],_dataDict[@"store"][@"address"]];
        titleLabel.numberOfLines = 2;
        titleLabel.font = Font(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [tableHeadView addSubview:titleLabel];
        
        self.tableView.tableHeaderView = tableHeadView;
        
        CGRect footViewFrame = CGRectZero;
        if (self.isInHome) {
            footViewFrame = CGRectMake(0, __kWindow_Height - __KtabBarHeight - footViewH, __kWindow_Width, footViewH);
        }else{
            footViewFrame = CGRectMake(0, __kWindow_Height - footViewH, __kWindow_Width, footViewH);
        }
        UIView *footerView = [[UIView alloc] initWithFrame:footViewFrame];
        footerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footerView];
        
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 0, footerView.width, __kLine_Width_Height);
        line.backgroundColor = __kLineColor;
        [footerView addSubview:line];
        
        /** 全选 */
        UIButton *allSelectButton = [[UIButton alloc] init];
        allSelectButton.frame = CGRectMake(0, 0, 80, footViewH);
        allSelectButton.tag = 150;
        allSelectButton.selected = self.isAllSelect;
        [allSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        allSelectButton.titleLabel.font = Font(15);
        [allSelectButton setImage:[UIImage imageNamed:@"checkbox_icon"] forState:UIControlStateNormal];
        [allSelectButton setImage:[UIImage imageNamed:@"checkbox_icon_now"] forState:UIControlStateSelected];
        //        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnW - 15, 0, 0)];
        //        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [allSelectButton setTitle:@"   全选" forState:UIControlStateNormal];
        [allSelectButton addTarget:self action:@selector(selectAllItem:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:allSelectButton];
        _btnAllSelect = allSelectButton;
        
        
        /** 删除 */
        UIButton *deleteButton = [[UIButton alloc] init];
        deleteButton.frame = CGRectMake(allSelectButton.right, 0, 40, footViewH);
        deleteButton.selected = self.isAllSelect;
        [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        deleteButton.titleLabel.font = Font(15);
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:deleteButton];
        
        
        CGFloat buttonPayW = 100;
        /**   结算  */
        UIButton *buttonPay = [[UIButton alloc] init];
        buttonPay.frame = CGRectMake(__kWindow_Width - buttonPayW, 0,buttonPayW, footViewH);
        [buttonPay setTitle:@"结算" forState:UIControlStateNormal];
        [buttonPay addTarget:self action:@selector(paymentClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonPay.backgroundColor = __kThemeColor;
        buttonPay.titleLabel.font = Font(20);
        [footerView addSubview:buttonPay];
        
        
        //        UILabel *shouldPay = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(allSelectButton.frame)+ 5, 0, 80, 44) Font:14.0f Text:@"应付金额:￥"];
        CGFloat shouldPayLabelW = 150;
        CGFloat shouldPayLabelH = footViewH/2 - 5;
        UILabel *shouldPay = [[UILabel alloc] init];
        shouldPay.frame = CGRectMake(buttonPay.left - shouldPayLabelW - 10, 5, shouldPayLabelW, shouldPayLabelH);
        shouldPay.textAlignment = NSTextAlignmentRight;
        //        shouldPay.text = @"总计:￥123";
        shouldPay.font = Font(15);
        [footerView addSubview:shouldPay];
        self.labelTotalAmt = shouldPay;
        
        UILabel *descrLabel = [[UILabel alloc] init];
        descrLabel.frame = CGRectMake(shouldPay.left,shouldPay.bottom , shouldPayLabelW, shouldPayLabelH);
        descrLabel.textAlignment = NSTextAlignmentRight;
        descrLabel.text = @"不含运费";
        descrLabel.font = shouldPay.font;
        descrLabel.textColor = [UIColor lightGrayColor];
        [footerView addSubview:descrLabel];
        
    }
}

#pragma mark - 请求 数据
-(void)requestData
{
    LoginUser *user = [LoginUser user];
    int storeId =  [user.store_id intValue];
    if (storeId == 0) {
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MessageAlertView showWithMessage:@"请先选择门店"];
            CMStoreViewController *store = [[CMStoreViewController alloc] init];
            store.title = @"门店";
            CMTabBarController *tabbarController = (CMTabBarController *)self.tabBarController;
            [tabbarController updateTabNavigationRootController:store];
            
        });
        return;
        
    }
    
    NSDictionary *dict = @{@"store_id":@(storeId)};
    NSLog(@"--商品ID:%@",dict);
    
    [[HttpManager shareInstance] get:@"carts" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        _dataDict = (NSDictionary *)response;
        [self setTableData:_dataDict[@"items"] selected:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self creatUI];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
}

- (void)setTableData:(NSArray *)arr selected:(BOOL)select
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dd setObject:@(select) forKey:@"selected"];
        [temp addObject:dd];
    }
    self.dataArray = temp;
}

- (void)deleteButtonClick:(UIButton *)sender
{
    BOOL haveSelect = NO;
    
    if (self.isAllSelect) {
        haveSelect = YES;
    }else
    {
        for (NSMutableDictionary *dd in self.dataArray) {
            if ([dd[@"selected"] boolValue]) {
                haveSelect = YES;
                break ;
            }
        }
    }
    if (!haveSelect) {
        [MessageAlertView showWithMessage:@"请选择要删除的商品"];
        return;
    }
    
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消"];
    RIButtonItem *deleteItem = [RIButtonItem itemWithLabel:@"删除" action:^{
        
        
        NSMutableString *idsStr = [NSMutableString new];
        
        for (NSMutableDictionary *dd in self.dataArray) {
            if ([dd[@"selected"] boolValue]) {
                if (idsStr.length) {
                    [idsStr appendString:@","];
                }
                
                [idsStr appendFormat:@"%@",dd[@"gid"]];
            }
        }
        
        NSDictionary *postDict = @{@"ids":idsStr};
        
        [[HttpManager shareInstance] post:@"delete_cart" parameter:postDict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
            NSLog(@"----返回数据：%@",response);
            [self requestData];
            
        } failure:^(NSURLSessionDataTask *operation, id response) {
            NSLog(@"----返回数据：%@",response);
            
        }];
        
        
    }];
    [ButtonsAlertView showWithMessage:@"确认删除吗？" otherButtonItems:@[cancelItem,deleteItem]];
    
}

#pragma mark 结算
- (void)paymentClick:(UIButton *)sender
{
    BOOL haveSelect = NO;
    
    if (self.isAllSelect) {
        haveSelect = YES;
    }else
    {
        for (NSMutableDictionary *dd in self.dataArray) {
            if ([dd[@"selected"] boolValue]) {
                haveSelect = YES;
                break ;
            }
        }
    }
    if (!haveSelect) {
        [MessageAlertView showWithMessage:@"请选择要结算的商品"];
        return;
    }
    
    CMSettleViewController *settle = [[CMSettleViewController alloc] init];
    NSMutableArray *postArray = [NSMutableArray array];
    
    for (NSMutableDictionary *dd in self.dataArray) {
        if ([dd[@"selected"] boolValue]) {
            [postArray addObject:dd];
        }
    }
    
    settle.goodsArr = postArray;
    long long storeId =  [[[LoginUser user] store_id] longLongValue];
    settle.storeId = storeId;
    settle.storeAddress = _dataDict[@"store"][@"address"];
    [self.navigationController pushViewController:settle animated:YES];
}


- (void)findClick:(UIButton *)sender
{
    self.tabBarController.selectedIndex = 0;
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

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader ){
        
        CMShopCarTopView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:topViewId forIndexPath:indexPath];
        [topView addSubview:self.topView];
        
        return topView;
    }else
        return nil;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollctionID forIndexPath:indexPath];
    cell.dataDict = self.dataMArray[indexPath.item];
    return cell;
}


#pragma mark - 点击图片查看详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int storeId =  [[[LoginUser user] store_id] intValue];
    CMGoodSetViewController *detailVc = [[CMGoodSetViewController alloc]init];
    //    detailVc.itemId = model._id;
    detailVc.goodId = [self.dataMArray[indexPath.item][@"id"] longLongValue];
    detailVc.storeId = storeId;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataMArray.count;
    
}


#pragma mark - 集成上拉 - 下拉刷新

-(void)setUpRefresh
{
    //    _pageSize = @10;
    //    _currentPage = @1;
    //
    //    /** 上拉 */
    //
    //    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //        // 进入刷新状态后会自动调用这个block
    //        _isRefresh = YES;
    //        _isMore = NO;
    //        _currentPage = @1;
    //        [self requestData];
    //        [self.listTableView.mj_header endRefreshing];
    //
    //
    //    }];
    //
    //    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    self.listTableView.mj_header.automaticallyChangeAlpha = YES;
    //
    //    self.listTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        _isMore = YES;
    //        self.isRefresh = YES;
    //        /**
    //         *    如果还有数据 就加载 如果没有退出
    //         */
    //        if ([self.totalCount integerValue] > ([self.currentPage integerValue] - 1)*[self.pageSize integerValue]) {
    //            self.currentPage = @([self.currentPage integerValue] + 1);
    //            [self requestData];
    //        }
    //        else{
    //            [self.listTableView.mj_footer endRefreshing];
    //            return ;
    //        }
    //
    //    }];
    
}


#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return self.dataArray.count;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopping" forIndexPath:indexPath];
    cell.dataDict = self.dataArray[indexPath.row];
    
    
    /**
     *    更新购物车
     */
    
    
    [cell setUpdateShoppingCar:^(NSMutableDictionary *dict) {
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dict];
        
        NSDictionary *postDic = @{@"id":dict[@"id"],
                                  @"num":dict[@"good_number"]};
        
        [[HttpManager shareInstance] get:@"change_num" parameter:postDic withHUDTitle:@"正在加载" success:^(NSURLSessionDataTask *operation, id response) {
            
            NSLog(@"---%@",response);
            
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *operation, id response) {
            
        }];
        
        
    }];
    
    [cell setSelectItem:^(NSMutableDictionary *dict) {
        
        
        
        BOOL isAllSelect = YES;
        
        if (![dict[@"selected"] boolValue]) {
            isAllSelect = NO;
        }else
        {
            for (NSMutableDictionary *dd in self.dataArray) {
                if (![dd[@"selected"] boolValue]) {
                    isAllSelect = NO;
                    break ;
                }
            }
        }
        self.isAllSelect = isAllSelect;
        
        [self calculateTotalPrice];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - 计算总金额
-(void)calculateTotalPrice
{
    
    
    self.totalPrice = @0.00;
    for (NSMutableDictionary *dict in self.dataArray) {
        if ([dict[@"selected"] boolValue]) {
            CGFloat goodPrice = [dict[@"pay_amount"] floatValue]*[dict[@"good_number"] integerValue];
            self.totalPrice = @([self.totalPrice floatValue] + goodPrice);
        }
    }
    
    NSString *titleStr = [NSString stringWithFormat:@"总计：¥%.2f",[self.totalPrice floatValue]];
    NSAttributedString *attrString = [NSString getAttributedText:titleStr SpecialText:[NSString stringWithFormat:@"¥%.2f",[self.totalPrice floatValue]] Font:Font(15) Color:__kThemeColor];
    
    self.labelTotalAmt.attributedText = attrString;
    
    //    [self.tableView reloadData];
}

-(void)setButton:(UIButton *)sender withImage:(NSString *)image
{
    [sender setTitleColor:[UIColor colorWithRed:0.56f green:0.56f blue:0.60f alpha:1.00f] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    sender.titleLabel.font = Font(12);
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

-(void)setIsAllSelect:(BOOL)isAllSelect
{
    _isAllSelect = isAllSelect;
    _btnAllSelect.selected = _isAllSelect;
}



-(void)selectAllItem:(UIButton *)sender
{
    self.isAllSelect = !sender.isSelected;
    sender.selected = self.isAllSelect;
    NSLog(@"%d , %d",self.isAllSelect,_btnAllSelect.isSelected);
    
    for (NSMutableDictionary *dict in self.dataArray) {
        [dict setObject:@(self.isAllSelect) forKey:@"selected"];
    }
    if (self.isAllSelect) {
        self.totalPrice = @0;
        for (NSMutableDictionary *dict in self.dataArray) {
            if ([dict[@"selected"] boolValue]) {
                CGFloat goodPrice = [dict[@"pay_amount"] floatValue]*[dict[@"good_number"] integerValue];
                self.totalPrice = @([self.totalPrice floatValue] + goodPrice);
            }
        }
    }else
        self.totalPrice = @0.00;
    NSString *titleStr = [NSString stringWithFormat:@"总计：¥%.2f",[self.totalPrice floatValue]];
    NSAttributedString *attrString = [NSString getAttributedText:titleStr SpecialText:[NSString stringWithFormat:@"¥%.2f",[self.totalPrice floatValue]] Font:Font(15) Color:__kThemeColor];
    
    self.labelTotalAmt.attributedText = attrString;
    
    [self.tableView reloadData];
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
