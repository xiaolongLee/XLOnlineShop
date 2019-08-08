//
//  CMAddAddressViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/5.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMAddAddressViewController.h"
#import "RegionModel.h"
@interface CMAddAddressViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

/** 收货人 */
@property (nonatomic,weak) UITextField *textfieldContact;
/** 电话 */
@property (nonatomic,weak) UITextField *textfieldTell;
/** 身份证号 */
@property (nonatomic,weak) UITextField *textfieldIDNumber;
/** 省区 */
@property (nonatomic,weak) UITextField *textfieldArovince;
/** 详细地址 */
@property (nonatomic,weak) UITextField *textfieldAddress;
/** 地址 */
@property (nonatomic,strong) UIView *selectCityView;
/** 地址选择器 */
@property (nonatomic,strong) UIPickerView *pickView;

/** 记录第一请求 */
@property (nonatomic,assign) BOOL isFirst;
/** 所有地址 */
@property (nonatomic,strong) NSMutableArray *arrayAllRegion;
/** 省 */
@property (nonatomic,strong) NSMutableArray *arrayArovince;
/** 省id */
@property (nonatomic,strong) NSNumber * arovinceId;
/** 省名 */
@property (nonatomic,copy) NSString * arovinceName;

/** 市 */
@property (nonatomic,strong) NSMutableArray *arrayCity;
/** 市id */
@property (nonatomic,strong) NSNumber * cityId;
/** 市名 */
@property (nonatomic,copy) NSString * cityName;

@property (nonatomic,assign) BOOL isCity;

/** 区 */
@property (nonatomic,strong) NSMutableArray *arrayDistrict;
/** 区id */
@property (nonatomic,strong) NSNumber * districtId;
/** 区名 */
@property (nonatomic,copy) NSString * districtName;

@property (nonatomic,assign) BOOL isDistrict;

@end

@implementation CMAddAddressViewController

#pragma mark - 初始化数据
-(NSMutableArray *)arrayAllRegion
{
    if (!_arrayAllRegion) {
        _arrayAllRegion = [NSMutableArray array];
    }return _arrayAllRegion;
}

-(NSMutableArray *)arrayArovince
{
    if (!_arrayArovince) {
        _arrayArovince = [NSMutableArray array];
    }return _arrayArovince;
}
-(NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = [NSMutableArray array];
    }return _arrayCity;
}

-(NSMutableArray *)arrayDistrict
{
    if (!_arrayDistrict) {
        _arrayDistrict = [NSMutableArray array];
    }return _arrayDistrict;
}



-(UIView *)selectCityView
{
    if(!_selectCityView)
    {
        _selectCityView = [[UIView alloc] initWithFrame:self.view.bounds];
        _selectCityView.backgroundColor = __kColorR_G_B_A(0, 0, 0, 0.3);
        
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 8;
        whiteView.left = 10;
        whiteView.width = self.view.width - 20;
        [_selectCityView addSubview:whiteView];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = CGRectMake(0, 0, whiteView.width, 80);
        titleLabel.text = @"请选择区域";
        titleLabel.font = Font(20);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        [whiteView addSubview:titleLabel];
        
        UIView *line = [self createDefaultStyleLineFrame:CGRectMake(0, titleLabel.bottom, whiteView.width, __kLine_Width_Height)];
        [whiteView addSubview:line];
        
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, line.bottom, whiteView.width , 199)];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        [whiteView addSubview:_pickView];
        
        UIView *line1 = [self createDefaultStyleLineFrame:CGRectMake(0, _pickView.bottom, whiteView.width, __kLine_Width_Height)];
        [whiteView addSubview:line1];
        
        
        CGFloat btnW = 100;
        CGFloat btnH = 50;
        CGFloat btnMargin = (whiteView.width - 2*btnW)/3;
        
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setTitle:@"取消" forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(btnMargin,line1.bottom + 20, btnW, btnH);
        backBtn.layer.cornerRadius = 25;
        backBtn.layer.masksToBounds = YES;
        [backBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:backBtn];
        
        
        UIButton *confirmBtn = [[UIButton alloc] init];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.frame = CGRectMake(btnMargin*2 + btnW,line1.bottom + 20, btnW, btnH);
        confirmBtn.layer.cornerRadius = backBtn.layer.cornerRadius;
        confirmBtn.layer.masksToBounds = YES;
        [confirmBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:confirmBtn];
        
        
        whiteView.height = confirmBtn.bottom + 30;
        whiteView.top = (__kWindow_Height - whiteView.height)/2;
        return _selectCityView;
        
    }
    return _selectCityView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新增收获地址";
    _isFirst = YES;
    [self createUI];
    [self requestData];
    [self requestAddressWithId:nil];
}


- (void)createUI
{
    NSArray *leftTitle = @[@"收货人姓名",@"有效手机号码",@"收货人身份证号码",@"省、市、区",@"详细地址(不包含省份城市)"];
    
    CGFloat margin = 10;
    CGFloat lineMargin = 10;
    CGFloat textFieldH = 40;
    NSInteger numCount = leftTitle.count;
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, __KViewY, __kWindow_Width,lineMargin*(numCount+1) + numCount*textFieldH );
    topView.backgroundColor = __kContentBgColor;
    [self.view addSubview:topView];
    
    for (int i = 0; i < numCount; i ++) {
        
        UITextField *textF = [self createDefaultStyleTextFieldFrame:CGRectMake(margin, lineMargin*(i+1) + i*textFieldH, __kWindow_Width - 2*margin, textFieldH)];
        textF.placeholder = leftTitle[i];
        textF.tag = 100 + i;
        
        
        
        
        switch (i) {
            case 0:
                self.textfieldContact = textF;
                self.textfieldContact.rightViewMode = UITextFieldViewModeNever;
                break;
            case 1:{
                self.textfieldTell = textF;
                self.textfieldTell.rightView = [[UIView alloc] init];
                self.textfieldTell.rightViewMode = UITextFieldViewModeNever;
                self.textfieldTell.keyboardType = UIKeyboardTypeNumberPad;
                
            }
            case 2:{
                self.textfieldIDNumber = textF;
                self.textfieldIDNumber.rightView = [[UIView alloc] init];
                self.textfieldIDNumber.rightViewMode = UITextFieldViewModeNever;
                
            }
            case 3:{
                self.textfieldArovince = textF;
                
            }
                break;
            case 4:
                self.textfieldAddress = textF;
                self.textfieldAddress.rightViewMode = UITextFieldViewModeNever;
                
                break;
            default:
                break;
        }
        
        [topView addSubview:textF];
    }
    
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 40, textFieldH);
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_arrow"]];
    rightImageView.frame = CGRectMake(13, 0, 14, textFieldH);
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightView addSubview:rightImageView];
    
    self.textfieldArovince.rightView = rightView;
    self.textfieldArovince.rightViewMode = UITextFieldViewModeAlways;
    
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = self.textfieldArovince.frame;
    [btn addTarget:self action:@selector(showSelectCity) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"新增收获地址" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(60,topView.bottom + 50, __kWindow_Width - 2*60, 50);
    backBtn.layer.cornerRadius = 25;
    backBtn.layer.masksToBounds = YES;
    [backBtn setBackgroundColor:__kThemeColor forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    
}




#pragma mark - 请求 数据
-(void)requestData
{
    
    if (self.addressId) {
        
        NSDictionary *dict = @{@"id":@(self.addressId)};
        
        [[HttpManager shareInstance] get:@"shipping" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
            NSLog(@"----返回数据：%@",response);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                1.    name    收货人姓名
                //
                //                2.    phone    收货人电话
                //
                //                3.    address    收货人地址
                //
                //                4.    id_card    收货人身份证号码
                //
                //                5.    province    收货人省
                //
                //                6.    city        收货人城市
                //
                //                7.    district    收货人区县
                //
                //                8.    aid        收货人省市区县编号
                
                _textfieldContact.text = response[@"name"];
                _textfieldTell.text = response[@"phone"];
                _textfieldIDNumber.text = [NSString stringWithFormat:@"%@",response[@"id_card"]];
                
                
                NSString *str;
                if (![response[@"province"] isEqualToString:response[@"city"]]) {
                    str = [NSString stringWithFormat:@"%@%@%@",response[@"province"],response[@"city"],response[@"district"]];
                }else
                    str = [NSString stringWithFormat:@"%@%@",response[@"province"],response[@"district"]];
                
                _textfieldArovince.text = str;
                
                
                _textfieldAddress.text = response[@"address"];
                
                
            });
            
        } failure:^(NSURLSessionDataTask *operation, id response) {
            
        }];
    }
    
    
    
    
}



#pragma mark --- 请求数据
-(void)requestAddressWithId:(NSNumber *)addId
{
    
    if (addId) {
        NSNumber *parentId = addId ;
        
        if (_isCity) {
            [_arrayCity removeAllObjects];
            for (RegionModel *region in self.arrayAllRegion) {
                
                if ([region.parentId intValue] == [parentId intValue]) {
                    [_arrayCity addObject:region];
                }
                
            }
            
            _cityId = [_arrayCity[0] regionId];
            _cityName = [_arrayCity[0]regionName];
            [_pickView reloadComponent:1];
            
            _isCity = NO;
            _isDistrict = YES;
            
            [self requestAddressWithId:[_arrayCity[0] regionId]];
            
        }else if (_isDistrict)
        {
            [_arrayDistrict removeAllObjects];
            for (RegionModel *region in self.arrayAllRegion) {
                
                if ([region.parentId intValue] == [parentId intValue]) {
                    [_arrayDistrict addObject:region];
                }
                
            }
            _districtId = [_arrayDistrict[0] regionId];
            _districtName = [_arrayDistrict[0]regionName];
            [_pickView reloadComponent:2];
            
        }
        
    }
    else
    {
        
        //读取plist
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        NSLog(@"%@",plistPath);
        NSArray *temp = [[NSArray alloc] initWithContentsOfFile:plistPath];
        self.arrayAllRegion = [RegionModel getArrayWithArray:temp];
        NSLog(@"%lu",(unsigned long)[self.arrayAllRegion count]);
        
        for (RegionModel *region in self.arrayAllRegion) {
            if ([region.parentId intValue] == 1) {//省自治区
                [self.arrayArovince addObject:region];
            }
            
            if (_isFirst) {
                _arovinceId = [_arrayArovince[0] regionId];
                _arovinceName = [_arrayArovince[0] regionName];
                
                if ([region.parentId intValue] == 2) {//默认显示北京的
                    [self.arrayCity addObject:region];
                    _cityId = [region regionId];
                    _cityName = [region regionName];
                }
                
                if ([region.parentId intValue]== 52) {//默认北京区
                    [self.arrayDistrict addObject:region];
                    _districtId = [region regionId];
                    _districtName = [region regionName];
                }
                
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_pickView reloadComponent:0];
            [_pickView reloadComponent:1];
            [_pickView reloadComponent:2];
        });
        
        
    }
    
}




- (void)confirmBtnClick:(UIButton *)sender
{
    
    [self.selectCityView removeFromSuperview];
    
    [_textfieldArovince resignFirstResponder];
    
    NSString *str;
    if (![_arovinceName isEqualToString:_cityName]) {
        str = [NSString stringWithFormat:@"%@%@%@",_arovinceName,_cityName,_districtName];
    }else
        str = [NSString stringWithFormat:@"%@%@",_cityName,_districtName];
    
    _textfieldArovince.text = str;
    
    _textfieldArovince.placeholder = @"";
}


- (void)cancelBtnClick:(UIButton *)sender
{
    [self.selectCityView removeFromSuperview];
    [_textfieldArovince resignFirstResponder];
}

-(void)alertWithMessage:(NSString *)message
{
    [MessageAlertView showWithMessage:message];
    
}

- (void)saveBtnClick:(UIButton *)sender
{
    
    
    NSString *contact = _textfieldContact.text;
    if (contact.length == 0 ) {
        [self alertWithMessage:@"请输入收货人姓名"];
        return;
    }
    
    NSString *tell = [_textfieldTell.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tell.length !=11 || ![self isValidateMobile:tell] ) {
        [self alertWithMessage:@"请正确输入手机号"];
        return;
    }
    
    NSString *cerId = [_textfieldIDNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (cerId.length !=18) {
        [self alertWithMessage:@"请正确输入收货人身份证号码"];
        return;
    }
    
    NSString *cityAddress = [_textfieldArovince.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!cityAddress.length) {
        [self alertWithMessage:@"请选择省市区"];
        return;
    }
    
    
    NSString *detailAddress = [_textfieldAddress.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!detailAddress.length) {
        [self alertWithMessage:@"请输入详细地址"];
        return;
    }
    
    
    NSString *areaStr;
    if (![_arovinceName isEqualToString:_cityName]) {
        areaStr = [NSString stringWithFormat:@"%@,%@,%@",_arovinceName,_cityName,_districtName];
    }else
        areaStr = [NSString stringWithFormat:@"%@,%@",_cityName,_districtName];
    
    NSString *aidStr;
    aidStr = [NSString stringWithFormat:@"%@,%@,%@",_arovinceId,_cityId,_districtId];
    
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary: @{@"name":contact,
                                                                                    @"phone":tell,
                                                                                    @"id_card":cerId,
                                                                                    @"area":areaStr,
                                                                                    @"address":detailAddress,
                                                                                    @"aid":aidStr}];
    
    
    NSLog(@"%@",postDic);
    
    
    
    [ProgressAlertView showWithMessage:@"提交中..."];
    
    if (self.addressId) {//修改地址
        
        [postDic setObject:@(self.addressId) forKey:@"id"];
        
        [[HttpManager shareInstance] post:@"deal_update_shipping" parameter:postDic withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
            //        NSLog(@"----返回数据：%@",response);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressAlertView hideHUD];
                [MessageAlertView showWithMessage:response[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        } failure:^(NSURLSessionDataTask *operation, id response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressAlertView hideHUD];
                [MessageAlertView showWithMessage:response[@"msg"]];
            });
        }];
    }else{//增加地址
        [[HttpManager shareInstance] post:@"deal_add_shipping" parameter:postDic withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
            NSLog(@"----返回数据：%@",response);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressAlertView hideHUD];
                [MessageAlertView showWithMessage:response[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        } failure:^(NSURLSessionDataTask *operation, id response) {
            NSLog(@"----返回数据：%@",response);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressAlertView hideHUD];
                [MessageAlertView showWithMessage:response[@"msg"]];
            });
        }];
    }
    
}

- (void)showSelectCity
{
    [self.view endEditing:YES];
    [self.view addSubview:self.selectCityView];
    
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        NSLog(@"-----%s-----",__func__);
        
        [_arrayCity removeAllObjects];
        _isCity = YES;
        _isDistrict = NO;
        _arovinceId = [_arrayArovince[row] regionId];
        _arovinceName = [_arrayArovince[row]regionName];
        [self requestAddressWithId:[_arrayArovince[row]regionId]];
        
    }else if (component == 1)
    {
        
        NSLog(@"-----%s-----",__func__);
        
        [_arrayDistrict removeAllObjects];
        _isCity = NO;
        _isDistrict = YES;
        [self requestAddressWithId:[_arrayCity[row]regionId]];
        _cityId = [_arrayCity[row]regionId];
        _cityName = [_arrayCity[row]regionName];
        
    }else
    {
        _districtId = [_arrayDistrict[row]regionId];
        _districtName = [_arrayDistrict[row]regionName];
        
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    
    NSLog(@"-----%s-----",__func__);
    
    if (component == 0) {
        return  [_arrayArovince[row] regionName];
        
    }else if (component == 1)
    {
        if (_arrayCity.count) {
            return [_arrayCity[row]regionName];
        }
        
    }else if (component == 2)
    {
        if (_arrayDistrict.count) {
            return [_arrayDistrict[row]regionName];;
        }
    }
    
    
    
    return str;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 36;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _arrayArovince.count;
    }else if (component ==1)
    {
        return _arrayCity.count;
    }else
        return _arrayDistrict.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
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
