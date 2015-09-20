//
//  ProfessionWebViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/16.
//
//

#import "ProfessionWebViewController.h"
#import "Masonry.h"
#import "GetProfessionDataParse.h"
#import "ESProfession.h"
#import "CustomShowMessage.h"

@interface ProfessionWebViewController () <UIWebViewDelegate, GetProfessionDelegate>

@property (nonatomic, strong) UIWebView *professionWeb;
@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) GetProfessionDataParse *getProfessionDP;

@end

@implementation ProfessionWebViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.professionWeb];
    [self.view addSubview:self.toolbar];
    
    __weak UIView *ws = self.view;
    __weak UIView *wToolbar = self.toolbar;
    [self.professionWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top);
        make.leading.equalTo(ws.mas_leading);
        make.trailing.equalTo(ws.mas_trailing);
        make.bottom.equalTo(wToolbar.mas_top).with.offset(49);
    }];
    
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(ws.mas_leading);
        make.trailing.equalTo(ws.mas_trailing);
        make.bottom.equalTo(ws.mas_bottom);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    if (self.type == ESWebProfessionWithURL) {
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        [self.professionWeb loadRequest:request];
    } else {
        [self.getProfessionDP getProfessionWithProfessionID:self.professionID];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

//放到Did里面不好使
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)getProfessionSuccess:(ESProfession *)profession {
    NSURL *url = [NSURL URLWithString:profession.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [self.professionWeb loadRequest:request];
}

- (void)getProfessionFailure:(NSString *)errorMsg {
    [[CustomShowMessage getInstance] showNotificationMessage:errorMsg];
}

#pragma mark - UIWebViewDelegate methods
//以下方法会在加载一个URL中多次调用(加载图片,加载js file,加载css,都有可能调用)
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"webViewDidFinishLoad");
    UIBarButtonItem *back = (UIBarButtonItem *)[self.navigationController.toolbar viewWithTag:301];
    back.enabled = self.professionWeb.canGoBack ? YES : NO;
    back.image = self.professionWeb.canGoBack ? [[UIImage imageNamed:@"后退-可点"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]:[[UIImage imageNamed:@"后退-不可点"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *forward = (UIBarButtonItem *)[self.navigationController.toolbar viewWithTag:302];
    forward.enabled = self.professionWeb.canGoForward ? YES : NO;
    forward.image = self.professionWeb.canGoForward ? [[UIImage imageNamed:@"前进-可点"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] :[[UIImage imageNamed:@"前进-不可点"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
        _professionWeb = [[UIWebView alloc] init];
        _professionWeb.delegate = self;
    }
    
    return _professionWeb;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
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
        NSArray *itemArray = [[NSArray alloc] initWithObjects:placeHolderItem, backItem,placeHolderItem, forwardItem, placeHolderItem,placeHolderItem, placeHolderItem, placeHolderItem, reloadItem, placeHolderItem, nil];
        
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.backgroundColor = [UIColor whiteColor];
        _toolbar.barStyle = UIBarStyleDefault;
        _toolbar.items = itemArray;
    }
    
    return _toolbar;
}

- (GetProfessionDataParse *)getProfessionDP {
    if (!_getProfessionDP) {
        _getProfessionDP = [[GetProfessionDataParse alloc] init];
        _getProfessionDP.delegate = self;
    }
    
    return _getProfessionDP;
}

@end
