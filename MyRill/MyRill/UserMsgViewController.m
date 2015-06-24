//
//  UserMsgViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "UserMsgViewController.h"
#import "ColorHandler.h"
#import "Masonry.h"
#import "UserSettingViewController.h"

@interface UserMsgViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *staticArray;

@end

@implementation UserMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    self.view.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"];
    self.staticArray = @[@"头像", @"用户名", @"企业", @"岗位", @"企业二维码", @"个人二维码", @"简介", @"加入企业"];
    
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                      target:self
                                                                      action:@selector(settingBtnItemOnClicked:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UserMsgCell"];
    [self layoutPageView];
}

- (void)layoutPageView {
    __weak UIView *ws = self.view;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top).offset(10);
        make.leading.equalTo(ws.mas_leading);
        make.trailing.equalTo(ws.mas_trailing);
        make.height.mas_equalTo(44 * 7 + 80);
    }];
}

#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserMsgCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserMsgCell"];
    }
    cell.textLabel.text = @"asdf";
    return cell;
}

#pragma mark - response events
- (void)settingBtnItemOnClicked:(UIBarButtonItem *)sender {
    UserSettingViewController *settingVC = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - setter&getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *fillView = [UIView new];
        _tableView.tableFooterView = fillView;
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logoutBtn.backgroundColor = [UIColor redColor];
        logoutBtn.layer.cornerRadius = 19.0;
        
        [_tableView.tableFooterView addSubview:logoutBtn];
        __weak UIView *wt = _tableView.tableFooterView;
        [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(wt).with.insets(UIEdgeInsetsMake(8, 20, 8, 20)).with.priority(751);
            make.height.mas_equalTo(44).with.priority(751);
            //            make.top.equalTo(ws.mas_bottom).with.offset(8);
            //            make.bottom.equalTo(ws.mas_bottom).with.offset(8);
            //            make.leading.equalTo(ws.mas_leading).with.offset(20);
            //            make.trailing.equalTo(ws.mas_trailing).with.offset(20);
        }];
    }
    
    return _tableView;
}

@end
