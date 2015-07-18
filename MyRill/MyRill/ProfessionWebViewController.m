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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.professionWeb loadRequest:request];
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
