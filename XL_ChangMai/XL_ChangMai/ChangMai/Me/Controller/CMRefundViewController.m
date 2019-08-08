//
//  CMRefundViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMRefundViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "UETextView.h"
#import "TZImagePickerController.h"
#define leftX 20
#define textFH 40
#define titleH  40
#define cellMargin 10
#define productH 90
#define selectBtnW 30
#define margin 10

#define maxImageCount 3

#define imageCellNum 3

#define imageLeftX 30
#define imageH 80
#define imageMargin 15
#define imageW 80
@interface CMRefundViewController ()<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UIPickerViewDataSource,UIPickerViewDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    CGFloat lat;
    CGFloat lng;
    NSMutableArray *_selectedPhotos;
}
@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)BMKGeoCodeSearch *geocodesearch;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic,strong) UIToolbar *inputAccessoryVRefundStore;
/** 退货门店选择器 */
@property (nonatomic,strong) UIPickerView *refundStorePickView;

@property (nonatomic,strong) UIToolbar *inputAccessoryVRefundWay;
/** 退货方式选择器 */
@property (nonatomic,strong) UIPickerView *refundWayPickView;
/** 退货方式 */
@property (nonatomic,strong) UITextField *refundWay;
/** 退货门店 */
@property (nonatomic,strong) UITextField *refundStore;
/** 退货理由 */
@property (nonatomic,strong) UETextView *refundDescr;
@property (nonatomic,strong) NSArray *refundWayArr;
@property (nonatomic,strong) NSArray *refundStoreArr;
@property (nonatomic,strong) NSMutableArray *goodsArr;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSString *selectStoreId;
@property (nonatomic,assign) BOOL hideRefundStore;
@end

@implementation CMRefundViewController

-(UIToolbar *)inputAccessoryVRefundStore
{
    if(!_inputAccessoryVRefundStore)
    {
        CGFloat toolBarH = 41;
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width, toolBarH)];
        toolBar.tintColor = [UIColor whiteColor];
        toolBar.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *cancelItem = [[UIButton alloc] init];
        cancelItem.backgroundColor = [UIColor clearColor];
        cancelItem.frame = CGRectMake(0, 0, 50, toolBarH);
        [cancelItem setTitle:@"取消" forState:UIControlStateNormal];
        [cancelItem addTarget:self action:@selector(cancelSelectCategory) forControlEvents:UIControlEventTouchUpInside];
        [cancelItem setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
        cancelItem.titleLabel.font = Font(18);
        UIBarButtonItem *left1 = [[UIBarButtonItem alloc]initWithCustomView:cancelItem];
        
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        item.tintColor = [UIColor whiteColor];
        
        UIButton *done = [[UIButton alloc] init];
        done.frame = CGRectMake(0, 0, 50, toolBarH);
        done.backgroundColor = [UIColor clearColor];
        [done setTitle:@"完成" forState:UIControlStateNormal];
        [done addTarget:self action:@selector(didSelectCategory) forControlEvents:UIControlEventTouchUpInside];
        [done setTitleColor:[UIColor colorWithHexString:@"4b4bc8"] forState:UIControlStateNormal];
        done.titleLabel.font = Font(18);
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:done];
        toolBar.items = @[left1,item,right];
        
        _inputAccessoryVRefundStore = toolBar;
        return _inputAccessoryVRefundStore;
    }
    return _inputAccessoryVRefundStore;
}



-(UIPickerView *)refundStorePickView
{
    if(!_refundStorePickView)
    {
        _refundStorePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width , 199)];
        _refundStorePickView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        _refundStorePickView.delegate = self;
        _refundStorePickView.dataSource = self;
        return _refundStorePickView;
    }
    return _refundStorePickView;
}



-(UIToolbar *)inputAccessoryVRefundWay
{
    if(!_inputAccessoryVRefundWay)
    {
        CGFloat toolBarH = 41;
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width, toolBarH)];
        toolBar.tintColor = [UIColor whiteColor];
        toolBar.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *cancelItem = [[UIButton alloc] init];
        cancelItem.backgroundColor = [UIColor clearColor];
        cancelItem.frame = CGRectMake(0, 0, 50, toolBarH);
        [cancelItem setTitle:@"取消" forState:UIControlStateNormal];
        [cancelItem addTarget:self action:@selector(cancelSelectCategory) forControlEvents:UIControlEventTouchUpInside];
        [cancelItem setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
        cancelItem.titleLabel.font = Font(18);
        UIBarButtonItem *left1 = [[UIBarButtonItem alloc]initWithCustomView:cancelItem];
        
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        item.tintColor = [UIColor whiteColor];
        
        UIButton *done = [[UIButton alloc] init];
        done.frame = CGRectMake(0, 0, 50, toolBarH);
        done.backgroundColor = [UIColor clearColor];
        [done setTitle:@"完成" forState:UIControlStateNormal];
        [done addTarget:self action:@selector(didSelectCategory) forControlEvents:UIControlEventTouchUpInside];
        [done setTitleColor:[UIColor colorWithHexString:@"4b4bc8"] forState:UIControlStateNormal];
        done.titleLabel.font = Font(18);
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:done];
        toolBar.items = @[left1,item,right];
        
        _inputAccessoryVRefundWay = toolBar;
        return _inputAccessoryVRefundWay;
    }
    return _inputAccessoryVRefundWay;
}



-(UIPickerView *)refundWayPickView
{
    if(!_refundWayPickView)
    {
        _refundWayPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width , 199)];
        _refundWayPickView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        _refundWayPickView.delegate = self;
        _refundWayPickView.dataSource = self;
        return _refundWayPickView;
    }
    return _refundWayPickView;
}


-(UITextField *)refundWay
{
    if (!_refundWay) {
        UITextField *textF = [[UITextField alloc]  init];
        textF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, __kTextField_Height)];
        textF.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *rightV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
        rightV.frame = CGRectMake(0, 0, 30, textFH);
        rightV.contentMode = UIViewContentModeCenter;
        textF.rightView = rightV;
        textF.rightViewMode = UITextFieldViewModeAlways;
        textF.backgroundColor = __kViewBgColor;
        textF.font = Font(15);
        textF.layer.cornerRadius = 5;
        textF.layer.masksToBounds = YES;
        textF.frame = CGRectMake(leftX, 0, __kWindow_Width - 2*leftX,textFH);
        textF.placeholder = @"请选择退货方式";
        textF.inputView = self.refundWayPickView;
        textF.inputAccessoryView = self.inputAccessoryVRefundWay;
        self.refundWay = textF;
    }return _refundWay;
}



-(UITextField *)refundStore
{
    if (!_refundStore) {
        UITextField *textF = [[UITextField alloc]  init];
        textF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textFH)];
        textF.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *rightV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
        rightV.frame = CGRectMake(0, 0, 30, textFH);
        rightV.contentMode = UIViewContentModeCenter;
        textF.rightView = rightV;
        textF.rightViewMode = UITextFieldViewModeAlways;
        textF.backgroundColor = __kViewBgColor;
        textF.font = Font(15);
        textF.layer.cornerRadius = 5;
        textF.layer.masksToBounds = YES;
        textF.frame = CGRectMake(leftX, 0, __kWindow_Width - 2*leftX,textFH);
        textF.placeholder = @"请选择退货门店";
        textF.inputView = self.refundStorePickView;
        textF.inputAccessoryView = self.inputAccessoryVRefundStore;
        self.refundStore = textF;
    }return _refundStore;
    
}


-(UETextView *)refundDescr
{
    if (!_refundDescr) {
        
        _refundDescr = [[UETextView alloc] init];
        _refundDescr.frame = CGRectMake(leftX, 0, __kWindow_Width - 2*leftX, 70);
        _refundDescr.layer.cornerRadius = 5;
        _refundDescr.layer.masksToBounds = YES;
        _refundDescr.font = Font(15);
        _refundDescr.placeholder = @"请输入退货理由";
        _refundDescr.backgroundColor = __kViewBgColor;
        
    }
    return _refundDescr;
    
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type ==1) {
        self.title = @"申请退款";
    }else if (self.type ==2){
        self.title = @"申请退货";
    }
    _selectedPhotos = [NSMutableArray array];
    
    _refundWayArr = @[@"门店退货",@"快递退货"];
    
    [self.locService startUserLocationService];
    [self createUI];
}


- (void)createUI
{
    
    [self createTableViewFrame:CGRectMake(0, __KViewY, __kWindow_Width, __kWindow_Height - __KViewY - 70) Style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat btnMargin = 60;
    CGFloat cornerRadius = 25;
    UIButton *_loginBtn = [[UIButton alloc] init];
    if (self.type ==1) {
        [_loginBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    }else if (self.type ==2){
        [_loginBtn setTitle:@"申请退货" forState:UIControlStateNormal];
    }
    
    _loginBtn.frame = CGRectMake(btnMargin, __kWindow_Height - 60, __kWindow_Width - 2*btnMargin, 50);
    _loginBtn.layer.cornerRadius = cornerRadius;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    
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
        //        _locatedAddress = result.address;
        NSLog(@"%@",result);
        
    }
    
}




#pragma mark - 请求 数据
-(void)requestData
{
    
    NSDictionary *dict = @{@"id":self.soNo,
                           @"type":@(self.type),
                           @"lng":@(lng),
                           @"lat":@(lat)};
    [[HttpManager shareInstance] get:@"add_refund" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        //        {
        //            address = "\U82cf\U5dde\U5de5\U4e1a\U56ed\U533a\U73b2\U73d1\U8857\U5c1a\U73b2\U73d1\U4f1a\U6240\U5bf9\U976246\U5e62\U4e00\U697c ";
        //            cover = "http://changmai.zhixuandajiankang.com/files";
        //            id = 8;
        //            title = "\U57ce\U5e02\U4e4b\U95f4-\U73b2\U73d1\U5e97";
        //        }
        
        
        _dataDict = (NSDictionary *)response;
        self.refundStoreArr = _dataDict[@"stores"];
        _goodsArr = [NSMutableArray array];
        NSArray *arr = _dataDict[@"good"];
        for (NSDictionary *dict in arr) {
            NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:dict];
            [dd setObject:@NO forKey:@"select"];
            [_goodsArr addObject:dd];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:response[@"msg"]];
        });
    }];
    
    
    
}



#pragma mark - 交互方法
/**
 *    隐藏pickerView
 */
-(void)didSelectCategory
{
    
    if ([self.refundWay isFirstResponder]) {
        if ([self.refundWay.text isEqualToString:@"门店退货"]) {
            _hideRefundStore = NO;
        }else{
            _selectStoreId = @"";
            _hideRefundStore = YES;
        }
        [self.tableView reloadData];
    }
    
    [self.refundStore resignFirstResponder];
    [self.refundWay resignFirstResponder];
    
    
}


- (void)cancelSelectCategory
{
    [self.refundWay resignFirstResponder];
    [self.refundStore resignFirstResponder];
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.refundStorePickView) {
        _selectStoreId = [NSString stringWithFormat:@"%@",self.refundStoreArr[row][@"id"]];
        self.refundStore.text = self.refundStoreArr[row][@"title"];
        
    }else{
        self.refundWay.text = self.refundWayArr[row];
    }
    
    
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView == self.refundWayPickView) {
        return  _refundWayArr[row];
    }
    return self.refundStoreArr[row][@"title"];
    
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 36;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.refundWayPickView) {
        return  _refundWayArr.count;
    }
    return _refundStoreArr.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.refundWayPickView) {
        return  1;
    }
    return 1;
}







#pragma mark tableView delegate And datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        NSArray *goodArr = _dataDict[@"good"];
        return goodArr.count;
    }else if(section == 0){
        if (self.type ==1) {
            return 0;
        }else if (self.type ==2){
            return 1;
        }
        return 0;
    }else if(section == 1){
        if (self.type ==1) {
            return 0;
        }else if (self.type ==2){
            if (_hideRefundStore) {
                return 0;
            }
            return 1;
        }
        return 0;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return textFH + cellMargin;
    }else if (indexPath.section == 1){
        return textFH + cellMargin;
    }else if (indexPath.section == 2){
        NSArray *goodArr = _dataDict[@"good"];
        return goodArr.count*productH + cellMargin;
    }else if (indexPath.section == 3){
        return imageW + cellMargin;
    }else if (indexPath.section == 4){
        return cellMargin + 70;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if (self.type ==1) {
            return 0;
        }else if (self.type ==2){
            return titleH;
        }
        return 0;
    }else if(section == 1){
        if (self.type ==1) {
            return 0;
        }else if (self.type ==2){
            if (_hideRefundStore) {
                return 0;
            }
            return titleH;
        }
        return 0;
    }
    return titleH;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section == 0){
        if (self.type ==1) {
            return [[UIView alloc] init];
        }
    }else if(section == 1){
        if (self.type ==1) {
            return [[UIView alloc] init];
        }else if (self.type ==2){
            if (_hideRefundStore) {
                return [[UIView alloc] init];
            }
        }
    }
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    headView.frame = CGRectMake(0, 0, __kWindow_Width, titleH);
    
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(0, 0, __kWindow_Width, titleH);
    hintLabel.backgroundColor = [UIColor whiteColor];
    hintLabel.textColor = [UIColor blackColor];
    hintLabel.font = Font(17);
    [headView addSubview:hintLabel];
    
    UIView *line = [self createDefaultStyleLineFrame:CGRectMake(0, 0, __kWindow_Width, __kLine_Width_Height)];
    [headView addSubview:line];
    
    if (section == 0) {
        hintLabel.text = @"    退货选择";
    }else if (section == 1){
        hintLabel.text = @"    选择退货门店";
    }else if (section == 2){
        
        if (self.type ==1) {
            hintLabel.text = @"    选择退款商品";
        }else if (self.type ==2){
            hintLabel.text = @"    选择退货商品";
        }
    }else if (section == 3){
        hintLabel.text = @"    上传图片";
    }else if (section == 4){
        if (self.type ==1) {
            hintLabel.text = @"    退款理由";
        }else if (self.type ==2){
            hintLabel.text = @"    退货理由";
        }
        
    }
    
    return headView;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.refundWay];
        return cell;
    }else if (indexPath.section == 1){
        [cell.contentView addSubview:self.refundStore];
        return cell;
    }else if (indexPath.section == 2){
        
        
        
        
        for (int i = 0; i < _goodsArr.count; i ++) {
            NSDictionary *prodcutDict = _goodsArr[i];
            
            UIView *productCell = [[UIView alloc] init];
            
            UIButton *selectBtn = [[UIButton alloc] init];
            [selectBtn setImage:[UIImage imageNamed:@"checkbox_icon"] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"checkbox_icon_now"] forState:UIControlStateSelected];
            selectBtn.imageView.contentMode = UIViewContentModeCenter;
            selectBtn.tag = i + 100;
            [selectBtn addTarget:self action:@selector(selectGood:) forControlEvents:UIControlEventTouchUpInside];
            if ([prodcutDict[@"select"] boolValue]) {
                selectBtn.selected = YES;
            }
            
            UIImageView *image = [[UIImageView alloc] init];
            image.contentMode = UIViewContentModeScaleAspectFit;
            [image sd_setImageWithURL:[NSURL URLWithString:prodcutDict[@"cover"]] placeholderImage:[UIImage imageNamed:@"allStarLoading"]];
            //        image.image = [UIImage imageNamed:@"product_pic2"];
            
            
            
            UILabel *nameLabel = [self createLabel];
            nameLabel.numberOfLines = 0;
            //        nameLabel.text = @"阿斯顿见佛 史蒂夫奥神队赴澳拍速度发剖啊我肚佛史";
            nameLabel.text = prodcutDict[@"good_name"];
            
            
            
            UILabel *priceLabel = [self createLabel];
            priceLabel.text = [NSString stringWithFormat:@"¥%@",prodcutDict[@"pay_amount"]];
            //        priceLabel.text = @"1元";
            priceLabel.textAlignment = NSTextAlignmentRight;
            
            
            
            UILabel *quanLabel = [self createLabel];
            quanLabel.textAlignment = NSTextAlignmentRight;
            quanLabel.text = [NSString stringWithFormat:@"x%@",prodcutDict[@"good_number"]];
            //        quanLabel.text = @"x1";
            quanLabel.textColor = [UIColor lightGrayColor];
            
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = __kLineColor;
            
            [productCell sd_addSubviews:@[line,selectBtn,image,nameLabel,priceLabel,quanLabel]];
            [cell.contentView sd_addSubviews:@[productCell]];
            
            
            productCell.sd_layout
            .leftSpaceToView(cell.contentView, 0)
            .topSpaceToView(cell.contentView,productH*i)
            .heightIs(productH)
            .rightSpaceToView(cell.contentView,0);
            
            line.sd_layout
            .leftSpaceToView(productCell,0)
            .rightSpaceToView(productCell,0)
            .topSpaceToView(productCell,0)
            .heightIs(__kLine_Width_Height);
            
            selectBtn.sd_layout
            .leftSpaceToView(productCell, margin)
            .topSpaceToView(productCell,margin)
            .heightIs(productH)
            .widthIs(selectBtnW);
            
            image.sd_layout
            .leftSpaceToView(productCell, margin + selectBtnW)
            .topSpaceToView(productCell,margin)
            .heightIs(productH - 2*margin)
            .widthEqualToHeight();
            
            
            nameLabel.sd_layout
            .leftSpaceToView(productCell, productH + margin  + selectBtnW)
            .topSpaceToView(productCell,margin)
            .autoHeightRatio(0)
            .maxHeightIs(image.height)
            .rightSpaceToView(productCell,80);
            
            priceLabel.sd_layout
            .rightSpaceToView(productCell, margin)
            .topSpaceToView(productCell,0)
            .heightIs(40)
            .widthIs(90);
            
            quanLabel.sd_layout
            .rightSpaceToView(productCell, margin)
            .topSpaceToView(productCell,productH - 35)
            .heightIs(50)
            .widthIs(90);
            
            
        }
        
        
        
        
        return cell;
    }else if (indexPath.section == 3){
        [self addImages:cell];
        return cell;
    }else if (indexPath.section == 4){
        [cell.contentView addSubview:self.refundDescr];
        
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}





- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = Font(15);
    return label;
}


- (void)addImages:(UITableViewCell *)cell
{
    for (UIView *sView in cell.subviews) {
        if (sView.tag != 0) {
            [sView removeFromSuperview];
        }
    }
    
    CGFloat imageX = imageLeftX;
    CGFloat imageY = 0;
    for (int i = 0;i < _selectedPhotos.count;i++) {
        UIImage *image = _selectedPhotos[i];
        UIButton *imageBtn = [[UIButton alloc] init];
        imageBtn.tag = i + 200;
        [imageBtn setImage:image forState:UIControlStateNormal];
        //        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ((imageX + imageW) > (__kWindow_Width - imageLeftX)) {
            imageX = imageLeftX;
            imageY = imageY + imageH + imageMargin;
        }
        imageBtn.frame = CGRectMake(imageX, imageY, imageW, imageH);
        imageX = imageX + imageW + imageMargin;
        [cell.contentView addSubview:imageBtn];
        
    }
    
    if ((imageX + imageW) > (__kWindow_Width - imageLeftX)) {
        imageX = imageLeftX;
        imageY = imageY + imageH + imageMargin;
    }
    if (_selectedPhotos.count < maxImageCount) {
        UIButton *addImageBtn = [[UIButton alloc] init];
        addImageBtn.tag = 888;
        [addImageBtn setImage:[UIImage imageNamed:@"tapToAddImage-icon"] forState:UIControlStateNormal];
        [addImageBtn addTarget:self action:@selector(pickPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        addImageBtn.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [cell.contentView addSubview:addImageBtn];
    }
    
}


#pragma mark Click Event

- (IBAction)pickPhotoButtonClick:(UIButton *)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [sheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if (buttonIndex == 0 ) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self  presentViewController:picker animated:YES completion:nil];
        }
    }
    if (buttonIndex == 1 ) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImageCount delegate:self];
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
            
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img =  [info objectForKey:UIImagePickerControllerOriginalImage];
    [_selectedPhotos addObject:img];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
    //    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:imageCellNum inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}



#pragma mark TZImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [_selectedPhotos addObjectsFromArray:photos];
    [self.tableView reloadData];
    //    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:imageCellNum inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}



- (void)selectGood:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    NSMutableDictionary *dd = _goodsArr[index];
    [dd setObject:@(![dd[@"select"] boolValue]) forKey:@"select"];
    [self.tableView reloadData];
}

- (void)commit:(UIButton *)sender
{
    if (self.type ==1) {
        if (!self.refundDescr.text.length) {
            [MessageAlertView showWithMessage:@"请选择退款原因"];
            return;
        }
    }else if (self.type ==2){
        if (!self.refundWay.text.length) {
            [MessageAlertView showWithMessage:@"请选择退货方式"];
            return;
        }
        if (!_hideRefundStore) {
            if (!self.refundStore.text.length) {
                [MessageAlertView showWithMessage:@"请选择退货门店"];
                return;
            }
        }
        
        
        if (!self.refundDescr.text.length) {
            [MessageAlertView showWithMessage:@"请选择退货原因"];
            return;
        }
    }
    
    BOOL haveSelect = NO;
    
    
    for (NSMutableDictionary *dd in _goodsArr) {
        if ([dd[@"select"] boolValue]) {
            haveSelect = YES;
            break ;
        }
    }
    
    if (!haveSelect) {
        [MessageAlertView showWithMessage:@"请选择要结算的商品"];
        return;
    }
    
    if (!_selectedPhotos.count) {
        [MessageAlertView showWithMessage:@"请上传图片"];
        return;
    }
    
    
    NSMutableArray *postArray = [NSMutableArray array];
    
    for (NSMutableDictionary *dd in _goodsArr) {
        if ([dd[@"selected"] boolValue]) {
            [postArray addObject:dd[@"id"]];
        }
    }
    
    
    sender.userInteractionEnabled = NO;
    NSDictionary *postDict;
    
    
    if (self.type ==1) {
        postDict = @{@"id":self.soNo,
                     @"remark":_refundDescr.text?_refundDescr.text:@"",
                     @"type":@(self.type),
                     @"ids":postArray};
    }else if (self.type ==2){
        
        NSNumber *refund_good_type = @2;
        
        if ([self.refundWay.text isEqualToString:@"门店退货"]) {
            refund_good_type = @1;
        }else{
            _selectStoreId = @"";
        }
        
        postDict = @{@"id":self.soNo,
                     @"remark":_refundDescr.text?_refundDescr.text:@"",
                     @"type":@(self.type),
                     @"ids":postArray,
                     @"refund_good_type":refund_good_type,
                     @"store_id":_selectStoreId};
    }
    
    
    [[HttpManager shareInstance] post:@"deal_add_refund" parameter:postDict images:_selectedPhotos withHUDTitle:nil success:^(NSURLSessionDataTask *operation, id response) {
        
        NSLog(@"----返回数据：%@",response);
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MessageAlertView showWithMessage:@"操作成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            sender.userInteractionEnabled = YES;
            
        });
        
    }];
    
    
    
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
