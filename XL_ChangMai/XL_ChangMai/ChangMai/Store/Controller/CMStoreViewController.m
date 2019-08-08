//
//  CMStoreViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMStoreViewController.h"
#import "CMStoreCell.h"
#import "CMStoreGoodsViewController.h"
#import "CMTabBarController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "LoginUser.h"
@interface CMStoreViewController ()<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    NSString *_locatedAddress;
    CGFloat lat;
    CGFloat lng;
}
/** 当前位置 */
@property (nonatomic,strong) UILabel *currentAddress;
/** topView */
@property (nonatomic,strong) UIView *topView;
/** 输入的地址 */
@property (nonatomic,strong) UITextField *inputAddressField;
/** 定位 */
@property (nonatomic,strong) UIButton *locationBtn;

@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)BMKGeoCodeSearch *geocodesearch;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end

@implementation CMStoreViewController

- (BMKLocationService *)locService
{
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    return _locService;
    
}

- (BMKGeoCodeSearch *)geocodesearch
{
    if (!_geocodesearch) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
    }
    return _geocodesearch;
    
}

-(UIView *)topView
{
    if (!_topView) {
        
        UIView *headView = [[UIView alloc] init];
        headView.frame = CGRectMake(0, 0, __kWindow_Width, 364);
        headView.backgroundColor = [UIColor whiteColor];
        _locationBtn = [self createDefaultStyleButtonFrame:CGRectMake(__kWindow_Width - 100 - __kScreenMargin, __kScreenMargin, 100, __kTextField_Height) cornerRadius:20 title:@"   定位"];
        _locationBtn.backgroundColor = __kThemeColor;
        [_locationBtn setImage:[UIImage imageNamed:@"location_icon_white"] forState:UIControlStateNormal];
        [_locationBtn addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:_locationBtn];
        
        _inputAddressField = [self createDefaultStyleTextFieldFrame:CGRectMake(__kScreenMargin, __kScreenMargin, _locationBtn.left - 2*__kScreenMargin, __kTextField_Height)];
        _inputAddressField.placeholder = @"请输入地址重新定位";
        [headView addSubview:_inputAddressField];
        
        UIView *line = [self createDefaultStyleLineFrame:CGRectMake(0, _inputAddressField.bottom + 10, __kWindow_Width, __kLine_Width_Height)];
        [headView addSubview:line];
        
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.frame = CGRectMake(__kScreenMargin, line.bottom + 5, __kWindow_Width, 20);
        hintLabel.text = @"当前位置：";
        hintLabel.textColor = [UIColor lightGrayColor];
        hintLabel.font = Font(13);
        [headView addSubview:hintLabel];
        
        UILabel *hintLabel1 = [[UILabel alloc] init];
        hintLabel1.frame = CGRectMake(__kScreenMargin, hintLabel.bottom, __kWindow_Width, 20);
        //        hintLabel1.text = @"————————— 为您推荐 —————————";
        //          hintLabel1.text = @"上海浦东新区东方路";
        hintLabel1.textColor = [UIColor blackColor];
        hintLabel1.font = Font(13);
        [headView addSubview:hintLabel1];
        self.currentAddress = hintLabel1;
        
        
        UILabel *hintLabel2 = [[UILabel alloc] init];
        hintLabel2.frame = CGRectMake(0, hintLabel1.bottom + 5, __kWindow_Width, 45);
        hintLabel2.backgroundColor = __kViewBgColor;
        hintLabel2.text = @"————————— 您附近的门店 —————————";
        hintLabel2.textColor = [UIColor lightGrayColor];
        hintLabel2.textAlignment = NSTextAlignmentCenter;
        hintLabel2.font = Font(13);
        [headView addSubview:hintLabel2];
        
        UIImageView *headImageV = [[UIImageView alloc] init];
        headImageV.image = [UIImage imageNamed:@"home_stores_top"];
        headImageV.frame = CGRectMake(0, hintLabel2.bottom - 5, __kWindow_Width, 13);
        headImageV.contentMode = UIViewContentModeScaleToFill;
        [headView addSubview:headImageV];
        
        UILabel *hintLabel3 = [[UILabel alloc] init];
        hintLabel3.frame = CGRectMake(__kScreenMargin, headImageV.bottom, __kWindow_Width, 30);
        hintLabel3.backgroundColor = [UIColor whiteColor];
        hintLabel3.text = @"请选择进入门店购物";
        hintLabel3.textColor = [UIColor blackColor];
        hintLabel3.font = Font(17);
        [headView addSubview:hintLabel3];
        
        headView.height = hintLabel3.bottom + 10;
        
        NSLog(@"----%f",headView.height);
        
        _topView = headView;
    }
    return _topView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"门店";
    [self creatUI];
    
    [self.locService startUserLocationService];
}

- (void)creatUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableViewFrame:CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY - __KtabBarHeight) Style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverCell" bundle:nil] forCellReuseIdentifier:@"discoverCell"];
    
    self.tableView.tableHeaderView = self.topView;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.frame = CGRectMake(0, 0, __kWindow_Width, 30);
    
    UIImageView *bottomImage = [[UIImageView alloc] init];
    bottomImage.backgroundColor = __kViewBgColor;
    bottomImage.image = [UIImage imageNamed:@"home_stores_bottom"];
    bottomImage.frame = CGRectMake(0, 0, __kWindow_Width, 13);
    bottomImage.contentMode = UIViewContentModeScaleToFill;
    [bottomView addSubview:bottomImage];
    self.tableView.tableFooterView = bottomView;
    
}


- (void)location:(UIButton *)sender
{
    
}



- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.coordinate = userLocation.location.coordinate;
    [self reverseGeoCode];
    [self.locService stopUserLocationService];
    
    
    lat = userLocation.location.coordinate.latitude;
    lng = userLocation.location.coordinate.longitude;
    
    [self requestData];
    
}



- (void)reverseGeoCode
{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    //    CLLocationCoordinate2D coord = (CLLocationCoordinate2D){31.195028,121.559685};
    reverseGeocodeSearchOption.reverseGeoPoint = self.coordinate;
    [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    
    if (error == 0) {
        _locatedAddress = result.address;
        _currentAddress.text = _locatedAddress;
        NSLog(@"%@",result);
        
    }
    
    
    
}



#pragma mark - 请求 数据
-(void)requestData
{
    NSDictionary *dict = @{@"lng":@(lng),
                           @"lat":@(lat)};
    NSLog(@"---经纬度：%@",dict);
    
    [[HttpManager shareInstance] get:@"stores" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        self.dataArray = response[@"stores"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
}


#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    //    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CMStoreCell cellHeight];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMStoreCell *cell = [CMStoreCell cellWithTableView:tableView];
    cell.dataDict = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *storeId = [NSNumber numberWithLongLong:[self.dataArray[indexPath.row][@"id"] longLongValue]];
    LoginUser *user = [LoginUser user];
    user.store_id = storeId;
    user.store_Address = self.dataArray[indexPath.row][@"address"];
    NSLog(@"%@",[self.dataArray[indexPath.row][@"id"] class]);
    CMStoreGoodsViewController *goodsVc = [[CMStoreGoodsViewController alloc]init];
    goodsVc.storeId = [self.dataArray[indexPath.row][@"id"] longLongValue];
    [self.navigationController setViewControllers:@[goodsVc]];
    
    //
    
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
