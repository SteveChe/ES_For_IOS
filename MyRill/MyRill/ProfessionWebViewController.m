//
//  ProfessionWebViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/16.
//
//

#import "ProfessionWebViewController.h"

@interface ProfessionWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *professionWeb;

@end

@implementation ProfessionWebViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.professionWeb];
    self.navigationController.toolbar.hidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleDefault;

    UIBarButtonItem *btn1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:nil];
    UIBarButtonItem *btn2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:nil];
    UIBarButtonItem *btn3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
    UIBarButtonItem *btn4=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *arr1=[[NSArray alloc]initWithObjects:btn4,btn1,btn4,btn2,btn4,btn3,btn4, nil];
    self.toolbarItems=arr1;
    
    [self.navigationController.toolbar setBackgroundColor:[UIColor whiteColor]];
    //可以设置位置，但貌似无效果
    self.navigationController.toolbar.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.professionWeb loadRequest:request];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UIWebViewDelegate methods
//以下方法会在加载一个URL中多次调用(加载图片,加载js file,加载css,都有可能调用)
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError:%@", error);
}

#pragma mark - setters&getters
- (UIWebView *)professionWeb {
    if (!_professionWeb) {
        _professionWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _professionWeb.delegate = self;
    }
    
    return _professionWeb;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
}

@end
