//
//  BMCSubResourceDetailViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "BMCSubResourceDetailViewController.h"
#import "BMCGetSubResourceMetricListDataParse.h"

@interface BMCSubResourceDetailViewController ()

@property (nonatomic, strong) BMCGetSubResourceMetricListDataParse *getSubResourceMetricListDP;

@end

@implementation BMCSubResourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"!!!!! %@",self.subResId);
    [self.getSubResourceMetricListDP getSubResourceMetricListWithSubResId:self.subResId];
}

- (BMCGetSubResourceMetricListDataParse *)getSubResourceMetricListDP {
    if (!_getSubResourceMetricListDP) {
        _getSubResourceMetricListDP = [[BMCGetSubResourceMetricListDataParse alloc] init];
        //        _getSubResourceMetricListDP.
    }
    
    return _getSubResourceMetricListDP;
}

@end
