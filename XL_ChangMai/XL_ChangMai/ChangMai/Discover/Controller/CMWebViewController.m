//
//  CMWebViewController.m
//  XL_ChangMai
//
//  Created by 李小龙 on 2019/8/1.
//  Copyright © 2019 李小龙. All rights reserved.
//

#import "CMWebViewController.h"

@interface CMWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) UIWebView *webViewCustom;

@end

@implementation CMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpWebView];
    if (self.webVcTitle.length) {
        self.title = self.webVcTitle;
        
    }
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [ProgressAlertView hideHUD];
        
    });
}


#pragma mark - 请求 数据
-(void)requestData
{
    [ProgressAlertView showWithMessage:@"加载中..."];
    NSDictionary *dict = @{@"id":self.webId};
    [[HttpManager shareInstance] get:@"page" parameter:dict withHUDTitle:@"" success:^(NSURLSessionDataTask *operation, id response) {
        //                NSLog(@"----返回数据：%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSString *webStr = [NSString stringWithFormat:@"%@%@%@",WEBVIEW_HEAD,response[@"item"][@"content"],WEBVIEW_END];
            webStr = [webStr stringByReplacingOccurrencesOfString:@"\\" withString:@"" options:NSCaseInsensitiveSearch
                                                            range:NSMakeRange(0, webStr.length)];
            NSLog(@"---%@",webStr);
            
            [self.webViewCustom loadHTMLString:webStr baseURL:[NSURL URLWithString:BASE_URL]];
            
            
        });
        
        
        
    } failure:^(NSURLSessionDataTask *operation, id response) {
        
    }];
    
    
    
}


-(void)setUpWebView
{
    UIWebView *webViewCustom = [[UIWebView alloc] init];
    webViewCustom.frame = self.view.bounds;
    webViewCustom.delegate = self;
    webViewCustom.backgroundColor = __kViewBgColor;
    [self.view addSubview:webViewCustom];
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
    
    /** 重新加载 */
    [ProgressAlertView showWithMessage:@"加载中..."];
    [_webViewCustom reload];
    
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
