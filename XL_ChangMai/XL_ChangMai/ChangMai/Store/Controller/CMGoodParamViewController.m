//
//  CMGoodParamViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/8.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMGoodParamViewController.h"
#define cellH 50
@interface CMGoodParamViewController ()
@property (weak, nonatomic) UIWebView *webViewCustom;
@property (strong, nonatomic) NSDictionary *dataDict;
@property(nonatomic,strong)UIScrollView *scrollV;
@end

@implementation CMGoodParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpWebView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:__KUpdateGoodParamData object:nil];
}


#pragma mark - 请求 数据
-(void)loadData:(NSNotification *)notifica
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _dataDict = notifica.userInfo[@"data"];
        
        [self.tableView reloadData];
        
        NSString *paramStr = _dataDict[@"good"][@"intro"];
        
        NSString *webStr = [NSString stringWithFormat:@"%@%@%@",WEBVIEW_HEAD,paramStr,WEBVIEW_END];
        webStr = [webStr stringByReplacingOccurrencesOfString:@"\\" withString:@"" options:NSCaseInsensitiveSearch
                                                        range:NSMakeRange(0, webStr.length)];
        NSLog(@"---%@",webStr);
        
        [self.webViewCustom loadHTMLString:webStr baseURL:[NSURL URLWithString:BASE_URL]];
        
        
    });
    //
    //
    //
    //    } failure:^(NSURLSessionDataTask *operation, id response) {
    //
    //    }];
    
    
    
}


-(void)setUpWebView
{
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.frame = CGRectMake(0, 0, __kWindow_Width, __kWindow_Height - __KViewY);
    //    scrollV.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollV];
    self.scrollV = scrollV;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, __kWindow_Width, cellH*5)  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
    [self.scrollV addSubview:self.tableView];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIWebView *webViewCustom = [[UIWebView alloc] init];
    webViewCustom.frame = CGRectMake(0, self.tableView.bottom, __kWindow_Width, 0);
    webViewCustom.delegate = self;
    [self.scrollV addSubview:webViewCustom];
    _webViewCustom = webViewCustom;
    
    //    if (![_webUrlStr hasPrefix:@"http"]) {
    //        _webUrlStr = [@"http://" stringByAppendingString:_webUrlStr];
    //    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ProgressAlertView hideHUD];
    //    _backItem.enabled = _webViewCustom.canGoBack;
    //    _forwardItem.enabled = _webViewCustom.canGoForward;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGSize contentSize = webView.scrollView.contentSize;
        if (contentSize.height < 10) {
            contentSize = CGSizeMake(0, 0);
        }
        
        _webViewCustom.frame = CGRectMake(0, self.tableView.bottom + 9, __kWindow_Width, contentSize.height);
        _webViewCustom.scrollView.userInteractionEnabled = NO;
        
        self.scrollV.contentSize = CGSizeMake(__kWindow_Width, _webViewCustom.bottom);
        
    });
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ProgressAlertView hideHUD];
    
    NSLog(@"%@",[error localizedDescription]);
    
    [MessageAlertView showWithMessage:@"加载失败，请重试！"];
}


- (void)clickBack:(id)sender {
    [_webViewCustom goBack];
}

- (void)clickForward:(id)sender {
    [_webViewCustom goForward];
}

- (void)clickRefresh:(id)sender {
    
    
    [_webViewCustom reload];
    
}



#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    //    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.textLabel.font = Font(15);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = Font(15);
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"商品编码";
        cell.detailTextLabel.text = _dataDict[@"good"][@"part_number"];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"品牌";
        cell.detailTextLabel.text = _dataDict[@"good"][@"brand_title"];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"产地";
        cell.detailTextLabel.text = _dataDict[@"good"][@"source"];
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"有效期至";
        cell.detailTextLabel.text = _dataDict[@"good"][@"shelf_life"];
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"发货包装率";
        cell.detailTextLabel.text = _dataDict[@"good"][@"packing_ratio"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
