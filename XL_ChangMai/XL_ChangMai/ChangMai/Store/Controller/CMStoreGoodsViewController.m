//
//  CMStoreGoodsViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMStoreGoodsViewController.h"
#import "JNAskRecommendCell.h"
#import "CMGoodsViewController.h"
#import "CMSearchGoodViewController.h"
#import "CMTabBarController.h"
#import "CMStoreViewController.h"
static NSString *const brandcategoryCellID = @"JNAskRecommendCellID";
#define tableViewW 100
#define cellH 49
@interface CMStoreGoodsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**  数据源 */
@property (nonatomic,strong) NSDictionary *dataDict;

//@property (nonatomic,strong) UIImageView *headImageV;
//
//@property (nonatomic,strong) UILabel *titleLabel;
//
//@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *collectionDataArray;
//第一级分类的选择索引，即左侧，包袋，服装，首饰等分类的选择
@property(nonatomic,assign)NSInteger firstCategorySelectIndex;
@end

@implementation CMStoreGoodsViewController

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
    [self requestData];
}



- (void)createUI
{
    
    UIView *statusView = [[UIView alloc] init];
    statusView.backgroundColor = [UIColor whiteColor];
    statusView.frame = CGRectMake(0, 0, __kWindow_Width, 20);
    [self.view addSubview:statusView];
    
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 20, __kWindow_Width, 0);
    
    
    
    
    CGFloat searchViewH = 50;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width, searchViewH)];
    [searchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchGoods)]];
    searchView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:searchView];
    
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
    
    UIImageView *headImageV = [[UIImageView alloc] init];
    //    headImageV.image = [UIImage imageNamed:@"stores_pic2"];
    [headImageV sd_setImageWithURL:[NSURL URLWithString:_dataDict[@"store"][@"cover"]] placeholderImage:[UIImage imageNamed:@"stores_pic1"]];
    
    headImageV.userInteractionEnabled = YES;
    headImageV.frame = CGRectMake(0, searchView.bottom, __kWindow_Width, 130);
    headImageV.contentMode = UIViewContentModeScaleToFill;
    [headView addSubview:headImageV];
    
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(0, headImageV.bottom, __kWindow_Width, 30);
    hintLabel.backgroundColor = [UIColor whiteColor];
    //    hintLabel.text = @"    人民广场店";
    hintLabel.text = [NSString stringWithFormat:@"    %@",_dataDict[@"store"][@"title"]];
    hintLabel.textColor = [UIColor blackColor];
    hintLabel.font = Font(17);
    [headView addSubview:hintLabel];
    
    UILabel *hintLabel1 = [[UILabel alloc] init];
    hintLabel1.frame = CGRectMake(0, hintLabel.bottom, __kWindow_Width, 20);
    hintLabel1.backgroundColor = [UIColor whiteColor];
    //    hintLabel1.text = @"    南京东路123号";
    hintLabel1.text = [NSString stringWithFormat:@"    %@",_dataDict[@"store"][@"address"]];
    hintLabel1.textColor = [UIColor lightGrayColor];
    hintLabel1.font = Font(15);
    [headView addSubview:hintLabel1];
    
    
    NSArray *arr = _dataDict[@"discount"];
    if (arr.count) {
        
        CGFloat labelY = hintLabel1.bottom;
        CGFloat labelH = 30;
        CGFloat labelX = 20;
        
        for (NSDictionary *dict in arr) {
            UILabel *leftlabel = [[UILabel alloc] init];
            leftlabel.frame = CGRectMake(labelX, labelY + 5, 20, labelH - 2*5);
            leftlabel.backgroundColor = __kThemeColor;
            leftlabel.text = dict[@"str"];
            leftlabel.textColor = [UIColor whiteColor];
            leftlabel.textAlignment = NSTextAlignmentCenter;
            leftlabel.font = Font(15);
            leftlabel.layer.cornerRadius = 3;
            leftlabel.layer.masksToBounds = YES;
            [headView addSubview:leftlabel];
            
            UILabel *rightlabel = [[UILabel alloc] init];
            rightlabel.frame = CGRectMake(leftlabel.right, labelY, __kWindow_Width - leftlabel.right, labelH);
            rightlabel.backgroundColor = [UIColor whiteColor];
            rightlabel.text = dict[@"title"];
            rightlabel.textColor = [UIColor whiteColor];
            rightlabel.font = Font(15);
            [headView addSubview:rightlabel];
            
            labelY += labelH;
        }
        
        headView.height = labelY;
    }else{
        headView.height = hintLabel1.bottom + 5;
    }
    
    
    [self.view addSubview:headView];
    
    
    CGFloat contentY = headView.bottom + 4;
    
    [self createTableViewFrame:CGRectMake(0,contentY , tableViewW, __kWindow_Height - contentY) Style:UITableViewStylePlain];
    self.tableView.bounces = YES;
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    /** 设置滚动方向 */
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat headW = myWith6(72);
    flowLayout.itemSize = CGSizeMake(headW, headW + 5 + 30);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 22;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 22, 10, 22);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(tableViewW, contentY , __kWindow_Width - tableViewW, __kWindow_Height - contentY) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[JNAskRecommendCell class] forCellWithReuseIdentifier:brandcategoryCellID];
    
    [self.view addSubview:self.collectionView];
    
    
    
}




#pragma mark - 请求 数据
-(void)requestData
{
    NSDictionary *dict = @{@"id":@(self.storeId)};
    
    [[HttpManager shareInstance] get:@"store" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        _dataDict = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dataArray = _dataDict[@"topcates"];
            
            [self createUI];
            
            [self.tableView reloadData];
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            _collectionDataArray = self.dataArray[_firstCategorySelectIndex][@"sublist"];
            
            [self.collectionView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
}




#pragma mark tableView delegate And datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = Font(15);
    cell.textLabel.textColor = __kcolorText_Black;
    cell.textLabel.highlightedTextColor = __kThemeColor;
    //    UIView *selectBgView = [[UIView alloc] init];
    //    selectBgView.backgroundColor = __kThemeColor;
    //    selectBgView.frame = CGRectMake(0, 0,tableViewW, cellH);
    //    cell.selectedBackgroundView = selectBgView;
    
    //    JNCategoryModel *model = _dataArray[indexPath.row];
    //    cell.textLabel.text = model.name;
    //    cell.textLabel.text = @"防尿用品";
    cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = __kLineColor;
    line.frame = CGRectMake(0, cellH - __kLine_Width_Height, tableViewW, __kLine_Width_Height);
    [cell.contentView addSubview:line];
    return cell;
    
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _firstCategorySelectIndex = indexPath.row;
    _collectionDataArray = self.dataArray[_firstCategorySelectIndex][@"sublist"];
    [self.collectionView reloadData];
}





#pragma mark - collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionDataArray.count;
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JNAskRecommendCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:brandcategoryCellID forIndexPath:indexPath];
    categoryCell.dataDict = self.collectionDataArray[indexPath.item];
    //    JNCategoryDetailModel *detailModel = _collectionDataModel.categoryList[indexPath.section];
    //    categoryCell.thirdCategoryDetailModel = detailModel.thirdCategoryList[indexPath.item];
    return categoryCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (_recommendCarNum == 10) {
    //        [MessageAlertView showWithMessage:@"最多选择10个分类"];
    //        return;
    //    }
    //    JNCategoryDetailModel *detailModel = _collectionDataModel.categoryList[indexPath.section];
    //    JNThirdCategoryDetailModel *thirdModel = detailModel.thirdCategoryList[indexPath.item];
    //    [self addRecommendCarWithFirstCategoryId:_collectionDataModel._id  secondCategoryId:detailModel._id  thirdCategoryId:thirdModel._id];
    CMGoodsViewController *goods = [[CMGoodsViewController alloc] init];
    goods.producutTitle = self.collectionDataArray[indexPath.item][@"name"];
    goods.sourceType = 2;
    goods.storeId = self.storeId;
    goods.subcate = [self.collectionDataArray[indexPath.item][@"id"] longLongValue];
    [self.navigationController pushViewController:goods animated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
