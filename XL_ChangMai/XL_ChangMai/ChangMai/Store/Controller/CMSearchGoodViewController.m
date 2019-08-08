//
//  CMSearchGoodViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/7/19.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMSearchGoodViewController.h"
#import "CMGoodsViewController.h"
#define searchViewH  50
@interface CMSearchGoodViewController ()
@property(nonatomic,strong)UITextField *textFieldSearch;
@end

@implementation CMSearchGoodViewController

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
    [self createUI];
    [self requestData];
}



- (void)createUI
{
    UIView *statusView = [[UIView alloc] init];
    statusView.backgroundColor = [UIColor whiteColor];
    statusView.frame = CGRectMake(0, 0, __kWindow_Width, 20);
    [self.view addSubview:statusView];
    
    
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, __kWindow_Width, searchViewH)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    
    
    CGFloat searchBtnW = 70;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitleColor:__kThemeColor forState:UIControlStateNormal];
    searchBtn.titleLabel.font = Font(14);
    searchBtn.layer.borderColor = __kThemeColor.CGColor;
    searchBtn.layer.borderWidth = 1;
    searchBtn.layer.cornerRadius = 20;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(__kWindow_Width - 10 - searchBtnW, 5, searchBtnW, searchViewH - 10);
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
    
    
    
    UITextField *textFieldSearch = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, searchBtn.left - 10 - 10, searchViewH - 10)];
    textFieldSearch.backgroundColor = __kColor(251, 251, 251);
    textFieldSearch.layer.cornerRadius = 20;
    textFieldSearch.clipsToBounds = YES;
    textFieldSearch.font = Font(14);
    textFieldSearch.layer.borderColor = __kColor(200, 200, 200).CGColor;
    textFieldSearch.layer.borderWidth = 1;
    self.textFieldSearch = textFieldSearch;
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"seek_icon"];
    searchIcon.frame = CGRectMake(0, 0, 35, _textFieldSearch.height);
    searchIcon.contentMode = UIViewContentModeCenter;
    
    _textFieldSearch.placeholder = @"请输入商品名称";
    _textFieldSearch.leftView = searchIcon;
    _textFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    
    [searchView addSubview:_textFieldSearch];
    
    
}





#pragma mark - 请求 数据
-(void)requestData
{
    
    [[HttpManager shareInstance] get:@"search" parameter:nil withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        NSLog(@"----返回数据：%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self createHotSearchView:response[@"items"]];
        });
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
}



- (void)createHotSearchView:(NSArray *)hotArr
{
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.frame = CGRectMake(0, searchViewH + 20, __kWindow_Width, 50);
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.text = @"   热门搜索";
    hintLabel.textColor = [UIColor blackColor];
    hintLabel.font = Font(17);
    [self.view addSubview:hintLabel];
    
    
    CGFloat margin = 15;
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, hintLabel.bottom, __kWindow_Width, 0);
    [self.view addSubview:headView];
    
    CGFloat btnX = margin;
    CGFloat btnY = margin;
    CGFloat btnH = 40;
    for (NSString *title in hotArr) {
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.titleLabel.font = Font(14);
        searchBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        searchBtn.layer.borderWidth = 1;
        searchBtn.layer.cornerRadius = 20;
        searchBtn.layer.masksToBounds = YES;
        [searchBtn setTitle:title forState:UIControlStateNormal];
        CGFloat btnW = [title sizeWithFont:Font(14)].width + 45;
        
        if (btnX + btnW > (__kWindow_Width - margin)) {
            btnX = margin;
            btnY = btnY + btnH + margin;
        }
        
        searchBtn.frame = CGRectMake(btnX, btnY,btnW,btnH);
        [searchBtn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:searchBtn];
        
        btnX = btnX + btnW + margin;
        
    }
    
    headView.height = btnY + btnH + margin;
    
    
    
}



- (void)hotBtnClick:(UIButton *)sender
{
    
    CMGoodsViewController *goods = [[CMGoodsViewController alloc] init];
    goods.producutTitle = sender.titleLabel.text;
    goods.searchKeyword = sender.titleLabel.text;
    goods.sourceType = 1;
    [self.navigationController pushViewController:goods animated:YES];
}


- (void)searchBtnClick:(UIButton *)sender
{
    if (self.textFieldSearch.text.length == 0) {
        return;
    }
    CMGoodsViewController *goods = [[CMGoodsViewController alloc] init];
    goods.producutTitle = self.textFieldSearch.text;
    goods.searchKeyword = self.textFieldSearch.text;
    goods.sourceType = 1;
    [self.navigationController pushViewController:goods animated:YES];
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
