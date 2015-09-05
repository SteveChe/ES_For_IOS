//
//  ProfessionWebViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/16.
//
//

#import "ProfessionWebViewController.h"
#import "Masonry.h"

@interface ProfessionWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *professionWeb;

@end

@implementation ProfessionWebViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.professionWeb];
   
    UIImage *backImg = [UIImage imageNamed:@"后退-可点"];
    backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem   = [[UIBarButtonItem alloc] initWithImage:backImg
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backToPre:)];
    backItem.tag = 301;
    
    UIImage *forwardImg = [UIImage imageNamed:@"前进-可点"];
    forwardImg = [forwardImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithImage:forwardImg
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(forwardToNext:)];
    forwardItem.tag = 302;

    UIImage *reloadImg = [UIImage imageNamed:@"刷新-可点"];
    reloadImg = [reloadImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithImage:reloadImg
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(reloadPage:)];
    reloadItem.tag = 303;
    UIBarButtonItem *placeHolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                     target:self
                                                                                     action:nil];
    NSArray *itemArray = [[NSArray alloc] initWithObjects:placeHolderItem,backItem,placeHolderItem,forwardItem,placeHolderItem,reloadItem,placeHolderItem, nil];
    self.toolbarItems = itemArray;
    
    [self.navigationController.toolbar setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.toolbar.barStyle = UIBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.professionWeb loadRequest:request];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setToolbarHidden:NO animated:YES];

    UIBarButtonItem *back = (UIBarButtonItem *)[self.navigationController.toolbar viewWithTag:301];
    back.enabled = self.professionWeb.canGoBack ? YES : NO;
    UIBarButtonItem *forward = (UIBarButtonItem *)[self.navigationController.toolbar viewWithTag:302];
    forward.enabled = self.professionWeb.canGoForward ? YES : NO;
}

//需要每次重置toolbar的位置
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.navigationController.toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44 + 64, self.view.frame.size.width, 44);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - UIWebViewDelegate methods
//以下方法会在加载一个URL中多次调用(加载图片,加载js file,加载css,都有可能调用)
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"didFailLoadWithError:%@", error);
}

#pragma mark - response events
//后退-->页面
- (void)backToPre:(UIBarButtonItem *)sender {
    [self.professionWeb goBack];
}

//前进-->页面
- (void)forwardToNext:(UIBarButtonItem *)sender {
    [self.professionWeb goForward];
}

//刷新-->页面
- (void)reloadPage:(UIBarButtonItem *)sender {
    [self.professionWeb reload];
}

#pragma mark - setters&getters
- (UIWebView *)professionWeb {
    if (!_professionWeb) {
        _professionWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _professionWeb.delegate = self;
    }
    
    return _professionWeb;
}

@end
