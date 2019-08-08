//
//  CMGoodsViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/19.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMGoodsViewController.h"
#import "XLGoodsCollectionViewCell.h"
#import "CMGoodSetViewController.h"
#define topViewH 40
@interface CMGoodsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    NSInteger _currentPage;   //    int类型,分页参数，刚进去为1，要获取后面的从2开始
    NSInteger _sort;          //    int类型,升序还是降序，1 降序， 2 升序，综合只有降序，其他都有两种
    BOOL _isMore;
    
    NSInteger _orderby;        //    int类型,排序类型，1为综合，2为价格，3为销量，4为日期（最新）
    
}
/** 选中的排序方式 */
@property (nonatomic,strong) UIButton  *selectedBtn;

/** 是否刷新 */
@property (nonatomic,assign) BOOL  isRefresh;
/** 瀑布流 */
@property (nonatomic,strong) UICollectionView *collectionView;

/** 数据源 */
@property (nonatomic,strong) NSMutableArray *dataCArray;
@end
static NSString *GoodsCollctionID = @"GoodsCollctionID1";
@implementation CMGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /** 初始化默认值 */
    _currentPage = 1;
    _sort = 1;   //默认 1 降序
    _orderby = 1;  //默认 1 综合
    _isRefresh = YES;
    
    _dataCArray = [NSMutableArray array];
    
    [self createUI];
    
}





- (void)createUI
{
    NSArray *titleArr = @[@"综合",@"销量",@"价格",@"新品"];
    
    CGFloat btnW = __kWindow_Width/titleArr.count;
    
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, __KViewY + 2, __kWindow_Width,topViewH);
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, topView.height)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        if (![titleArr[i] isEqualToString:@"综合"]) {
            [btn setImage:[UIImage imageNamed:@"sort_arrow0"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnW - 35, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
            
        }else{
            //默认综合排序
            btn.selected = YES;
            _selectedBtn = btn;
        }
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:__kThemeColor forState:UIControlStateSelected];
        btn.titleLabel.font = Font(14);
        [btn addTarget:self action:@selector(changeSortMode:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:btn];
        
    }
    
    if (titleArr.count > 1) {
        for (int i = 0; i < titleArr.count - 1; i ++) {
            UIView *line = [self createDefaultStyleLineFrame:CGRectMake(btnW*(i+1), 5, __kLine_Width_Height, topView.height - 2*5)];
            line.tag = 100 + i;
            [topView addSubview:line];
        }
    }
    
    
    [self.view addSubview:topView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = (__kWindow_Width - 10)/2;
    flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth + 80);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    CGFloat collectionY = topView.bottom;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, collectionY, __kWindow_Width, __kWindow_Height - collectionY) collectionViewLayout:flowLayout];
    
    _collectionView.backgroundColor = __kViewBgColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"JNGoodsCollectionCell" bundle:nil] forCellWithReuseIdentifier:GoodsCollctionID];
    //        [_collectionView registerClass:[LGLastGoodItemCell class] forCellWithReuseIdentifier:GoodsCollctionID];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isRefresh = YES;
        _currentPage = 1;;
        [self requestData];
        [_collectionView.mj_header endRefreshing];
    }];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.isRefresh = NO;
        _currentPage ++;
        [self requestData];
    }];
    
    /* 开启 自动刷新 */
    [self.collectionView.mj_header beginRefreshing];
    
    [self.view addSubview:self.collectionView];
}




- (void)changeSortMode:(UIButton *)sender
{
    sender.selected = YES;
    if (sender != _selectedBtn) {
        _selectedBtn.selected = NO;
        _selectedBtn = sender;
    }
    
    /*
     NSInteger _sort;          //    int类型,升序还是降序，1 降序， 2 升序，综合只有降序，其他都有两种
     
     NSInteger _orderby;        //    int类型,排序类型，1为综合，2为价格，3为销量，4为日期（最新）
     */
    if ([sender.titleLabel.text isEqualToString:@"综合"]) {
        _orderby = 1;
        _sort = 1;
    }else{
        if ([sender.titleLabel.text isEqualToString:@"价格"]) {
            _orderby = 2;
        }else if ([sender.titleLabel.text isEqualToString:@"销量"]){
            _orderby = 3;
        }else if ([sender.titleLabel.text isEqualToString:@"新品"]){
            _orderby = 4;
        }
        
        //点击相同的按钮，改变排序规则，升序，降序
        if (sender == _selectedBtn) {
            if (_sort == 1) {
                _sort = 2;
                [sender setImage:[UIImage imageNamed:@"sort_arrow2"] forState:UIControlStateSelected];
            }else if (_sort == 2){
                _sort = 1;
                [sender setImage:[UIImage imageNamed:@"sort_arrow1"] forState:UIControlStateSelected];
            }
        }
        
        
    }
    
    _isRefresh = YES;
    _currentPage = 1;
    
    [self requestData];
}

#pragma mark - 请求 数据
-(void)requestData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{@"orderby":@(_orderby),
                                   @"order":@(_sort),
                                   @"page":@(_currentPage)
                                   }];
    /*
     1.搜索关键词，或者点击热搜关键词，跳转过来
     2.点击小分类，跳转过来
     3.爆款
     4.新品
     5.热销
     6.会员专享
     */
    if (self.sourceType == 1){
        self.title = self.searchKeyword;
        [dict setObject:self.searchKeyword?self.searchKeyword:@"" forKey:@"key"];
    }else if (self.sourceType == 2){
        self.title = self.producutTitle;
        [dict setObject:@(self.subcate) forKey:@"subcate"];
    }else if (self.sourceType == 3){
        self.title = @"爆款";
        [dict setObject:@1 forKey:@"is_best"];
    }else if (self.sourceType == 4){
        self.title = @"新品";
        [dict setObject:@1 forKey:@"is_new"];
    }else if (self.sourceType == 5){
        self.title = @"热销";
        [dict setObject:@1 forKey:@"is_hot"];
    }else if (self.sourceType == 6){
        self.title = @"会员专享";
        [dict setObject:@1 forKey:@"is_member"];
    }
    
    
    
    
    
    [[HttpManager shareInstance] get:@"goods" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        if ([response[@"items"] count] == 0) {
            _currentPage--;
        }
        
        if (_isRefresh) {
            [self.dataCArray removeAllObjects];
            [self.dataCArray addObjectsFromArray:response[@"items"]];
            [_collectionView.mj_header endRefreshing];
        }else
        {
            [self.dataCArray addObjectsFromArray:response[@"items"]];
            [_collectionView.mj_footer endRefreshing];
            [_collectionView.mj_header endRefreshing];
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        if (!_isRefresh) {
            _currentPage --;
        }
    }];
    
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollctionID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.dataDict = self.dataCArray[indexPath.item];
    return cell;
}
#pragma mark - 点击图片查看详情
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    JNGoodsModel *model = self.dataMArray[indexPath.row];
    CMGoodSetViewController *detailVc = [[CMGoodSetViewController alloc]init];
    //    detailVc.itemId = model._id;
    detailVc.goodId = [self.dataCArray[indexPath.item][@"id"] longLongValue];
    detailVc.storeId = self.storeId;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataCArray.count;
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
